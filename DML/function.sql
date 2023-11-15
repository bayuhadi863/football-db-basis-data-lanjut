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

