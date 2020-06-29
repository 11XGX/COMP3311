-- COMP3311 12s1 Exam Q2
-- The Q2 view must have one attribute called (player,goals)

drop view if exists Q2helper;
create view Q2helper as
select p.name as player, count(p.id) as goals
from Goals g
join Players p on (g.scoredBy = p.id)
where g.rating = 'amazing'
group by p.id;

drop view if exists Q2;
create view Q2 as
select player, goals
from Q2helper
where goals > 1;
