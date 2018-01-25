#!/usr/bin/env python

import datetime
import uuid
from decimal import Decimal

import psycopg2
import psycopg2.extensions as _ext
import psycopg2.extras
import re


def _get_pg_nspname_oid(conn, nspname):
    _sql = 'SELECT oid FROM pg_namespace WHERE nspname = %s'
    _connection = conn
    try:
        _curs = _connection.cursor()
        _curs.execute(_sql, (nspname,))
        _oid = _curs.fetchone()[0]
        _curs.close()
        return _oid
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)


def _get_pg_typname_oid(conn, nspname, typname):
    _sql = 'SELECT oid FROM pg_type WHERE typname = %s AND typnamespace = %s;'
    _connection = conn
    try:
        _nspoid = _get_pg_nspname_oid(_connection, nspname)
        _curs = _connection.cursor()
        _curs.execute(_sql, (typname, _nspoid,))
        _oid = _curs.fetchone()[0]
        _curs.close()
        return _oid
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)


def _get_pg_typarray_oid(conn, nspname, typname):
    _sql = 'SELECT typarray FROM pg_type WHERE typname = %s AND typnamespace = %s'
    _connection = conn
    try:
        _nspoid = _get_pg_nspname_oid(_connection, nspname)
        _curs = _connection.cursor()
        _curs.execute(_sql, (typname, _nspoid,))
        _oid = _curs.fetchone()[0]
        _curs.close()
        return _oid
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)



def date_from_py(pydate):
    pass

def date_from_pg(sqldate):
    pass

def decimal_from_py(pydecimal):
    pass

def decimal_from_pg(sqlnumeric):
    pass

def _adapt(o):
    if o is None:
        return 'NULL'
    else:
        if isinstance(o, str):
            return "'{0}'".format(o)
        else:
            # return _ext.adapt(obj=o, alternate=None, protocol=None)
            return _ext.adapt(o)


class FacilityHead(object):
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

    def __repr__(self):
        return "facility_head(document_id={0}, \
                gid={1}, facility_code={2}, version_num={3}, \
                display_name={4}, document_date={5}, parent_facility_code={6}, facility_type={7})". \
            format(self.document_id,
                   self.gid,
                   self.facility_code,
                   self.version_num,
                   self.display_name,
                   self.document_date,
                   self.parent_facility_code,
                   self.facility_type)

    def __conform__(self, proto):
        if proto == _ext.ISQLQuote:
            return self

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

    def from_string(self, s):
        if s is None:
            return None
        m = re.match(r"\((\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?\)", s)
        if m:
            self.from_tuple((m.group(1),
                             m.group(2),
                             m.group(3),
                             m.group(4),
                             m.group(5),
                             m.group(6),
                             m.group(7),
                             m.group(8)))
        else:
            raise psycopg2.InterfaceError("bad facility_head representation: %r" % s)

    def getquoted(self):
        return "({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7})::common.facility_head" \
            .format(_adapt(self.document_id),
                    _adapt(self.gid),
                    _adapt(self.facility_code),
                    _adapt(self.version_num),
                    _adapt(self.display_name),
                    _adapt(self.document_date),
                    _adapt(self.parent_facility_code),
                    _adapt(self.facility_type))


def register_common_facility_head(oid=None, conn_or_curs=None):
    if not oid:
        oid1 = _get_pg_typname_oid(conn_or_curs, 'common', 'facility_head')
        oid2 = _get_pg_typarray_oid(conn_or_curs, 'common', 'facility_head')
    elif isinstance(oid, (list, tuple)):
        oid1, oid2 = oid
    else:
        print('error')
        exit(1)

    FACILITY_HEAD = _ext.new_type((oid1,), "FACILITY_HEAD", FacilityHead)
    FACILITY_HEAD_ARRAY = _ext.new_array_type((oid2,), "FACILITY_HEAD_ARRAY", FACILITY_HEAD)

    _ext.register_type(FACILITY_HEAD, conn_or_curs)
    _ext.register_type(FACILITY_HEAD_ARRAY, conn_or_curs)

    return FACILITY_HEAD


