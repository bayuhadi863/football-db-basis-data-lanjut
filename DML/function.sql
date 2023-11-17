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

-- Function untuk menampilkan player yang bermain di pertandingan
CREATE OR REPLACE FUNCTION get_players_in_match(match_id INTEGER)
RETURNS TABLE (
  player_id INTEGER,
  player_name VARCHAR,
  team_name VARCHAR,
  team_side VARCHAR,
  play_duration INTEGER
)
AS $$
BEGIN
  RETURN QUERY
    SELECT
      mp.player_id,
      p.name AS player_name,
      c.name AS team_name,
      CASE
        WHEN mp.club_id = m.club_home_id THEN 'Home'::VARCHAR
        ELSE 'Away'::VARCHAR
      END AS team_side,
      mp.play_duration
    FROM
      match_lineups mp
    JOIN
      players p ON mp.player_id = p.player_id
    JOIN
      matches m ON mp.match_id = m.match_id
    JOIN
      clubs c ON mp.club_id = c.club_id
    WHERE
      mp.match_id = get_players_in_match.match_id AND mp.play_duration > 0;
END;
$$ LANGUAGE plpgsql;

select * from get_players_in_match(33)
WHERE team_name = 'Manchester City';

-- Membandingkan susunan pemain suatu club dalam beberapa match
CREATE OR REPLACE FUNCTION compare_lineups_by_club(match_id_1 INTEGER, match_id_2 INTEGER, club_name VARCHAR)
RETURNS TABLE (
  player_id INTEGER,
  player_name VARCHAR,
  in_match_1 BOOLEAN,
  in_match_2 BOOLEAN
)
AS $$
BEGIN
  RETURN QUERY
    SELECT
      p.player_id,
      p.name AS player_name,
      CASE WHEN ml1.player_id IS NOT NULL THEN TRUE ELSE FALSE END AS in_match_1,
      CASE WHEN ml2.player_id IS NOT NULL THEN TRUE ELSE FALSE END AS in_match_2
    FROM
      players p
    LEFT JOIN
      match_lineups ml1 ON p.player_id = ml1.player_id AND ml1.match_id = match_id_1
    LEFT JOIN
      match_lineups ml2 ON p.player_id = ml2.player_id AND ml2.match_id = match_id_2
    JOIN
      club_players cp ON p.player_id = cp.player_id
    JOIN
      clubs c ON cp.club_id = c.club_id AND c.name = club_name;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM compare_lineups_by_club(33, 2, 'FC Barcelona');

-- Function menampilkan statistics suatu match
CREATE OR REPLACE FUNCTION get_match_statistics(match_id INTEGER)
RETURNS TABLE (
  home_possession INTEGER,
  away_possession INTEGER,
  home_shots INTEGER,
  away_shots INTEGER,
  home_shots_on_target INTEGER,
  away_shots_on_target INTEGER,
  home_fouls INTEGER,
  away_fouls INTEGER,
  home_passes INTEGER,
  away_passes INTEGER,
  home_pass_accuracy INTEGER,
  away_pass_accuracy INTEGER,
  home_yellow_cards INTEGER,
  away_yellow_cards INTEGER,
  home_red_cards INTEGER,
  away_red_cards INTEGER,
  home_offsides INTEGER,
  away_offsides INTEGER,
  home_corners INTEGER,
  away_corners INTEGER
)
AS $$
BEGIN
  RETURN QUERY
    SELECT
      ms.home_possession,
      ms.away_possession,
      ms.home_shots,
      ms.away_shots,
      ms.home_shots_on_target,
      ms.away_shots_on_target,
      ms.home_fouls,
      ms.away_fouls,
      ms.home_passes,
      ms.away_passes,
      ms.home_pass_accuracy,
      ms.away_pass_accuracy,
      ms.home_yellow_cards,
      ms.away_yellow_cards,
      ms.home_red_cards,
      ms.away_red_cards,
      ms.home_offsides,
      ms.away_offsides,
      ms.home_corners,
      ms.away_corners
    FROM
      match_statistics ms
    WHERE
      ms.match_id = get_match_statistics.match_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_match_statistics(1);

