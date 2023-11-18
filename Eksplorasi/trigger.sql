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

-- Trigger untuk mengupdate home_score atau away_score setelah INSERT di tabel goal_details
CREATE OR REPLACE FUNCTION update_match_scores()
RETURNS TRIGGER AS $$
BEGIN
  -- Update home_score if club_id in goal_details is the home club
  UPDATE matches
  SET home_score = home_score + 1
  WHERE match_id = NEW.match_id AND NEW.club_id = club_home_id;

  -- Update away_score if club_id in goal_details is the away club
  UPDATE matches
  SET away_score = away_score + 1
  WHERE match_id = NEW.match_id AND NEW.club_id = club_away_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_goal_insert
AFTER INSERT ON goal_details
FOR EACH ROW
EXECUTE FUNCTION update_match_scores();

