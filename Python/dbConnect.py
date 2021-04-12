#!/usr/bin/python3

import pymysql
from pymysql.cursors import Cursor

# Open database connection
db = pymysql.connect(host="localhost", user="public", password="password123", database="mydb")

# prepare a cursor object using cursor() method
cursor = db.cursor()

# execute SQL query using execute() method.
cursor.execute("SELECT VERSION()")

# Fetch a single row using fetchone() method.
data = cursor.fetchone()
print ("Database version : %s " % data)

# disconnect from server
db.close()

def insert():
    client = pymysql.connect(host="localhost", user="public", password="password123", database="mydb")
    try:
        email = "test@test.test"
        cursor = client.cursor()
        query = "Select ID from user where email = %s"
        cursor.execute(query, email)
        id = cursor.fetchone()[0]
    except Exception as e:
        print(e)
        client.rollback()
    finally:
        client.close()

insert()