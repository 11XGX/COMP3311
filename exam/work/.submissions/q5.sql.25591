-- COMP3311 12s1 Exam Q5
-- The Q5 view must have attributes called (team,reds,yellows)

drop view if exists CardPlayers;
create view CardPlayers as
select c.id as card_id, c.cardType as card_type, t.country as team
from Cards c
join Players p on (c.givenTo = p.id)
join Teams t on (p.memberOf = t.id);

drop view if exists YellowCardsByTeam;
create view YellowCardsByTeam as
select team, count(*) as yellows
from CardPlayers c
where c.card_type = 'yellow'
group by team;

drop view if exists RedCardsByTeam;
create view RedCardsByTeam as
select team, count(*) as reds
from CardPlayers c
where c.card_type = 'red'
group by team;

drop view if exists Q5;
create view Q5 as
select t.country as team, ifnull(r.reds, 0) as reds, ifnull(y.yellows, 0) as yellows
from Teams t
left outer join YellowCardsByTeam y on (t.country = y.team)
left outer join RedCardsByTeam r on (t.country = r.team);
