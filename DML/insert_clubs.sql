INSERT INTO clubs (name, country, city, establishment_year, stadium_id, league_id, coach_id)
VALUES 
('Manchester United', 'England', 'Greater Manchester', 1878, 1, 1, 1),
('FC Barcelona', 'Spain', 'Barcelona', 1899, 2, 2, 23),
('Bayern Munich', 'Germany', 'Munich', 1900, 3, 3, 5),
('AC Milan', 'Italy', 'Milan', 1899, 4, 4, 61),
('Paris Saint-Germain', 'France', 'Paris', 1970, 5, 5, 103),
('Manchester City', 'England', 'Manchester', 1880, 44, 1, 2),
('Liverpool', 'England', 'Liverpool', 1892, 11, 1, 3),
('Chelsea', 'England', 'London', 1905, 45, 1, 78),
('Arsenal', 'England', 'London', 1886, 16, 1, 20),
('Tottenham Hotspur', 'England', 'London', 1882, 46, 1, 9),
('Leicester City', 'England', 'Leicester', 1884, 47, 1, 15),
('West Ham United', 'England', 'London', 1895, 59, 1, 72),
('Everton', 'England', 'Liverpool', 1878, 48, 1, 77),
('Aston Villa', 'England', 'Birmingham', 1874, 53, 1, 21),
('Newcastle United', 'England', 'Newcastle', 1892, 50, 1, 68),
('Southampton', 'England', 'Southampton', 1885, 58, 1, 69),
('Crystal Palace', 'England', 'London', 1905, 55, 1, 81),
('Wolverhampton Wanderers', 'England', 'Wolverhampton', 1877, 49, 1, 28),
('Leeds United', 'England', 'Leeds', 1919, 51, 1, 19),
('Brighton & Hove Albion', 'England', 'Brighton', 1901, 54, 1, 44),
('West Bromwich', 'England', 'West Bromwich', 1882, 60, 1, 75),
('Sheffield United', 'England', 'Sheffield', 1902, 57, 1, 123),
('AFC Bournemouth', 'England', 'Bournemouth', 1881, 56, 1, 122),
('Fulham', 'England', 'Brentford', 1889, 52, 1, 124);

INSERT INTO clubs (name, country, city, establishment_year, stadium_id, league_id, coach_id)
VALUES 
('Real Madrid', 'Spain', 'Madrid', 1902, 19, 1, 6),
('Atletico Madrid', 'Spain', 'Madrid', 1903, 63, 1, 7),
('Sevilla FC', 'Spain', 'Seville', 1890, 64, 1, 24),
('Real Sociedad', 'Spain', 'San Sebastian', 1909, 125, 1, 129),
('Valencia CF', 'Spain', 'Valencia', 1919, 65, 1, 34),
('Villarreal CF', 'Spain', 'Villarreal', 1923, 67, 1, 131),
('Real Betis', 'Spain', 'Seville', 1907, 68, 1, 11),
('Athletic Bilbao', 'Spain', 'Bilbao', 1898, 66, 1, 133),
('Celta Vigo', 'Spain', 'Vigo', 1923, 130, 1, 134),
('Espanyol', 'Spain', 'Barcelona', 1900, 74, 1, 135),
('Granada CF', 'Spain', 'Granada', 1931, 79, 1, 136),
('Levante UD', 'Spain', 'Valencia', 1909, 133, 1, 137),
('Real Valladolid', 'Spain', 'Valladolid', 1928, 134, 1, 138),
('SD Huesca', 'Spain', 'Huesca', 1960, 135, 1, 139),
('Osasuna', 'Spain', 'Pamplona', 1920, 136, 1, 140),
('Getafe CF', 'Spain', 'Getafe', 1946, 73, 1, 141),
('Cadiz CF', 'Spain', 'Cadiz', 1910, 138, 1, 142),
('Alaves', 'Spain', 'Vitoria-Gasteiz', 1921, 139, 1, 143),
('Mallorca', 'Spain', 'Palma', 1916, 140, 1, 144);


CREATE OR REPLACE FUNCTION delete_same_clubs()
RETURNS VOID AS $$
DECLARE
    club_record RECORD;
    club_cursor CURSOR FOR
        SELECT name, country, MIN(club_id) AS min_club_id
        FROM clubs
        GROUP BY name, country
        HAVING COUNT(*) > 1;
BEGIN
    FOR club_record IN club_cursor
    LOOP
        DELETE FROM clubs
        WHERE name = club_record.name
        AND country = club_record.country
        AND club_id <> club_record.min_club_id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

select delete_same_clubs()