class InventoryHead(object):
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

    def __repr__(self):
        return "inventory_head(document_id={0}, \
                gid={1}, display_name={2}, part_code={3}, \
                version_num={4}, document_date={5}, uom_code={6}, curr_fsmt={7}, document_type={8})". \
            format(self.document_id,
                   self.gid,
                   self.display_name,
                   self.part_code,
                   self.version_num,
                   self.document_date,
                   self.uom_code,
                   self.curr_fsmt,
                   self.document_type)

    def __conform__(self, proto):
        if proto == _ext.ISQLQuote:
            return self

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

    def from_string(self, s):
        if s is None:
            return None
        m = re.match(r"\((\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?\)", s)
        if m:
            self.from_tuple((m.group(1),
                             m.group(2),
                             m.group(3),
                             m.group(4),
                             m.group(5),
                             m.group(6),
                             m.group(7),
                             m.group(8),
                             m.group(9)))
        else:
            raise psycopg2.InterfaceError("bad inventory_head representation: %r" % s)

    def getquoted(self):
        return "({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8})::common.inventory_head" \
            .format(_adapt(self.document_id),
                    _adapt(self.gid),
                    _adapt(self.display_name),
                    _adapt(self.part_code),
                    _adapt(self.version_num),
                    _adapt(self.document_date),
                    _adapt(self.uom_code),
                    _adapt(self.curr_fsmt),
                    _adapt(self.document_type))


def register_common_inventory_head(oid=None, conn_or_curs=None):
    if not oid:
        oid1 = _get_pg_typname_oid(conn_or_curs, 'common', 'inventory_head')
        oid2 = _get_pg_typarray_oid(conn_or_curs, 'common', 'inventory_head')
    elif isinstance(oid, (list, tuple)):
        oid1, oid2 = oid
    else:
        print('error')
        exit(1)

    INVENTORY_HEAD = _ext.new_type((oid1,), "INVENTORY_HEAD", InventoryHead)
    INVENTORY_HEAD_ARRAY = _ext.new_array_type((oid2,), "INVENTORY_HEAD_ARRAY", INVENTORY_HEAD)

    _ext.register_type(INVENTORY_HEAD, conn_or_curs)
    _ext.register_type(INVENTORY_HEAD_ARRAY, conn_or_curs)

    return INVENTORY_HEAD

class UnitConversion(object):
    def __init__(self, s=None, curs=None):
        self.uom_code_from = None
        self.uom_code_to = None
        self.factor = None
        if s:
            self.from_string(s)

    def __repr__(self):
        return "{0}(uom_code_from={1}, uom_code_to={2}, factor={3})" \
            .format(type(self).__name__,
                    self.uom_code_from,
                    self.uom_code_to,
                    str(self.factor))

    def __conform__(self, proto):
        if proto == _ext.ISQLQuote:
            return self

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

    def from_string(self, s):
        if s is None:
            return None
        m = re.match(r"\((\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?\)", s)
        if m:
            self.from_tuple((m.group(1),
                             m.group(2),
                             m.group(3)))
        else:
            raise psycopg2.InterfaceError("bad unit_conversion_type representation: %r" % s)

    def getquoted(self):
        return "({0}, {1}, {2})::common.unit_conversion_type"\
            .format(_adapt(self.uom_code_from),
                    _adapt(self.uom_code_to),
                    _adapt(self.factor))


def register_common_unit_conversion(oid=None, conn_or_curs=None):
    if not oid:
        oid1 = _get_pg_typname_oid(conn_or_curs, 'common', 'unit_conversion_type')
        oid2 = _get_pg_typarray_oid(conn_or_curs, 'common', 'unit_conversion_type')
    elif isinstance(oid, (list, tuple)):
        oid1, oid2 = oid
    else:
        print('error')
        exit(1)

    UNIT_CONVERSION = _ext.new_type((oid1,), "UNIT_CONVERSION", UnitConversion)
    UNIT_CONVERSION_ARRAY = _ext.new_array_type((oid2,), "UNIT_CONVERSION_ARRAY", UNIT_CONVERSION)

    _ext.register_type(UNIT_CONVERSION, conn_or_curs)
    _ext.register_type(UNIT_CONVERSION_ARRAY, conn_or_curs)

    return UNIT_CONVERSION


def register(conn):
    psycopg2.extras.register_uuid()
    register_common_facility_head(conn_or_curs=conn)
    register_common_inventory_head(conn_or_curs=conn)
    register_common_unit_conversion(conn_or_curs=conn)
