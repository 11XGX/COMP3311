# COMP3311 19T3 Assignment 3

import sys, itertools, cs3311

def dayToNum(day):
    if day == 'Mon':
        return 0
    elif day == 'Tue':
        return 1
    elif day == 'Wed':
        return 2
    elif day == 'Thu':
        return 3
    elif day == 'Fri':
        return 4
    elif day == 'Sat':
        return 5
    elif day == 'Sun':
        return 6

def calculateTotalTime(class_list):
    days = {}
    for temp_class in class_list:
        day, start_time, end_time = temp_class[-3:]
        if day not in days:
            days[day] = [start_time, end_time]
        else:
            if start_time < days[day][0]:
                days[day][0] = start_time
            if end_time > days[day][1]:
                days[day][1] = end_time

    hours = 0.0
    for val in days.values():
        hours += 2 + (((val[1] % 100 + round(val[1] / 100) * 60) - (val[0] % 100 + round(val[0] / 100) * 60)) / 60.0)

    return hours

def printTimetable(timetable, time):
    if timetable != []:
        temp_day = ''
        print("Total hours: " + "{:.1f}".format(time))
        for meeting in chosen_timetable:
            subject_code, class_id, class_type, day, start_time, end_time = meeting
            if temp_day != day:
                temp_day = day
                print("  " + day)
            print("    " + subject_code + " " + class_type + ": " + str(start_time) + "-" + str(end_time))
    else:
        print("No timetable could be generated without a class clash.")

# Here lies the start of my Q8 solution...
conn = cs3311.connect()
codes = ['COMP1511', 'MATH1131']
if len(sys.argv) > 1 and len(sys.argv) < 5:
    codes = [sys.argv[1]]
    if len(sys.argv) > 2:
        codes.append(sys.argv[2])
        if len(sys.argv) > 3:
            codes.append(sys.argv[3])

# Create a dictionary to store all Course|Class combination and possible candidates.
all_classes = {}
# Create a dictionary to store all class meetings (grouped together by class_id).
class_details = {}
cur = conn.cursor()
for code in codes:
    query = "select * from Q8Meetings where subject_code = '" + code + "' order by day, start_time, end_time"
    cur.execute(query)
    for tup in cur.fetchall():
        subject_code, class_id, class_type, day, start_time, end_time = tup
        subject_class = subject_code + class_type
        if subject_class not in all_classes:
            all_classes[subject_class] = [class_id]
        elif class_id not in all_classes[subject_class]:
            all_classes[subject_class].append(class_id)

        if class_id not in class_details:
            class_details[class_id] = [tup]
        else:
            class_details[class_id].append(tup)

# Produce all possible timetables, essentially joining the two dicts (sorted by day, start_time, end_time).
timetables = []
for class_ids in itertools.product(*all_classes.values()):
    classes = []
    for class_id in class_ids:
        classes += class_details[class_id]
        classes.sort(key = lambda x: (dayToNum(x[3]), x[4], x[5]))
    timetables.append(classes)

# Find the optimal timetable (the earliest, with the least hours required).
chosen_timetable = []
temp_time = 169.0 # (Only 168 hrs in a week)
for item in timetables:
    flag = True
    # Check if a possible timetable has a clash/overlap.
    for x in range(1, len(item)):
        subject_code1, class_id1, class_type1, day1, start_time1, end_time1 = item[x - 1]
        subject_code2, class_id2, class_type2, day2, start_time2, end_time2 = item[x]
        if day1 == day2 and start_time1 < end_time2 and start_time2 < end_time1:
            flag = False
            break

    if flag:
        time = calculateTotalTime(item)
        if time < temp_time:
            temp_time = time
            chosen_timetable = item

# Print the optimal timetable in the assignment spec format.
printTimetable(chosen_timetable, temp_time)

cur.close()
conn.close()
