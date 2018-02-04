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
                # return o
            elif isinstance(o, int):
                return o
            elif isinstance(o, Decimal):
                return o
            elif isinstance(o, datetime.date):
                return _ext.DateFromPy(o)
                # _ext.Flo
            elif isinstance(o, datetime.timedelta):
                return _ext.IntervalFromPy(o)
            else:
                #return _ext.adapt(obj=o, alternate=None, protocol=None)
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


class FacilityHead(PgUserTypeMaping):
    pg_schm_name = 'common'
    pg_type_name = 'facility_head'
    pg_field_list = ['document_id', 'gid', 'facility_code',
                     'version_num', 'display_name', 'document_date',
                     'parent_facility_code', 'facility_type']

    def __init__(self, s=None, curs=None):
        self.document_id = None
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
        if self.document_date:
            _document_date = self.document_date.strftime('%Y-%m-%d')
        else:
            _document_date = None
        return {"document_id": self.document_id,
                "gid": self.gid,
                "facility_code": self.facility_code,
                "version_num": self.version_num,
                "display_name": self.display_name,
                "document_date": _document_date,
                "parent_facility_code": self.parent_facility_code,
                "facility_type": self.facility_type}

    def from_dict(self, d):
        if len(d['document_date']) > 0:
            _document_date = datetime.datetime.strptime(d['document_date'], "%Y-%m-%d").date()
        else:
            _document_date = None

        self.document_id = d['document_id']
        self.gid = d['gid']
        self.facility_code = d['facility_code']
        self.version_num = d['version_num']
        self.display_name = d['display_name']
        self.document_date = _document_date
        self.parent_facility_code = d['parent_facility_code']
        self.facility_type = d['facility_type']

    def from_tuple(self, t):
        self.document_id = int(t[0])
        self.gid = uuid.UUID(t[1])
        self.facility_code = t[2]
        self.version_num = t[3]
        self.display_name = t[4]
        if len(t[5]) > 0:
            self.document_date = datetime.datetime.strptime(t[5], "%Y-%m-%d")
        else:
            self.document_date = None
        self.parent_facility_code = t[6]
        self.facility_type = t[7]

    def to_tuple(self):
        return (self.document_id,
                self.gid,
                self.facility_code,
                self.version_num,
                self.display_name,
                self.document_date,
                self.parent_facility_code,
                self.facility_type)


class InventoryHead(PgUserTypeMaping):
    pg_schm_name = 'common'
    pg_type_name = 'inventory_head'
    pg_field_list = ['document_id', 'gid', 'display_name',
                     'part_code', 'version_num', 'document_date',
                     'uom_code', 'curr_fsmt', 'document_type']

    def __init__(self, s=None, curs=None):
        self.document_id = None
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
        if self.document_date:
            _document_date = self.document_date.strftime('%Y-%m-%d')
        else:
            _document_date = None
        return {"document_id": self.document_id,
                "gid": self.gid,
                "display_name": self.display_name,
                "part_code": self.part_code,
                "version_num": self.version_num,
                "document_date": _document_date,
                "uom_code": self.uom_code,
                "curr_fsmt": self.curr_fsmt,
                "document_type": self.document_type}

    def from_dict(self, d):
        if len(d['document_date']) > 0:
            _document_date = datetime.datetime.strptime(d['document_date'], "%Y-%m-%d").date()
        else:
            _document_date = None

        self.document_id = d['document_id']
        self.gid = d['gid']
        self.display_name = d['display_name']
        self.part_code = d['part_code']
        self.version_num = d['version_num']
        self.document_date = _document_date
        self.uom_code = d['uom_code']
        self.curr_fsmt = d['curr_fsmt']
        self.document_type = d['document_type']

    def from_tuple(self, t):
        self.document_id = int(t[0])
        self.gid = uuid.UUID(t[1])
        self.display_name = t[2]
        self.part_code = t[3]
        self.version_num = t[4]
        if len(t[5]) > 0:
            self.document_date = datetime.datetime.strptime(t[5], "%Y-%m-%d")
        else:
            self.document_date = None
        self.uom_code = t[6]
        self.curr_fsmt = t[7]
        self.document_type = t[8]

    def to_tuple(self):
        return (self.document_id,
                self.gid,
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
                "factor": float(self.factor)}

    def from_dict(self, d):
        self.uom_code_from = d['uom_code_from']
        self.uom_code_to = d['uom_code_to']
        self.factor = Decimal(d['factor'])

    def from_tuple(self, t):
        self.uom_code_from = t[0]
        self.uom_code_to = t[1]
        self.factor = Decimal(t[2])

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
                "factor": float(self.factor)}

    def from_dict(self, d):
        self.uom_code = d['uom_code']
        self.uom_domain = d['uom_domain']
        self.base_uom_code = d['base_uom_code']
        self.factor = Decimal(d['factor'])

    def from_tuple(self, t):
        self.uom_code = t[0]
        self.uom_domain = t[1]
        self.base_uom_code = t[2]
        self.factor = Decimal(t[3])

    def to_tuple(self):
        return (self.uom_code,
                self.uom_domain,
                self.base_uom_code,
                self.factor)


def register(conn):
    psycopg2.extras.register_uuid()
    pg_typ_caster(connection=conn, nspname='common', typname='uom_head', mapclass=UomHead)
    pg_typ_caster(connection=conn, nspname='common', typname='facility_head', mapclass=FacilityHead)
    pg_typ_caster(connection=conn, nspname='common', typname='inventory_head', mapclass=InventoryHead)
    pg_typ_caster(connection=conn, nspname='common', typname='unit_conversion_type', mapclass=UnitConversion)
