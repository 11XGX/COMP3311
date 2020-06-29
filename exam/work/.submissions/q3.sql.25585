-- COMP3311 12s1 Exam Q3
-- The Q3 view must have attributes called (team,players)

drop view if exists NoGoalPlayers;
create view NoGoalPlayers as
select p.name as player_name, t.country as team
from Players p
join Teams t on (p.memberOf = t.id)
where not exists
(select * from Goals g where p.id = g.scoredBy);


drop view if exists NoGoalCountry;
create view NoGoalCountry as
select team, count(player_name) as players
from NoGoalPlayers
group by team;

drop view if exists Q3;
create view Q3 as
select *
from NoGoalCountry
where players = (select max(players) from NoGoalCountry);
