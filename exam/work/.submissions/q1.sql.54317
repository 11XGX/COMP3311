-- COMP3311 12s1 Exam Q1
-- The Q1 view must have attributes called (team,matches)

drop view if exists q1;
create view q1 as
select t.country as team, count(m.id) as matches
from Matches m
join Involves i on (m.id = i.match)
join Teams t on (i.team = t.id);
group by t.id;
