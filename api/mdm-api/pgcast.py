#!/usr/bin/env python

import datetime
import uuid
from decimal import Decimal

import psycopg2
import psycopg2.extensions as _ext
import psycopg2.extras
import re


def pg_typ_caster(connection, nspname, typname, mapclass):
    def _get_pg_nspname_oid():
        _sql = 'SELECT oid FROM pg_namespace WHERE nspname = %s'
        try:
            _curs = connection.cursor()
            _curs.execute(_sql, (nspname,))
            _oid = _curs.fetchone()[0]
            _curs.close()
            return _oid
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)

    def _get_pg_typname_oid():
        _sql = 'SELECT oid FROM pg_type WHERE typname = %s AND typnamespace = %s;'
        try:
            _nspoid = _get_pg_nspname_oid()
            _curs = connection.cursor()
            _curs.execute(_sql, (typname, _nspoid,))
            _oid = _curs.fetchone()[0]
            _curs.close()
            return _oid
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)

    def _get_pg_typarray_oid():
        _sql = 'SELECT typarray FROM pg_type WHERE typname = %s AND typnamespace = %s'
        try:
            _nspoid = _get_pg_nspname_oid()
            _curs = connection.cursor()
            _curs.execute(_sql, (typname, _nspoid,))
            _oid = _curs.fetchone()[0]
            _curs.close()
            return _oid
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)

    oid1 = _get_pg_typname_oid()
    oid2 = _get_pg_typarray_oid()

    pg_udf_type = _ext.new_type((oid1,), typname.upper(), mapclass)
    pg_udf_type_array = _ext.new_array_type((oid2,), "{0}_ARRAY".format(typname.upper()), pg_udf_type)

    _ext.register_type(pg_udf_type, connection)
    _ext.register_type(pg_udf_type_array, connection)

    return pg_udf_type


def parse_string_from_dict(dict_object, dict_element):
    try:
        _result = dict_object[dict_element]
    except (Exception, KeyError):
        _result = None
    return _result


def parse_int_from_dict(dict_object, dict_element):
    try:
        if dict_object[dict_element]:
            _result = int(dict_object[dict_element])
        else:
            _result = None
    except (Exception, KeyError):
        _result = None
    return _result


def parse_decimal_from_dict(dict_object, dict_element):
    try:
        if dict_object[dict_element]:
            _result = Decimal(dict_object[dict_element])
        else:
            _result = None
    except (Exception, KeyError):
        _result = None
    return _result


def parse_date_from_dict(dict_object, dict_element):
    try:
        if len(dict_object[dict_element]) > 0:
            _result = date_from_string(dict_object[dict_element])
        else:
            _result = None
    except (Exception, KeyError):
        _result = None
    return _result


def parse_uuid_from_dict(dict_object, dict_element):
    try:
        _result = uuid.UUID(dict_object[dict_element])
    except (Exception, KeyError):
        _result = None
    return _result


def parse_string_from_tuple(tuple_object, tuple_element):
    try:
        _result = tuple_object[tuple_element]
    except (Exception, IndexError):
        _result = None
    return _result


def parse_int_from_tuple(tuple_object, tuple_element):
    try:
        if tuple_object[tuple_element]:
            _result = int(tuple_object[tuple_element])
        else:
            _result = None
    except (Exception, IndexError):
        _result = None
    return _result


def parse_decimal_from_tuple(tuple_object, tuple_element):
    try:
        if tuple_object[tuple_element]:
            _result = Decimal(tuple_object[tuple_element])
        else:
            _result = None
    except (Exception, IndexError):
        _result = None
    return _result


def parse_date_from_tuple(tuple_object, tuple_element):
    try:
        if len(tuple_object[tuple_element]) > 0:
            _result = date_from_string(tuple_object[tuple_element])
        else:
            _result = None
    except (Exception, IndexError):
        _result = None
    return _result


def parse_interval_from_tuple(tuple_object, tuple_element):
    try:
        _result = _ext.PYINTERVAL(tuple_object[tuple_element], None)
    except (Exception, IndexError):
        _result = None
    return _result


def parse_uuid_from_tuple(tuple_object, tuple_element):
    try:
        _result = uuid.UUID(tuple_object[tuple_element])
    except (Exception, IndexError):
        _result = None
    return _result


def date_from_string(str_date):
    if str_date and len(str_date) > 0:
        return datetime.datetime.strptime(str_date, "%Y-%m-%d")
    else:
        return None


