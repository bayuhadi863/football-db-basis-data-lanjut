-- Menghapus Player yang sama
CREATE OR REPLACE PROCEDURE delete_same_player()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM players p1
    USING players p2
    WHERE p1.player_id <> p2.player_id 
        AND p1.name = p2.name 
        AND p1.player_id > p2.player_id 
        AND p2.player_id = (
            SELECT MIN(p3.player_id)
            FROM players p3
            WHERE p3.name = p1.name
        );

    COMMIT;
END;
$$;

call delete_same_player();

-- Menghapus league yang sama
CREATE OR REPLACE PROCEDURE delete_same_league()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM leagues p1
    USING leagues p2
    WHERE p1.league_id <> p2.league_id AND p1.name = p2.name AND p1.league_id > p2.league_id;
   
    COMMIT;
END;
$$;

call delete_same_league();

-- Menghapus coach yang sama
CREATE OR REPLACE PROCEDURE delete_same_coach()
LANGUAGE plpgsql
AS $$
BEGIN
     DELETE FROM coaches p1
    USING coaches p2
    WHERE p1.coach_id <> p2.coach_id AND p1.name = p2.name AND p1.coach_id > p2.coach_id;
    COMMIT;
END;
$$;

call delete_same_coach();

-- Menghapus stadium yang sama
CREATE OR REPLACE PROCEDURE delete_same_stadium()
LANGUAGE plpgsql
AS $$
BEGIN

     DELETE FROM stadiums p1
    USING stadiums p2
    WHERE p1.stadium_id <> p2.stadium_id AND p1.name = p2.name AND p1.stadium_id > p2.stadium_id;

    COMMIT;
END;
$$;

call delete_same_stadium();

-- menghapus referee yang sama
CREATE OR REPLACE PROCEDURE delete_same_referee()
LANGUAGE plpgsql
AS $$
BEGIN

     DELETE FROM referees p1
    USING referees p2
    WHERE p1.referee_id <> p2.referee_id AND p1.name = p2.name AND p1.referee_id > p2.referee_id;
    COMMIT;
END;
$$;

call delete_same_referee();

-- menghapus club yang sama
CREATE OR REPLACE PROCEDURE delete_same_clubs()
LANGUAGE plpgsql
AS $$
BEGIN
    DECLARE
        club_record RECORD;
        club_cursor CURSOR FOR
            SELECT name, country, MIN(club_id) AS min_club_id
            FROM clubs
            GROUP BY name, country
            HAVING COUNT(*) > 1;
    BEGIN
        OPEN club_cursor;
        LOOP
            FETCH club_cursor INTO club_record;
            EXIT WHEN NOT FOUND;
            
            DELETE FROM clubs
            WHERE name = club_record.name
            AND country = club_record.country
            AND club_id <> club_record.min_club_id;
        END LOOP;
        CLOSE club_cursor;
        COMMIT;
    END;
END;
$$;

call delete_same_clubs();

-- Menghapus player di club_players yang sama
CREATE OR REPLACE PROCEDURE delete_duplicate_club_players()
AS $$
BEGIN
    -- Menghapus data duplikat dengan player_id yang sama
    DELETE FROM club_players
    WHERE (player_id, club_player_id) NOT IN (
        SELECT player_id, MIN(club_player_id)
        FROM club_players
        GROUP BY player_id
    );
END;
$$ LANGUAGE plpgsql;

CALL delete_duplicate_club_players();

-- Menambahkan match win pada league_klasmen
CREATE OR REPLACE PROCEDURE update_match_win(
    in_league_id INT,
    in_club_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE league_klasmen
    SET match_win = match_win + 1
    WHERE league_id = in_league_id AND club_id = in_club_id;
END;
$$;

CALL update_match_win(2, 9);

-- menambahkan match_draw pada league_klasmen
CREATE OR REPLACE PROCEDURE update_match_draw(
    in_league_id INT,
    in_club_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE league_klasmen
    SET match_draw = match_draw + 1
    WHERE league_id = in_league_id AND club_id = in_club_id;
END;
$$;
CALL update_match_draw(2, 15);

-- menambahkan match_lose pada league_klasmen
CREATE OR REPLACE PROCEDURE update_match_lose(
    in_league_id INT,
    in_club_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE league_klasmen
    SET match_lose = match_lose + 1
    WHERE league_id = in_league_id AND club_id = in_club_id;
END;
$$;
CALL update_match_lose(2, 16);