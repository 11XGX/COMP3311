# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()

query = """
select code, quota, nStudents
from Q1Courses c1
join Q1Counts c2 on (c1.id = c2.id)
order by code
"""
cur.execute(query)

for tup in cur.fetchall():
    code, quota, nEnrolledStudents = tup
    if nEnrolledStudents > quota:
        perc = (nEnrolledStudents / quota) * 100
        print(code + ' ' + str(round(perc)) + '%')

cur.close()
conn.close()
