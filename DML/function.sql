-- Fungsi Menampilkan Clubs dalam League Tertentu
CREATE or replace FUNCTION get_leagues_clubs(league_name varchar)
RETURNS TABLE (
  club_name varchar 
) 
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT c.name
  FROM clubs c
  JOIN leagues l ON c.league_id = l.league_id
  WHERE l.name = league_name;
END;
$$
-- Cara menjalankan 
-- SELECT * FROM get_leagues_clubs('Premier League');

-- Menampilkan list players di suatu club
CREATE OR REPLACE FUNCTION get_club_player(clubName varchar)
RETURNS TABLE (
  player_name VARCHAR,
  player_age INTEGER 
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT p.name, p.age 
  FROM players p
  JOIN club_players cp ON cp.player_id = p.player_id
  JOIN clubs c ON cp.club_id = c.club_id
  WHERE c.name = clubName;
END;
$$;

select * from get_club_player('Manchester United');