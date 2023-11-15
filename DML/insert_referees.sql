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

INSERT INTO referees (name, nationality, age)
VALUES
('Howard Webb', 'England', 50),
('Pierluigi Collina', 'Italy', 61),
('Felix Brych', 'Germany', 46),
('Nestor Pitana', 'Argentina', 46),
('Cuneyt Cakir', 'Argentina', 45),
('Bjorn Kuipers', 'Netherlands', 48),
('Mark Geiger', 'United States', 47),
('Ravshan Irmatov', 'Uzbekistan', 44),
('Carlos Velasco Carballo', 'Spain', 50),
('Yuichi Nishimura', 'Japan', 50);

-- Premier League
INSERT INTO referees (name, nationality, age)
VALUES 
('Michael Oliver', 'England', 37),
('Anthony Taylor', 'England', 43),
('Andre Marriner', 'England', 50),
('Paul Tierney', 'England', 40),
('Craig Pawson', 'England', 42),
('Stuart Attwell', 'England', 38),
('Chris Kavanagh', 'England', 45),
('David Coote', 'England', 39),
('Jonathan Moss', 'England', 50),
('Martin Atkinson', 'England', 50);

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