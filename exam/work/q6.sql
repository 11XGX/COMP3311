-- COMP3311 12s1 Exam Q6
-- The Q6 view must have attributes called
-- (location,date,team1,goals1,team2,goals2)

drop view if exists Q6TeamMatches;
create view Q6TeamMatches as
select m.id as mid, m.city as location, m.playedOn as date, i.team as tid, t.country as team
from Matches m
join Involves i on (m.id = i.match)
join Teams t on (i.team = t.id);

drop view if exists Q6TeamPairs;
create view Q6TeamPairs as
select i1.mid as mid, i1.location as location, i1.date as date, i1.tid as t1id, i1.team as t1, i2.tid as t2id, i2.team as t2
from Q6TeamMatches i1
join Q6TeamMatches i2 on (i1.mid = i2.mid)
where i1.team < i2.team;

drop view if exists GoalsCount;
create view GoalsCount as
select g.scoredIn as mid, p.memberOf as tid, count(g.id) as gcount
from Goals g
join Players p on (g.scoredBy = p.id)
group by g.scoredIn, p.memberOf;

drop view if exists Q6;
create view Q6 as
select t.location as location, t.date as date, t.t1 as team1, ifnull(g1.gcount, 0) as goals1, t.t2 as team2, ifnull(g2.gcount, 0) as goals2
from Q6TeamPairs t
left outer join GoalsCount g1 on (t.mid = g1.mid and t.t1id = g1.tid)
left outer join GoalsCount g2 on (t.mid = g2.mid and t.t2id = g2.tid);
