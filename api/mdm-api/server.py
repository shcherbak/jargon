#!/usr/bin/env python

import datetime
import logging
from logging.handlers import RotatingFileHandler

from flask import Flask, jsonify, request

import dao
from connection import pool
from inputs import (FsmtJsonInputs,
                    FacilityJsonInputs,
                    InventoryJsonInputs,
                    MeasureJsonInputs)

app = Flask(__name__)
app.config.from_object('serverconfig')
print("call to pool 1")
pool = pool()

formatter = logging.Formatter(
    "[%(asctime)s] {%(pathname)s:%(lineno)d} %(levelname)s - %(message)s")
handler = RotatingFileHandler(app.config['LOG_FILENAME'],
                              maxBytes=10000000,
                              backupCount=5)
handler.setLevel(logging.DEBUG)
handler.setFormatter(formatter)
app.logger.addHandler(handler)

# Output the access logs to the same file
log = logging.getLogger('werkzeug')
log.setLevel(logging.DEBUG)
log.addHandler(handler)


def date_range_helper(request):
    req_sdate = request.args.get('sdate')
    req_edate = request.args.get('edate')
    facility = request.args.get('facility')

    if req_sdate:
        sdate = datetime.datetime.strptime(req_sdate, "%Y-%m-%d").date()
    else:
        sdate = datetime.datetime.now().date() - datetime.timedelta(days=1000)

    if req_edate:
        edate = datetime.datetime.strptime(req_edate, "%Y-%m-%d").date()
    else:
        edate = datetime.datetime.now().date() + datetime.timedelta(days=1)

    if not facility:
        facility = 'A1'

    return sdate, edate, facility


@app.errorhandler(404)
def page_not_found(e):
    return "404 not found", 404


@app.route('/')
def hello_world():
    return 'Jargon MDM-API v1'


@app.route('/measures', methods=['GET'])
def get_uoms():
    sdate, edate, facility = date_range_helper(request)
    print(sdate, edate, facility)
    return jsonify(dao.MeasureList(pool, facility, sdate, edate).to_dict())


@app.route('/measures/<string:uom_code>', methods=['GET'])
def get_uom(uom_code):
    document = dao.Measure(pool, uom_code)
    if document.head.base_uom_code == None:
        response = ('', 404)
    else:
        response = jsonify(document.to_dict())
    return response


@app.route('/facilities', methods=['GET'])
def get_facilities():
    sdate, edate, facility = date_range_helper(request)
    return jsonify(dao.FacilityList(pool, facility, sdate, edate).to_dict())


@app.route('/facilities', methods=['POST'])
def post_facility():
    success = False
    inputs = FacilityJsonInputs(request)
    if not inputs.validate():
        response = jsonify(success=success, errors=inputs.errors), 400
        return response
    else:
        data = request.get_json()
        document = dao.Facility(pool)
        document.from_dict(data)
        document_id = document.init()
    if document_id:
        success = True
        response = jsonify(success=success, message="document id=[{0}] created".format(document_id)), 200
    else:
        response = jsonify(success=success, errors=document.errors), 400
    return response


@app.route('/facilities/<int:document_id>', methods=['GET'])
def get_facility(document_id):
    document = dao.Facility(pool, document_id)
    if document.head.id == None:
        response = ('', 404)
    else:
        response = jsonify(document.to_dict())
    return response


@app.route('/facilities/<int:document_id>', methods=['PATCH'])
def patch_facility(document_id):
    success = False
    inputs = FacilityJsonInputs(request)
    if not inputs.validate():
        response = jsonify(success=success, errors=inputs.errors), 400
        return response
    else:
        data = request.get_json()
        document = dao.Facility(pool)
        document.from_dict(data)
        success = document.reinit()
    if success:
        response = jsonify(success=success, message="document id=[{0}] updated".format(document_id)), 200
    else:
        response = jsonify(success=success, errors=document.errors), 400
    return response


@app.route('/inventories', methods=['GET'])
def get_inventories():
    sdate, edate, facility = date_range_helper(request)
    print(sdate, edate, facility)
    return jsonify(dao.InventoryList(pool, facility, sdate, edate).to_dict())


@app.route('/inventories', methods=['POST'])
def post_inventory():
    success = False
    inputs = InventoryJsonInputs(request)
    if not inputs.validate():
        response = jsonify(success=success, errors=inputs.errors), 400
        return response
    else:
        data = request.get_json()
        print(data)
        document = dao.Inventory(pool)
        document.from_dict(data)
        document_id = document.init()
    if document_id:
        success = True
        response = jsonify(success=success, message="document id=[{0}] created".format(document_id)), 200
    else:
        response = jsonify(success=success, errors=document.errors), 400
    return response


@app.route('/inventories/<int:document_id>', methods=['GET'])
def get_inventory(document_id):
    document = dao.Inventory(pool, document_id)
    if document.head.id == None:
        response = ('', 404)
    else:
        response = jsonify(document.to_dict())
    return response


@app.route('/inventories/<int:document_id>', methods=['DELETE'])
def del_inventory(document_id):
    document = dao.Inventory(pool)
    success = document.delete(document_id)
    if success:
        response = ('', 204)
    else:
        response = jsonify(success=False, errors=document.errors), 400

    return response


@app.route('/inventories/<int:document_id>', methods=['PATCH'])
def patch_inventory(document_id):
    success = False
    inputs = InventoryJsonInputs(request)
    if not inputs.validate():
        response = jsonify(success=success, errors=inputs.errors), 400
        return response
    else:
        data = request.get_json()
        document = dao.Inventory(pool, document_id=document_id)
        document.from_dict(data)
        success = document.reinit(document_id)
    if success:
        response = jsonify(success=success, message="document id=[{0}] updated".format(document_id)), 200
    else:
        response = jsonify(success=success, errors=document.errors), 400
    return response


if __name__ == '__main__':
    app.run(debug=True)
