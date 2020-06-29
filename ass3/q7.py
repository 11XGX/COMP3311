# COMP3311 19T3 Assignment 3

import sys, decimal, cs3311
conn = cs3311.connect()

term = '19T1'
if len(sys.argv) == 2:
    term = sys.argv[1]

cur = conn.cursor()
query = """
select room_code, term_name, day, start_time, end_time, weekly_hours
from Q7WeeklyHours
order by room_code, term_name, day, start_time, end_time
"""

rooms = {}
cur.execute(query)
for tup in cur.fetchall():
    room_code, term_name, day, start_time, end_time, weekly_hours = tup
    if room_code in rooms and term_name == term:
        rooms[room_code] += weekly_hours
    elif room_code not in rooms and term_name == term:
        rooms[room_code] = weekly_hours
    elif room_code not in rooms and term_name != term:
        rooms[room_code] = decimal.Decimal('0.0');

query = "select * from Q7NumRooms"
cur.execute(query)
num_rooms = cur.fetchone()[0]

underused = num_rooms - len(rooms)
for key, val in rooms.items():
    if (val / decimal.Decimal('10.0')) < 20:
        underused += 1

print(str(round(underused / num_rooms * 100.0, 1)) + '%')

cur.close()
conn.close()
