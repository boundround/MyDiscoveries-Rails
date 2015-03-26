#!/usr/bin/python
import MySQLdb
import MySQLdb.cursors

db = MySQLdb.connect("localhost","boundrou_cmgr","billyblue2","boundrou_testcms")
cursor = db.cursor(MySQLdb.cursors.DictCursor)
# execute SQL select statement
cursor.execute("SELECT * FROM areas")

# commit your changes
db.commit()

# get the number of rows in the resultset
numrows = int(cursor.rowcount)

# get and display one row at a time.
for x in range(0,numrows):
    row = cursor.fetchone()
    print row['id'], "-->", row['identifier']
