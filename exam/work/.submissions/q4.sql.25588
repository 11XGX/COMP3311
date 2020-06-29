-- COMP3311 12s1 Exam Q4
-- The Q4 view must have attributes called (team1,team2,matches)

drop view if exists TeamMatches;
create view TeamMatches as
select i.match as id, t.country as team
from Involves i
join Teams t on (i.team = t.id);

drop view if exists TeamPairs;
create view TeamPairs as
select i1.id as id, i1.team as t1, i2.team as t2
from TeamMatches i1
join TeamMatches i2 on (i1.id = i2.id)
where i1.team < i2.team;

drop view if exists MatchesCount;
create view MatchesCount as
select id, count(*) as mcount
from TeamPairs
group by t1, t2;

drop view if exists Q4;
create view Q4 as
select t1 as team1, t2 as team2, m.mcount as matches
from TeamPairs t
join MatchesCount m on (t.id = m.id)
where m.mcount = (select max(mcount) from MatchesCount);

