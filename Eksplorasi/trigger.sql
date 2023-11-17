-- Trigger update club_players setelah insert player_transfers
CREATE OR REPLACE FUNCTION update_club_players_on_transfer()
RETURNS TRIGGER AS $$
BEGIN
    -- Update club_players when a player_transfer record is inserted
    UPDATE club_players
    SET club_id = NEW.new_club_id
    WHERE player_id = NEW.player_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER player_transfer_trigger
AFTER INSERT ON player_transfers
FOR EACH ROW
EXECUTE FUNCTION update_club_players_on_transfer();

-- Update total point league_klasmen setelah match_win atau match_draw diupdate
CREATE OR REPLACE FUNCTION update_total_point_on_league_klasmen_update()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.match_win > OLD.match_win THEN
        UPDATE league_klasmen
        SET total_point = total_point + 3
        WHERE league_id = NEW.league_id AND club_id = NEW.club_id;
    ELSIF NEW.match_draw > OLD.match_draw THEN
        UPDATE league_klasmen
        SET total_point = total_point + 1
        WHERE league_id = NEW.league_id AND club_id = NEW.club_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER league_klasmen_update_trigger
AFTER UPDATE ON league_klasmen
FOR EACH ROW
EXECUTE FUNCTION update_total_point_on_league_klasmen_update();


