# COMP3311 19T3 Assignment 3

import sys, cs3311
conn = cs3311.connect()

incommon = '2'
if len(sys.argv) == 2 and sys.argv[1].isdigit():
        temp_int = int(sys.argv[1])
        if temp_int >= 2 and temp_int <= 10:
            incommon = str(temp_int)

cur = conn.cursor()
query = """
select courseNum, courses
from Q2CoursesWCounts
where count = 
""" + incommon

cur.execute(query)
for tup in cur.fetchall():
    courseNum, courses = tup
    print(courseNum + ': ' + courses)

cur.close()
conn.close()