def date_to_string(pydate):
    if pydate:
        return pydate.strftime('%Y-%m-%d')
    else:
        return None


def decimal_to_string(pydecimal, precision=4):
    if pydecimal:
        return float("{0:.{1}f}".format(pydecimal, precision))
    else:
        return None


def uuid_to_string(pyuuid):
    if pyuuid:
        return str(pyuuid)
    else:
        return None


class PgUserTypeMaping(object):
    pg_schm_name = ''
    pg_type_name = ''
    pg_field_list = []

    def __conform__(self, proto):
        if proto == _ext.ISQLQuote:
            return self

    def date_from_py(self, pydate):
        pass

    def date_from_pg(self, sqldate):
        pass

    def decimal_from_py(self, pydecimal):
        pass

    def decimal_from_pg(self, sqlnumeric):
        pass

    def py2pg_adapt(self, o):
        if o is None:
            return 'NULL'
        else:
            if isinstance(o, str):
                return "'{0}'".format(o)
            elif isinstance(o, int):
                return o
            elif isinstance(o, Decimal):
                return o
            elif isinstance(o, datetime.date):
                return _ext.DateFromPy(o)
            elif isinstance(o, datetime.timedelta):
                return _ext.IntervalFromPy(o)
            else:
                # return _ext.adapt(obj=o, alternate=None, protocol=None)
                return _ext.adapt(o, None, None)

    _re_tokenize = re.compile(r"""
      \(? ([,)])                        # an empty token, representing NULL
    | \(? " ((?: [^"] | "")*) " [,)]    # or a quoted string
    | \(? ([^",)]+) [,)]                # or an unquoted string
        """, re.VERBOSE)

    _re_undouble = re.compile(r'(["\\])\1')

    def from_tuple(self, t):
        return self

    def to_tuple(self):
        return ()

    def from_dict(self, d):
        return self

    def to_dict(self):
        return {}

    def __repr__(self):
        return self.repr_helper(self.pg_field_list).format(t=self.pg_type_name, d=self.to_dict())

    def repr_helper(self, field_list):
        result = '{t}=('
        idx = 1
        length = len(field_list)
        for item in field_list:
            if idx < length:
                result = result + "{0}={1}{0}{2} ".format(item, '{d[', ']},')
            else:
                result = result + "{0}={1}{0}{2} ".format(item, '{d[', ']})')
            idx += 1
        return result

    def from_string(self, s):
        rv = []
        for m in self._re_tokenize.finditer(s):
            if m is None:
                raise psycopg2.InterfaceError("bad pgtype representation: %r" % s)
            if m.group(1) is not None:
                rv.append(None)
            elif m.group(2) is not None:
                rv.append(self._re_undouble.sub(r"\1", m.group(2)))
            else:
                rv.append(m.group(3))

        self.from_tuple(tuple(rv))

    def adapt_tuple(self, t):
        result = []
        for i in t:
            result.append(self.py2pg_adapt(i))
        return tuple(result)

    def repr_helper2(self, field_list):
        result = '('
        idx = 0
        length = len(field_list) - 1
        for item in field_list:
            if idx < length:
                result = result + "{1}{0}{2} ".format(idx, '{t[', ']},')
            else:
                result = result + "{1}{0}{2}::{3}.{4} ".format(idx, '{t[', ']})', '{schema}', '{pgtype}')
            idx += 1
        return result

    def getquoted(self):
        return self.repr_helper2(self.pg_field_list) \
            .format(schema=self.pg_schm_name, pgtype=self.pg_type_name, t=self.adapt_tuple(self.to_tuple()))

    def _complex_string_to_list(self, s):
        if s == '{}':
            return ()
        s = s.replace("{\"", "")
        s = s.replace("\"}", "")
        result = s.split("\",\"")
        if len(result) > 0:
            return tuple(result)
        else:
            return ()

    def _adapt_list_to_dict(self, spec_list):
        _res = []
        for s in spec_list:
            _res.append(s.to_dict())
        return tuple(_res)


# class FacilityKind(PgUserTypeMaping):
#    pg_schm_name = 'common',
#    pg_type_name = 'facility_kind'
#    pg_field_list = []


