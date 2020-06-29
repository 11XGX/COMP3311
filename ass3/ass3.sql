-- COMP3311 19T3 Assignment 3
-- Helper views and functions (if needed)

-- Q1 Helper Functions
create or replace view Q1Courses(id, code, quota) as
select c.id, s.code, c.quota
from Courses c
join Terms t on (c.term_id = t.id)
join Subjects s on (c.subject_id = s.id)
where t.name = '19T3' and quota > 50;

create or replace view Q1Counts(id, nStudents) as
select course_id, count(person_id)
from Course_Enrolments
where person_id is not null
group by course_id;

-- Q2 Helper Functions
create or replace view Q2CourseNums(courseFac, courseNum) as
select distinct left(s.code, 4), right(s.code, length(s.code) - 4)
from Subjects s;

create or replace view Q2OrderedCourseNums(courseFac, courseNum) as
select *
from Q2CourseNums
order by courseFac, courseNum;

create or replace view Q2CourseNumCounts(courseNum, courseNumCount, courses) as
select courseNum, count(courseNum), string_agg(courseFac, ' ')
from Q2OrderedCourseNums
group by courseNum;

create or replace view Q2CoursesWCounts(courseNum, count, courses) as
select distinct c1.courseNum, courseNumCount, courses
from Q2OrderedCourseNums c1
join Q2CourseNumCounts c2 on (c1.courseNum = c2.courseNum);

-- Q3 Helper Functions
create or replace view Q3Meetings(room_id, code) as
select m.room_id, s.code
from Meetings m
join Classes c on (m.class_id = c.id)
join Courses co on (co.id = c.course_id)
join Subjects s on (s.id = co.subject_id)
join Terms t on (t.id = co.term_id)
where t.name = '19T2';

create or replace view Q3RoomsUsed(building_name, code) as
select distinct b.name, m.code
from Q3Meetings m
join Rooms r on (m.room_id = r.id)
join Buildings b on (r.within = b.id);

-- Q4 Helper Functions
create or replace view Q4TermSubjects(id, term, code) as
select co.id, t.name, s.code
from Courses co
join Subjects s on (s.id = co.subject_id)
join Terms t on (t.id = co.term_id);

create or replace view Q4CourseEnrolments(id, enrolments) as
select course_id, count(person_id)
from Course_Enrolments
group by course_id;

create or replace view Q4TermEnrolments(term, code, enrolments) as
select term, code, enrolments
from Q4TermSubjects s
join Q4CourseEnrolments e on (s.id = e.id);

-- Q5 Helper Functions
create or replace view Q5ClassInfo(class_id, code, class_type, tag, quota) as
select distinct c.id, s.code, ct.name, c.tag, c.quota
from Meetings m
join Classes c on (m.class_id = c.id)
join ClassTypes ct on (ct.id = c.type_id)
join Courses co on (co.id = c.course_id)
join Subjects s on (s.id = co.subject_id)
join Terms t on (t.id = co.term_id)
where t.name = '19T3';

create or replace view Q5ClassEnrolments(id, enrolments) as
select class_id, count(person_id)
from Class_Enrolments
group by class_id;

create or replace view Q5TermEnrolments(class, code, tag, perc) as
select class_type, code, tag, (enrolments * 100.0 / quota)
from Q5ClassInfo c
join Q5ClassEnrolments ce on (c.class_id = ce.id);

-- Q7 Helper Functions
create or replace view Q7Classrooms(room_code, term_name, weeks_binary, day, start_time, end_time, hours) as
select r.code, t.name, left(m.weeks_binary, 10), m.day, m.start_time, m.end_time, (((m.end_time % 100 + (m.end_time / 100) * 60) - (m.start_time % 100 + (m.start_time / 100) * 60)) / 60.0)
from Meetings m
full outer join Rooms r on (r.id = m.room_id)
join Classes c on (m.class_id = c.id)
join Courses co on (co.id = c.course_id)
join Terms t on (t.id = co.term_id)
where r.code like 'K-%';

create or replace view Q7WeeklyHours(room_code, term_name, day, start_time, end_time, weekly_hours) as
select room_code, term_name, day, start_time, end_time, hours * (length(weeks_binary) - length(replace(weeks_binary, '1', '')))
from Q7Classrooms;

create or replace view Q7NumRooms(count) as
select count(distinct id)
from Rooms
where code like 'K-%';

-- Q8 Helper Functions
create or replace view Q8Meetings(subject_code, class_id, class_type, day, start_time, end_time) as
select s.code, m.class_id, ct.name, m.day, m.start_time, m.end_time
from Meetings m
join Classes c on (m.class_id = c.id)
join ClassTypes ct on (c.type_id = ct.id)
join Courses co on (co.id = c.course_id)
join Subjects s on (s.id = co.subject_id)
join Terms t on (t.id = co.term_id)
where t.name = '19T3';
