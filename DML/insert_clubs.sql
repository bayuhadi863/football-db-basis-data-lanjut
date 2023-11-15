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