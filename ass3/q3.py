# COMP3311 19T3 Assignment 3

import sys, cs3311
conn = cs3311.connect()

user_code = 'ENGG'
if len(sys.argv) == 2:
    user_code = sys.argv[1]

cur = conn.cursor()
query = """
select *
from Q3RoomsUsed
order by building_name, code
"""

temp_building = '';
cur.execute(query)
for tup in cur.fetchall():
    building, code = tup
    if user_code in code:
        if building != temp_building:
            temp_building = building
            print(building)
        print(' ' + code)


cur.close()
conn.close()
