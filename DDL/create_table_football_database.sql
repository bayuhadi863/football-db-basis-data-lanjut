CREATE TABLE leagues (
    league_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL
);

CREATE TABLE stadiums (
    stadium_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE coaches (
    coach_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    annual_salary INT DEFAULT 0
);

CREATE TABLE clubs (
    club_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    establishment_year INT NOT NULL,
    stadium_id INT REFERENCES stadiums(stadium_id),
    league_id INT REFERENCES leagues(league_id)
);

ALTER TABLE clubs
ADD COLUMN coach_id INT REFERENCES coaches(coach_id) UNIQUE;

CREATE TABLE league_winners (
    league_winner_id SERIAL PRIMARY KEY,
    league_id INT REFERENCES leagues(league_id),
    club_id INT REFERENCES clubs(club_id)
);

ALTER TABLE league_winners
ADD CONSTRAINT unique_league_club_pair UNIQUE (league_id, club_id);

CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    position VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    team_number INT DEFAULT NULL,
    height INT NOT NULL,
    market_value INT DEFAULT 0,
    annual_salary INT DEFAULT 0
);

CREATE TABLE club_players (
    club_player_id SERIAL PRIMARY KEY,
    club_id INT REFERENCES clubs(club_id),
    player_id INT REFERENCES players(player_id)
);

CREATE TABLE league_klasmen (
    league_klasmen_id SERIAL PRIMARY KEY,
    rank INT NOT NULL,
    league_id INT REFERENCES leagues(league_id),
    club_id INT REFERENCES clubs(club_id),
    total_point INT DEFAULT 0,
    match_win INT DEFAULT 0,
    match_draw INT DEFAULT 0,
    match_lose INT DEFAULT 0,
    goal_scored INT DEFAULT 0,
    goal_againts INT DEFAULT 0
);

ALTER TABLE league_klasmen
ADD CONSTRAINT unique_club_id UNIQUE (club_id);

CREATE TABLE player_transfers (
    player_transfer_id SERIAL PRIMARY KEY,
    old_club_id INT REFERENCES clubs(club_id),
    new_club_id INT REFERENCES clubs(club_id),
    player_id INT REFERENCES players(player_id),
    transfer_fee INT DEFAULT 0,
    transfer_status VARCHAR(255) NOT NULL,
    transfer_time TIMESTAMP NOT NULL
);

CREATE TABLE individual_achievements (
    individual_achievement_id SERIAL PRIMARY KEY,
    name_id VARCHAR(255) NOT NULL,
    player_id INT REFERENCES players(player_id)
);

ALTER TABLE individual_achievements
RENAME COLUMN name_id TO name;

CREATE TABLE club_achievements (
    club_achievement_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    club_id INT REFERENCES clubs(club_id)
);

CREATE TABLE tournaments (
    tournament_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    continent VARCHAR(255) DEFAULT NULL,
    country VARCHAR(255) DEFAULT NULL,
    winner_id INT REFERENCES clubs(club_id)
);

ALTER TABLE tournaments
DROP COLUMN winner_id;

CREATE TABLE tournament_clubs (
    tournament_club_id SERIAL PRIMARY KEY,
    tournament_id INT REFERENCES tournaments(tournament_id),
    club_id INT REFERENCES clubs(club_id)
);

CREATE TABLE tournament_winners (
    tournament_winner_id SERIAL PRIMARY KEY,
    tournament_id INT REFERENCES tournaments(tournament_id),
    club_id INT REFERENCES clubs(club_id)
);

ALTER TABLE tournament_clubs
ADD COLUMN is_eliminated BOOLEAN DEFAULT false,
ADD COLUMN eliminated_in VARCHAR(255) DEFAULT NULL;

CREATE TABLE referees (
    referee_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE matches (
    match_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    club_home_id INT REFERENCES clubs(club_id),
    club_away_id INT REFERENCES clubs(club_id),
    stadium_id INT REFERENCES stadiums(stadium_id),
    match_time TIMESTAMP NOT NULL,
    home_score INT DEFAULT 0,
    away_score INT DEFAULT 0,
    referee_id INT REFERENCES referees(referee_id),
    man_of_the_match INT REFERENCES players(player_id)
);

CREATE TABLE league_matches (
    league_match_id SERIAL PRIMARY KEY,
    league_id INT REFERENCES leagues(league_id),
    match_id INT REFERENCES matches(match_id),
    UNIQUE (match_id)
);

CREATE TABLE tournament_matches (
    tournament_match_id SERIAL PRIMARY KEY,
    tournament_id INT REFERENCES tournaments(tournament_id),
    match_id INT REFERENCES matches(match_id),
    UNIQUE (match_id)
);

CREATE TABLE match_lineups (
    match_lineup_id SERIAL PRIMARY KEY,
    match_id INT REFERENCES matches(match_id),
    player_id INT REFERENCES players(player_id),
    club_id INT REFERENCES clubs(club_id),
    play_duration INT DEFAULT 0
);

CREATE TABLE match_statistics (
    match_statistic_id SERIAL PRIMARY KEY,
    match_id INT REFERENCES matches(match_id) UNIQUE,
    home_possession INT DEFAULT 50,
    away_possession INT DEFAULT 50,
    home_shots INT DEFAULT 0,
    away_shots INT DEFAULT 0,
    home_shots_on_target INT DEFAULT 0,
    away_shots_on_target INT DEFAULT 0,
    home_fouls INT DEFAULT 0,
    away_fouls INT DEFAULT 0,
    home_passes INT DEFAULT 0,
    away_passes INT DEFAULT 0,
    home_pass_accuracy INT DEFAULT 0,
    away_pass_accuracy INT DEFAULT 0,
    home_yellow_cards INT DEFAULT 0,
    away_yellow_cards INT DEFAULT 0,
    home_red_cards INT DEFAULT 0,
    away_red_cards INT DEFAULT 0,
    home_offsides INT DEFAULT 0,
    away_offsides INT DEFAULT 0,
    home_corners INT DEFAULT 0,
    away_corners INT DEFAULT 0
);

CREATE TABLE goal_details (
    goal_detail_id SERIAL PRIMARY KEY,
    match_id INT REFERENCES matches(match_id),
    goal_scorer_id INT REFERENCES players(player_id),
    goal_assist_provider_id INT REFERENCES players(player_id),
    club_id INT REFERENCES clubs(club_id),
    goal_type VARCHAR(255) NOT NULL,
    goal_time INT NOT NULL
);

















