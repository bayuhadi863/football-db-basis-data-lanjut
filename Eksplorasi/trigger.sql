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

