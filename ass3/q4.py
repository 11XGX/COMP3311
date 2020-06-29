# COMP3311 19T3 Assignment 3

import sys, cs3311
conn = cs3311.connect()

user_code = 'ENGG'
if len(sys.argv) == 2:
    user_code = sys.argv[1]

cur = conn.cursor()
query = """
select *
from Q4TermEnrolments
order by term, code
"""

temp_term = '' 
cur.execute(query)
for tup in cur.fetchall():
    term, code, enrolments = tup
    if user_code in code and enrolments > 0:
        if term != temp_term:
            temp_term = term
            print(term)
        print(' ' + code + '(' + str(enrolments) + ')')


cur.close()
conn.close()
