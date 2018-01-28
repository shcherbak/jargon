#!/usr/bin/env python

import psycopg2
from psycopg2.pool import SimpleConnectionPool

from config import dbconfig, dbpoolconfig


def connection():
    try:
        params = dbconfig()
        conn = psycopg2.connect(**params)
        return conn
    except(Exception, psycopg2.DatabaseError) as error:
        print(error)


def pool():
    try:
        params = dbpoolconfig()
        connection_pool = SimpleConnectionPool(**params)
        print("!!!!!!!!!!!! pool() !!!!!!!!!!!!")
        return connection_pool
    except(Exception, psycopg2.DatabaseError) as error:
        print(error)
