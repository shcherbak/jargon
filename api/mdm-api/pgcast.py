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
        self.document_type = None
        if s:
            self.from_string(s)

    def from_string(self, s):
        pass


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

    def from_string(self, s):
        pass


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

    def from_string(self, s):
        pass


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

class ComponentSpecification(object):
    def __init__(self, s=None, curs=None):
        self.part_code = ''
        self.version_num = 0
        self.quantity = Decimal(0)
        self.uom_code = ''
        self.component_type = ''
        if s:
            self.from_string(s)

    def __repr__(self):
        return "{0}(part_code={1}, version_num={2}, quantity={3}, uom_code={4}, component_type={5})" \
            .format(type(self).__name__,
                    self.part_code,
                    self.version_num,
                    str(self.quantity),
                    self.uom_code,
                    self.component_type)

    def __conform__(self, proto):
        if proto == _ext.ISQLQuote:
            return self

    def to_dict(self):
        return {"part_code": self.good_code,
                "version_num": int(self.quantity),
                "quantity": float(self.quantity),
                "uom_code": self.uom_code,
                "component_type": self.component_type}

    def from_dict(self, d):
        self.part_code = d['part_code']
        self.version_num = int(d['version_num'])
        self.quantity = Decimal(d['quantity'])
        self.uom_code = d['uom_code']
        self.component_type = d['component_type']

    def from_tuple(self, t):
        self.part_code = t[0]
        self.version_num = int(t[1])
        self.quantity = Decimal(t[2])
        self.uom_code = t[3]
        self.component_type = t[4]

    def from_string(self, s):
        if s is None:
            return None
        m = re.match(r"\((\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?,(\"[^\"]*\"|[^,]+)?\)", s)
        if m:
            self.from_tuple((m.group(1),
                             m.group(2),
                             m.group(3),
                             m.group(4),
                             m.group(5)))
        else:
            raise psycopg2.InterfaceError("bad component_specification representation: %r" % s)

    def getquoted(self):
        return "({0}, {1}, {2}, {3}, {4})::common.component_specification"\
            .format(_adapt(self.part_code),
                    _adapt(self.version_num),
                    _adapt(self.quantity),
                    _adapt(self.uom_code),
                    _adapt(self.component_type))


def register_common_component_specification(oid=None, conn_or_curs=None):
    if not oid:
        oid1 = _get_pg_typname_oid(conn_or_curs, 'common', 'component_specification')
        oid2 = _get_pg_typarray_oid(conn_or_curs, 'common', 'component_specification')
    elif isinstance(oid, (list, tuple)):
        oid1, oid2 = oid
    else:
        print('error')
        exit(1)

    COMPONENT_SPECIFICATION = _ext.new_type((oid1,), "COMPONENT_SPECIFICATION", ComponentSpecification)
    COMPONENT_SPECIFICATION_ARRAY = _ext.new_array_type((oid2,), "COMPONENT_SPECIFICATION_ARRAY", COMPONENT_SPECIFICATION)

    _ext.register_type(COMPONENT_SPECIFICATION, conn_or_curs)
    _ext.register_type(COMPONENT_SPECIFICATION_ARRAY, conn_or_curs)

    return COMPONENT_SPECIFICATION

def register(conn):
    psycopg2.extras.register_uuid()
    register_common_component_specification(conn_or_curs=conn)
    register_common_facility_head(conn_or_curs=conn)
    register_common_inventory_head(conn_or_curs=conn)
    register_common_unit_conversion(conn_or_curs=conn)
