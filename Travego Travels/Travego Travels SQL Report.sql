-- Problem Statement
-- Creating the schema and required tables using MySQL workbench.
 create database Trivago;
 USE TRIVAGO;
 
 CREATE TABLE  passengers(
		Passenger_id INT,
        Passenger_Name VARCHAR(50),
        Category VARCHAR(50),
        Gender VARCHAR(10),
        Boarding_City VARCHAR(20),
        Destination_City VARCHAR(20),
        Distance INT,
        Bus_Type VARCHAR(20)
);

CREATE TABLE Price(
		id INT,
        Bus_Type VARCHAR(20),
        Distance INT,
        Price INT);
        
ALTER TABLE Passenger RENAME TO Passengers;
insert into Passengers values
    (1, 'Sejal', 'AC', 'F', 'Bengaluru', 'Chennai', 350, 'Sleeper'),
    (2, 'Anmol', 'Non-AC', 'M', 'Mumbai', 'Hyderabad', 700, 'Sitting'),
    (3, 'Pallavi', 'AC', 'F', 'Panaji', 'Bengaluru', 600, 'Sleeper'),
    (4, 'Khusboo', 'AC', 'F', 'Chennai', 'Mumbai', 1500, 'Sleeper'),
    (5, 'Udit', 'Non-AC', 'M', 'Trivandrum', 'Panaji', 1000, 'Sleeper'),
    (6, 'Ankur', 'AC', 'M', 'Nagpur', 'Hyderabad', 500, 'Sitting'),
    (7, 'Hemant', 'Non-AC', 'M', 'Panaji', 'Mumbai', 700, 'Sleeper'),
    (8, 'Manish', 'Non-AC', 'M', 'Hyderabad', 'Bengaluru', 500, 'Sitting'),
    (9, 'Piyush', 'AC', 'M', 'Pune', 'Nagpur', 700, 'Sitting');
    
INSERT INTO Price VALUES
	 (1, 'Sleeper', 350, 770),
    (2, 'Sleeper', 500, 1100),
    (3, 'Sleeper', 600, 1320),
    (4, 'Sleeper', 700, 1540),
    (5, 'Sleeper', 1000, 2200),
    (6, 'Sleeper', 1200, 2640),
    (7, 'Sleeper', 1500, 2700),
    (8, 'Sitting', 500, 620),
    (9, 'Sitting', 600, 744),
    (10, 'Sitting', 700, 868),
    (11, 'Sitting', 1000, 1240),
    (12, 'Sitting', 1200, 1488),
    (13, 'Sitting', 1500, 1860);

SELECT * FROM Passengers;
SELECT * FROM Price;

--  How many female passengers traveled a minimum distance of 600 KMs?
SELECT * FROM Passengers
WHERE Distance<=600 AND Gender = "F";

-- Write a query to display the passenger details whose travel distance is greater than 500 and who are traveling in a sleeper bus
SELECT * FROM Passengers
WHERE Distance>=500 AND Bus_Type = "Sleeper";

-- Select passenger names whose names start with the character 'S'
SELECT * FROM Passengers
WHERE Passenger_Name LIKE "S%";

-- Calculate the price charged for each passenger, displaying the Passenger name, Boarding City, Destination City, Bus type, and Price in the output
SELECT Passenger_id, Passenger_Name, Boarding_City, Destination_City, p.Bus_Type,Price FROM Passengers as ps
INNER JOIN Price as p on p.id = ps.Passenger_id;

-- What are the passenger name(s) and the ticket price for those who traveled 1000 KMs Sitting in a  bus?
SELECT *,price FROM Passengers as ps
INNER JOIN Price as p on p.id = ps.Passenger_id
WHERE ps.Distance = "1000" AND ps.Bus_Type = "Sitting";

--  What will be the Sitting and Sleeper bus charge for Pallavi to travel from Panaji to Bangalore  ?
SELECT *,p.price FROM Passengers as ps
JOIN Price as p on  p.id = ps.passenger_id
WHERE  Passenger_Name = "Pallavi" AND Boarding_City = "Panaji"
		AND Destination_City ="Bengaluru";
        
-- Alter the column Name category with the value "Non-AC" where the Bus_Type is sleeper
SET SQL_SAFE_UPDATES = 0;

UPDATE Passengers
SET Category = "Non-AC"
WHERE Bus_Type = "Sleeper";

--  Delete an entry from the table where the passenger name is Piyush and commit this change in the database
Delete From Passengers
WHERE Passenger_Name = "Piyush";

commit;

-- Truncate the table passenger and count on the number of rows in the table (explain if required)
Truncate Passengers;

SELECT COUNT(*) FROM Passengers;

--  Delete the table passenger from the database.
DROP TABLE Passengers;





        
 
 