class InventoryKind(PgUserTypeMaping):
    pg_schm_name = 'common',
    pg_type_name = 'inventory_kind'
    pg_field_list = []

    def __init__(self, s=None, curs=None):
        self.val = None
        if s:
            self.from_string(s)
            print(self)

    def __conform__(self, proto):
        if proto == _ext.ISQLQuote:
            return self

    # create
    def from_set(self, s):
        # print("FROM SET ", self.val)
        self.val = s

    def to_dict(self):
        pass
        # print("to DICT ", self.val)
        # return self.val

    def from_dict(self, d):
        pass
        # print("FROM DICT ", d)
        # self.val = self.from_set(set(d))

    # get
    def from_tuple(self, t):
        #print("FROM TUPLE ", t)
        self.val = t[0]

    def to_tuple(self):
        pass
        #print("to TUPLE ", self.val)
        #return (self.val)

    def __repr__(self):
        return "'{0}'::common.inventory_kind".format(self.val)

    # get
    def from_string(self, s):
        #print("FROM string ")
        #print('strng to parse', s)
        rv = []
        rv.append(s)
        self.from_tuple(tuple(rv))

    # create
    def getquoted(self):
        #print("get quoted ")
        return "'{0}'::common.inventory_kind".format(self.val)


class FacilityHead(PgUserTypeMaping):
    pg_schm_name = 'common'
    pg_type_name = 'facility_head'
    pg_field_list = ['id', 'gid', 'facility_code',
                     'version_num', 'display_name', 'document_date',
                     'parent_facility_code', 'facility_type']

    def __init__(self, s=None, curs=None):
        self.id = None
        self.gid = None
        self.facility_code = None
        self.version_num = None
        self.display_name = None
        self.document_date = None
        self.parent_facility_code = None
        self.facility_type = None
        if s:
            self.from_string(s)
            print(self)

    def to_dict(self):
        return {"id": self.id,
                "gid": self.gid,
                "facility_code": self.facility_code,
                "version_num": self.version_num,
                "display_name": self.display_name,
                "document_date": date_to_string(self.document_date),
                "parent_facility_code": self.parent_facility_code,
                "facility_type": self.facility_type}

    def from_dict(self, d):
        self.id = parse_int_from_dict(d, 'id')
        self.gid = parse_uuid_from_dict(d, 'gid')
        self.facility_code = parse_string_from_dict(d, 'facility_code')
        self.version_num = parse_int_from_dict(d, 'version_num')
        self.display_name = parse_string_from_dict(d, 'display_name')
        self.document_date = parse_date_from_dict(d, 'document_date')
        self.parent_facility_code = parse_string_from_dict(d, 'parent_facility_code')
        self.facility_type = parse_string_from_dict(d, 'facility_type')
        print(self)

    def from_tuple(self, t):
        self.id = parse_int_from_tuple(t, 0)
        self.gid = parse_uuid_from_tuple(t, 1)
        self.facility_code = parse_string_from_tuple(t, 2)
        self.version_num = parse_int_from_tuple(t, 3)
        self.display_name = parse_string_from_tuple(t, 4)
        self.document_date = parse_date_from_tuple(t, 5)
        self.parent_facility_code = parse_string_from_tuple(t, 6)
        self.facility_type = parse_string_from_tuple(t, 7)

    def to_tuple(self):
        return (self.id,
                uuid_to_string(self.gid),
                self.facility_code,
                self.version_num,
                self.display_name,
                self.document_date,
                self.parent_facility_code,
                self.facility_type)


class InventoryHead(PgUserTypeMaping):
    pg_schm_name = 'common'
    pg_type_name = 'inventory_head'
    pg_field_list = ['id', 'gid', 'display_name',
                     'part_code', 'version_num', 'document_date',
                     'uom_code', 'curr_fsmt', 'document_type']

    def __init__(self, s=None, curs=None):
        self.id = None
        self.gid = None
        self.display_name = None
        self.part_code = None
        self.version_num = None
        self.document_date = None
        self.uom_code = None
        self.curr_fsmt = None
        self.document_type = None
        if s:
            self.from_string(s)
            print(self)

    def to_dict(self):
        return {"id": self.id,
                "gid": self.gid,
                "display_name": self.display_name,
                "part_code": self.part_code,
                "version_num": self.version_num,
                "document_date": date_to_string(self.document_date),
                "uom_code": self.uom_code,
                "curr_fsmt": self.curr_fsmt,
                "document_type": self.document_type}

    def from_dict(self, d):
        self.id = parse_int_from_dict(d, 'id')
        self.gid = parse_uuid_from_dict(d, 'gid')
        self.display_name = parse_string_from_dict(d, 'display_name')
        self.part_code = parse_string_from_dict(d, 'part_code')
        self.version_num = parse_int_from_dict(d, 'version_num')
        self.document_date = parse_date_from_dict(d, 'document_date')
        self.uom_code = parse_string_from_dict(d, 'uom_code')
        self.curr_fsmt = parse_string_from_dict(d, 'curr_fsmt')
        self.document_type = parse_string_from_dict(d, 'document_type')
        print(self)

    def from_tuple(self, t):
        self.id = parse_int_from_tuple(t, 0)
        self.gid = parse_uuid_from_tuple(t, 1)
        self.display_name = parse_string_from_tuple(t, 2)
        self.part_code = parse_string_from_tuple(t, 3)
        self.version_num = parse_int_from_tuple(t, 4)
        self.document_date = parse_date_from_tuple(t, 5)
        self.uom_code = parse_string_from_tuple(t, 6)
        self.curr_fsmt = parse_string_from_tuple(t, 7)
        self.document_type = parse_string_from_tuple(t, 8)

    def to_tuple(self):
        return (self.id,
                uuid_to_string(self.gid),
                self.display_name,
                self.part_code,
                self.version_num,
                self.document_date,
                self.uom_code,
                self.curr_fsmt,
                self.document_type)


