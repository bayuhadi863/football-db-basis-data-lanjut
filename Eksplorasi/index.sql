CREATE INDEX idx_players_name ON players(name);
CREATE INDEX idx_players_nationality ON players(nationality);
CREATE INDEX idx_players_position ON players(position);

EXPLAIN ANALYZE SELECT * FROM players 
WHERE name = 'Eddie Nketiah';

EXPLAIN ANALYZE SELECT * FROM players 
WHERE nationality = 'Ukraine';

EXPLAIN ANALYZE SELECT * FROM players 
WHERE position = 'Goalkeeper';
