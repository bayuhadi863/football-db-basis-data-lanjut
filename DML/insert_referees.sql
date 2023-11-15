INSERT INTO referees (name, nationality, age)
VALUES 
('Howard Webb', 'England', 50),
('Pierluigi Collina', 'Italy', 61),
('Felix Brych', 'Germany', 46),
('Nestor Pitana', 'Argentina', 46),
('Cuneyt Cakir', 'Turkey', 45),
('Bjorn Kuipers', 'Netherlands', 48),
('Mark Geiger', 'United States', 47),
('Ravshan Irmatov', 'Uzbekistan', 44),
('Carlos Velasco Carballo', 'Spain', 50),
('Yuichi Nishimura', 'Japan', 50);

CREATE OR REPLACE FUNCTION delete_same_referee()
RETURNS VOID AS $$
BEGIN
   
    DELETE FROM referees p1
    USING referees p2
    WHERE p1.referee_id <> p2.referee_id AND p1.name = p2.name AND p1.referee_id > p2.referee_id;
   
    RETURN;
END;
$$ LANGUAGE plpgsql;

select delete_same_referee();