class UnitConversion(PgUserTypeMaping):
    pg_schm_name = 'common'
    pg_type_name = 'unit_conversion_type'
    pg_field_list = ['uom_code_from', 'uom_code_to', 'factor']

    def __init__(self, s=None, curs=None):
        self.uom_code_from = None
        self.uom_code_to = None
        self.factor = None
        if s:
            self.from_string(s)
            print(self)

    def to_dict(self):
        return {"uom_code_from": self.uom_code_from,
                "uom_code_to": self.uom_code_to,
                "factor": decimal_to_string(self.factor)}

    def from_dict(self, d):
        self.uom_code_from = parse_string_from_dict(d, 'uom_code_from')
        self.uom_code_to = parse_string_from_dict(d, 'uom_code_to')
        self.factor = parse_decimal_from_dict(d, 'factor')
        print(self)

    def from_tuple(self, t):
        self.uom_code_from = parse_string_from_tuple(t, 0)
        self.uom_code_to = parse_string_from_tuple(t, 1)
        self.factor = parse_decimal_from_tuple(t, 2)

    def to_tuple(self):
        return (self.uom_code_from,
                self.uom_code_to,
                self.factor)


class UomHead(PgUserTypeMaping):
    pg_schm_name = 'common'
    pg_type_name = 'unit_head'
    pg_field_list = ['uom_code', 'uom_domain', 'base_uom_code', 'factor']

    def __init__(self, s=None, curs=None):
        self.uom_code = None
        self.uom_domain = None
        self.base_uom_code = None
        self.factor = None
        if s:
            self.from_string(s)
            print(self)

    def to_dict(self):
        return {"uom_code": self.uom_code,
                "uom_domain": self.uom_domain,
                "base_uom_code": self.base_uom_code,
                "factor": decimal_to_string(self.factor)}

    def from_dict(self, d):
        self.uom_code = parse_string_from_dict(d, 'uom_code')
        self.uom_domain = parse_string_from_dict(d, 'uom_domain')
        self.base_uom_code = parse_string_from_dict(d, 'base_uom_code')
        self.factor = parse_decimal_from_dict(d, 'factor')
        print(self)

    def from_tuple(self, t):
        self.uom_code = parse_string_from_tuple(t, 0)
        self.uom_domain = parse_string_from_tuple(t, 1)
        self.base_uom_code = parse_string_from_tuple(t, 2)
        self.factor = parse_decimal_from_tuple(t, 3)

    def to_tuple(self):
        return (self.uom_code,
                self.uom_domain,
                self.base_uom_code,
                self.factor)


def register(conn):
    psycopg2.extras.register_uuid()
    pg_typ_caster(connection=conn, nspname='common', typname='uom_head', mapclass=UomHead)
    pg_typ_caster(connection=conn, nspname='common', typname='facility_head', mapclass=FacilityHead)
    #pg_typ_caster(connection=conn, nspname='common', typname='facility_kind', mapclass=FacilityKind)
    pg_typ_caster(connection=conn, nspname='common', typname='inventory_head', mapclass=InventoryHead)
    pg_typ_caster(connection=conn, nspname='common', typname='inventory_kind', mapclass=InventoryKind)
    pg_typ_caster(connection=conn, nspname='common', typname='unit_conversion_type', mapclass=UnitConversion)
