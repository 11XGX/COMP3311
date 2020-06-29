# COMP3311 19T3 Assignment 3

import cs3311
conn = cs3311.connect()

cur = conn.cursor()
query = """
select id, weeks, weeks_binary
from Meetings
"""

cur.execute(query)
for tup in cur.fetchall():
    meeting_id, weeks, weeks_binary = tup

    temp_num = -1
    temp_binary = list('00000000000')
    for i in range(len(weeks)):
        if weeks[i] == 'N' or weeks[i] == '<':
            temp_binary = list('00000000000')
            break
        elif weeks[i] == ',':
            temp_num = -1
        elif weeks[i].isdigit():
            num = -1
            if i + 1 < len(weeks) and weeks[i] == '1' and weeks[i + 1].isdigit():
                num = int("".join(weeks[i:i + 2])) - 1
                if temp_num == -1:
                    temp_binary[num] = '1'
                else:
                    for j in range(temp_num, num + 1):
                        temp_binary[j] = '1'
                i += 1
            else:
                num = int(weeks[i]) - 1
                if temp_num == -1:
                    temp_binary[num] = '1'
                else:
                    for j in range(temp_num, num + 1):
                        temp_binary[j] = '1'
            temp_num = num

    update_query = "UPDATE meetings SET weeks_binary = '" + "".join(temp_binary) + "' WHERE id = " + str(meeting_id) + ";"
    cur.execute(update_query)

cur.close()
conn.commit()
conn.close()
