#!/usr/bin/env python

import psycopg2
import psycopg2.extras

import pgcast


class Measure:
    GET_HEAD_SQL = "SELECT uom.get_head(__uom_code := %s)"
    GET_BODY_SQL = None
    UPDATE_BODY_SQL = None
    DELETE_DOCUMENT_SQL = None
    CREATE_DOCUMENT_SQL = None
    COMMIT_DOCUMENT_SQL = None
    DECOMMIT_DOCUMENT_SQL = None

    def __init__(self, pool, uom_code=None):
        self.pool = pool
        self.errors = []
        self.head = None
        if uom_code:
            self.load(uom_code)
        else:
            self.head = None

    def init(self):
        conn = None
        document_id = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.CREATE_DOCUMENT_SQL, (self.head,))
            document_id = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return document_id

    def reinit(self):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.UPDATE_BODY_SQL, (self.head,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def load(self, uom_code):
        self._load_head(uom_code)

    def delete(self, document_id):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.DELETE_DOCUMENT_SQL, (document_id,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def commit(self, document_id, apprise=True):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.COMMIT_DOCUMENT_SQL, (document_id, apprise,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def decommit(self, document_id, apprise=True):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.DECOMMIT_DOCUMENT_SQL, (document_id, apprise,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def _load_head(self, uom_code):
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.GET_HEAD_SQL, (uom_code,))
            self.head = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                self.pool.putconn(conn)

    def to_dict(self):
        return {"head": self.head.to_dict()}

    def from_dict(self, d):
        print("from dict")
        self.head = pgcast.UomHead()
        self.head.from_dict(d)

    def to_json(self):
        return "json string {0}".format(self)

    def from_json(self, json):
        self.head = json


class Facility:
    GET_HEAD_SQL = "SELECT facility.get_head(__document_id := %s)"
    GET_BODY_SQL = None
    UPDATE_BODY_SQL = "SELECT facility.reinit(__head := %s)"
    DELETE_DOCUMENT_SQL = "SELECT facility.destroy(__document_id := %s)"
    CREATE_DOCUMENT_SQL = "SELECT facility.init(__head := %s)"
    COMMIT_DOCUMENT_SQL = None
    DECOMMIT_DOCUMENT_SQL = None

    def __init__(self, pool, document_id=None):
        self.pool = pool
        self.errors = []
        self.head = None
        if document_id:
            self.load(document_id)
        else:
            self.head = None

    def init(self):
        conn = None
        document_id = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.CREATE_DOCUMENT_SQL, (self.head,))
            document_id = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return document_id

    def reinit(self):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.UPDATE_BODY_SQL, (self.head,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def load(self, document_id):
        self._load_head(document_id)

    def delete(self, document_id):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.DELETE_DOCUMENT_SQL, (document_id,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def commit(self, document_id, apprise=True):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.COMMIT_DOCUMENT_SQL, (document_id, apprise,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def decommit(self, document_id, apprise=True):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.DECOMMIT_DOCUMENT_SQL, (document_id, apprise,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def _load_head(self, document_id):
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.GET_HEAD_SQL, (document_id,))
            self.head = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                self.pool.putconn(conn)

    def to_dict(self):
        return {"head": self.head.to_dict()}

    def from_dict(self, d):
        print("from dict")
        self.head = pgcast.FacilityHead()
        self.head.from_dict(d)

    def to_json(self):
        return "json string {0}".format(self)

    def from_json(self, json):
        self.head = json


class Inventory:
    GET_HEAD_SQL = "SELECT inventory.get_head(__document_id := %s)"
    GET_MEAS_SQL = "SELECT inventory.get_meas_spec(__document_id := %s)"
    GET_KIND_SQL = "SELECT inventory.get_kind_spec(__document_id := %s)"
    UPDATE_BODY_SQL = "SELECT inventory.reinit(__document_id := %s, __meas := %s, __kind := %s)"
    DELETE_DOCUMENT_SQL = "SELECT inventory.destroy(__document_id := %s)"
    CREATE_DOCUMENT_SQL = "SELECT inventory.init(__head := %s, __meas := %s, __kind := %s)"
    COMMIT_DOCUMENT_SQL = None
    DECOMMIT_DOCUMENT_SQL = None

    def __init__(self, pool, document_id=None):
        self.pool = pool
        self.errors = []
        if document_id:
            self.load(document_id)
            print(self)
            #print('SELF.KIND', type(self.kind))
        else:
            self.head = None
            self.meas = None
            self.kind = None

    def init(self):
        conn = None
        document_id = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.CREATE_DOCUMENT_SQL, (self.head, self.meas, self.kind,))
            #print("CURSOR", (self.CREATE_DOCUMENT_SQL, (self.head, self.meas, self.kind,)))
            document_id = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            self.errors.append(error.pgerror)
        #except (Exception) as error:
        #    print(error)
        #    self.errors.append(error)
        finally:
            #print("WTF!!!!!!!!!!!!!!!!!!!!!!!!")
            if conn is not None:
                self.pool.putconn(conn)
        return document_id

    def reinit(self, document_id):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.UPDATE_BODY_SQL, (document_id, self.meas, self.kind,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(str(error))
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def load(self, document_id):
        self._load_head(document_id)
        self._load_meas(document_id)
        self._load_kind(document_id)

    def delete(self, document_id):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.DELETE_DOCUMENT_SQL, (document_id,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def commit(self, document_id, apprise=True):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.COMMIT_DOCUMENT_SQL, (document_id, apprise,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def decommit(self, document_id, apprise=True):
        success = True
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.DECOMMIT_DOCUMENT_SQL, (document_id, apprise,))
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            success = False
            self.errors.append(error.pgerror)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return success

    def _load_head(self, document_id):
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.GET_HEAD_SQL, (document_id,))
            self.head = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                self.pool.putconn(conn)

    def _load_meas(self, document_id):
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.GET_MEAS_SQL, (document_id,))
            self.meas = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                self.pool.putconn(conn)

    def _load_kind(self, document_id):
        conn = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.GET_KIND_SQL, (document_id,))
            self.kind = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                self.pool.putconn(conn)

    def to_dict(self):
        _meas = []
        _kind = []
        for row in self.meas:
            _meas.append(row.to_dict())
        for row in self.kind:
            _kind.append(row.val)
        return {"head": self.head.to_dict(), "meas": _meas, "kind": _kind}

    def from_dict(self, d):
        self.head = pgcast.InventoryHead()
        self.head.from_dict(d['head'])
        print('FROM DICT', self.head)
        self.meas = []
        for row in d['meas']:
            m = pgcast.UnitConversion()
            m.from_dict(row)
            self.meas.append(m)
        print('FROM DICT', self.meas)
        self.kind = []
        for row in d['kind']:
            m = pgcast.InventoryKind()
            m.from_set(row)
            self.kind.append(m)
        print('FROM DICT', self.kind)

    def to_json(self):
        return "json string {0}".format(self)

    def from_json(self, json):
        self.head = json
        self.body = json


class BaseDocumentList:
    GET_LSIT_SQL = None

    def __init__(self, pool, facility=None, sdate=None, edate=None):
        self.pool = pool

        # self.facility_code = None
        if facility:
            self.facility_code = facility

        # self.date_start = None
        if sdate:
            self.date_start = sdate

        # self.date_end = None
        if edate:
            self.date_end = edate

    def get_document_list(self):
        conn = None
        document_list = None
        try:
            conn = self.pool.getconn()
            pgcast.register(conn)
            curs = conn.cursor()
            curs.execute(self.GET_LSIT_SQL, (self.facility_code, self.date_start, self.date_end,))
            document_list = curs.fetchone()[0]
            conn.commit()
            curs.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                self.pool.putconn(conn)
        return document_list

    def to_dict(self):
        result_list = []
        list_in = self.get_document_list()
        for row in list_in:
            result_list.append(row.to_dict())
        return result_list


class MeasureList(BaseDocumentList):
    GET_LSIT_SQL = "SELECT uom.get_head_batch(__uom_domain := NULL)"


class InventoryList(BaseDocumentList):
    GET_LSIT_SQL = "SELECT inventory.get_head_batch()"


class FacilityList(BaseDocumentList):
    GET_LSIT_SQL = "SELECT facility.get_head_batch(__facility_type := NULL)"
