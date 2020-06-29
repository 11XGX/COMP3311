# COMP3311 19T3 Assignment 3

import sys, cs3311
conn = cs3311.connect()

user_course = 'COMP1521'
if len(sys.argv) == 2:
    user_course = sys.argv[1]

cur = conn.cursor()
query = """
select *
from Q5TermEnrolments
order by class, tag, perc
"""

cur.execute(query)
for tup in cur.fetchall():
    class_type, code, class_tag, perc = tup
    if code == user_course and perc < 50:
        print(class_type + ' ' + class_tag.strip() + ' is ' + str(round(perc)) + '% full')

cur.close()
conn.close()
