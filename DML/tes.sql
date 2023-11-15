select * from coaches where name like '%Ann%';
select * from stadiums where name like '%Tot%';
select * from leagues where name like '%L%';
select * 
from players 
where name like '%Broja%';
select * 
from players 
where player_id > 749;
select * from stadiums;
select * from clubs;
select c.name, p.name
from clubs c
join club_players cp 
on cp.club_id = c.club_id
join players p 
on p.player_id = cp.player_id;