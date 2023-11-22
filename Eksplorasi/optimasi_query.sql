-- Membandingkan efektifitas penggunaan JOIN vs penggunaan Subquery
--- JOIN
EXPLAIN ANALYZE SELECT c.name as club_name, p.player_id, p.name as player_name
FROM players p
join club_players cp on cp.player_id = p.player_id
join clubs c on cp.club_id = c.club_id
where c.name = 'Manchester United';
--- Subquery
EXPLAIN ANALYZE SELECT p.player_id, p.name as player_name
FROM players p
join club_players cp on cp.player_id = p.player_id
where cp.club_id = (select club_id from clubs where name = 'Manchester United');


-- Membandingkan JOIN dan WHERE
EXPLAIN ANALYZE SELECT l.name, c.name
FROM clubs c
INNER JOIN leagues l ON c.league_id = l.league_id;

EXPLAIN ANALYZE SELECT l.name, c.name
FROM clubs c, leagues l
WHERE c.league_id = l.league_id;

-- Membandingkan EXISTS vs IN
EXPLAIN ANALYZE SELECT p.player_id, p.name
FROM players p
WHERE EXISTS 
	(
	 SELECT 1 FROM match_lineups ml 
	 WHERE  ml.player_id = p.player_id AND ml.club_id = 9
	);
	
EXPLAIN ANALYZE SELECT p.player_id, p.name
FROM players p
WHERE p.player_id IN 
	(
	 SELECT ml.player_id 
	 FROM match_lineups ml 
	 WHERE ml.club_id = 9
	);

-- Membandingkan OR versi panjang vs versi pendek (IN)
EXPLAIN ANALYZE SELECT name, capacity, city
FROM stadiums
WHERE city = 'Liverpool' OR city = 'London' OR city = 'Brighton';

EXPLAIN ANALYZE SELECT name, capacity, city
FROM stadiums
WHERE city IN ('Liverpool', 'London', 'Brighton');

-- Membandingkan filtering pada kolom name dengan filtering pada kolom player_id (primary key)
EXPLAIN ANALYZE SELECT c.name as club_name, p.player_id, p.name as player_name
FROM players p
join club_players cp on cp.player_id = p.player_id
join clubs c on cp.club_id = c.club_id
where p.name = 'Karim Benzema';

EXPLAIN ANALYZE SELECT c.name as club_name, p.player_id, p.name as player_name
FROM players p
join club_players cp on cp.player_id = p.player_id
join clubs c on cp.club_id = c.club_id
where p.player_id = 111;
