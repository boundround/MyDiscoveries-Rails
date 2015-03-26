#!/usr/bin/python
import MySQLdb

db = MySQLdb.connect("localhost","boundrou_cmgr","billyblue2","boundrou_testcms")

# you must create a Cursor object. It will let
#  you execute all the queries you need
cur = db.cursor() 

# Use all the SQL you like
cur.execute("SELECT * FROM areas")

# print all the first cell of all the rows
for row in cur.fetchall() :
    print row[0]
