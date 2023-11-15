INSERT INTO leagues (name, country)
VALUES 
('La Liga', 'Spanish'),
('Premier League', 'English'),
('Bundesliga', 'German'),
('Serie A', 'Italian'),
('Ligue 1', 'French'),
('Eredivisie', 'Dutch'),
('Primeira Liga', 'Portuguese'),
('Russian Premier League', 'Russian'),
('Brasileirao Serie A', 'Brazilian'),
('Argentine Primera División', 'Argentinian');

CREATE OR REPLACE FUNCTION delete_same_league()
RETURNS VOID AS $$
BEGIN
   
    DELETE FROM leagues p1
    USING leagues p2
    WHERE p1.league_id <> p2.league_id AND p1.name = p2.name AND p1.league_id > p2.league_id;
   
    RETURN;
END;
$$ LANGUAGE plpgsql;

select delete_same_league();