-- Function menampilkan coach yang memenangkan suatu tournament
CREATE OR REPLACE FUNCTION get_championTournament_coaches(id_tournament INTEGER)
RETURNS TABLE (
  coach_id INTEGER,
  coach_name VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
    SELECT DISTINCT
      c.coach_id,
      c.name AS coach_name
    FROM
      coaches c
    JOIN
      clubs cl ON c.coach_id = cl.coach_id
    JOIN
      tournament_winners tw ON cl.club_id = tw.club_id
    WHERE
      tw.tournament_id = tournament_id;
END;
$$ LANGUAGE plpgsql;

select * from get_championTournament_coaches(1);

-- Function menampilkan coach yang memenangkan liga
CREATE OR REPLACE FUNCTION get_champion_coaches(id_league INTEGER)
RETURNS TABLE (
  coach_id INTEGER,
  coach_name VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
    SELECT DISTINCT
      c.coach_id,
      c.name AS coach_name
    FROM
      coaches c
    JOIN
      clubs cl ON c.coach_id = cl.coach_id
    JOIN
      league_winners lw ON cl.club_id = lw.club_id
    WHERE
      lw.league_id = id_league;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_champion_coaches(2);

-- Function menampilkan pemain dengan jumlah goal terbanyak dalam turnamen
CREATE OR REPLACE FUNCTION top_scorer_in_tournament(tournament_id INTEGER)
RETURNS TABLE (
  player_id INTEGER,
  player_name VARCHAR,
  total_goals BIGINT
)
AS $$
BEGIN
  RETURN QUERY
    SELECT
      gd.goal_scorer_id AS player_id,
      p.name AS player_name,
      COUNT(gd.goal_scorer_id)::BIGINT AS total_goals
    FROM
      goal_details gd
    JOIN
      players p ON gd.goal_scorer_id = p.player_id
    JOIN
      matches m ON gd.match_id = m.match_id
    JOIN
      tournament_matches tm ON m.match_id = tm.match_id
    WHERE
      tm.tournament_id = top_scorer_in_tournament.tournament_id
    GROUP BY
      gd.goal_scorer_id, p.name
    ORDER BY
      total_goals DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;


select * from top_scorer_in_tournament(1);

-- Function untuk menampilkan 3 player dengan market value tertinggi
CREATE OR REPLACE FUNCTION player_highest_market_value()
RETURNS TABLE (
  player_id INTEGER,
  player_name VARCHAR,
  market_value INTEGER
)
AS $$
BEGIN
  RETURN QUERY
    SELECT
      p.player_id,
      p.name AS player_name,
      p.market_value
    FROM
      players p
    ORDER BY
      p.market_value DESC
    LIMIT 3;
END;
$$ LANGUAGE plpgsql;

select * from player_highest_market_value();

-- Function melihat player dengan goal liga terbanyak
CREATE OR REPLACE FUNCTION top_goalscorers_league(id_league INTEGER)
RETURNS TABLE (player_name VARCHAR, goals bigint) 
AS $$
BEGIN
  RETURN QUERY
    SELECT p.name, COUNT(*) AS goals
    FROM goal_details gd
    JOIN players p ON p.player_id = gd.goal_scorer_id
    JOIN matches m ON m.match_id = gd.match_id
    JOIN league_matches lm ON lm.match_id = m.match_id
    WHERE lm.league_id = id_league
    GROUP BY p.name
    ORDER BY goals DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM top_goalscorers_league(2);

--Function melihat total goal suatu club
CREATE OR REPLACE FUNCTION total_goals_by_club(club_id INTEGER)
RETURNS INTEGER
AS $$
DECLARE
  total_goals INTEGER;
BEGIN
  SELECT COUNT(*) INTO total_goals
  FROM goal_details gd
  JOIN matches m ON m.match_id = gd.match_id
  JOIN club_players cp ON cp.club_id = $1
  WHERE cp.player_id = gd.goal_scorer_id;

  RETURN total_goals;
END;
$$ LANGUAGE plpgsql;

select * from total_goals_by_club(9);

-- Function Melihat total win club
CREATE OR REPLACE FUNCTION total_wins_by_club(club_id INTEGER)
RETURNS INTEGER
AS $$
DECLARE
  total_wins INTEGER;
BEGIN
  SELECT COUNT(*) INTO total_wins
  FROM matches m
  WHERE (m.club_home_id = $1 AND m.home_score > m.away_score) OR (m.club_away_id = $1 AND m.away_score > m.home_score);

  RETURN total_wins;
END;
$$ LANGUAGE plpgsql;

select total_wins_by_club(9);

-- Menghitung total goal player
CREATE OR REPLACE FUNCTION total_goals_by_player(namePlayer VARCHAR)
RETURNS INTEGER AS $$
DECLARE
  total_goals INTEGER;
BEGIN
  SELECT COUNT(*) INTO total_goals
  FROM goal_details gd
  JOIN players p ON gd.goal_scorer_id = p.player_id
  WHERE p.name = namePlayer;

  RETURN total_goals;
END;
$$ LANGUAGE plpgsql;

select * from total_goals_by_player('Pedri');