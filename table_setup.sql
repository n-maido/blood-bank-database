-- CREATE Entity tables
CREATE TABLE Blood_Bank(
 	instNo SERIAL UNIQUE,
 	address char(40),
 	PRIMARY KEY (instNo)
);

CREATE TABLE Blood_Drive(
 	driveID SERIAL UNIQUE,
 	instNo SERIAL UNIQUE,
address char(40),
 	PRIMARY KEY (driveID),
CONSTRAINT fk_instNo FOREIGN KEY(instNo) REFERENCES Blood_Bank(instNo)
); 


CREATE TABLE Hospital(
 	instNo SERIAL UNIQUE,
 	address char(40),
 	PRIMARY KEY (instNo)
);

CREATE TABLE Volunteer(
	vID SERIAL UNIQUE,
 	name char(40),
 	PRIMARY KEY (vID)
);


CREATE TABLE Donor_Contact(
	email char(40),
 	phoneNo TEXT,
	address char(40),
 	name char(40),
	PRIMARY KEY (email)
);

CREATE TABLE Donor(
	donorID SERIAL UNIQUE,
 	dob date,
 	gender char(40),
 	weight DECIMAL(3,1),
 	totDonations integer,
 	eligibility boolean,
 	bloodType char(40),
 	email char(40) UNIQUE,
 	CONSTRAINT fk_email FOREIGN KEY(email) REFERENCES Donor_Contact(email)
);
 	
CREATE TABLE Blood_Bag (
 	bloodID SERIAL UNIQUE, 
 	expiryDate date, 
 	bloodType char(40),
 	quantity integer, 
 	donationDate date, 
 	bloodStatus char(40), 
 	curAddress char(40), 
 	PRIMARY KEY (bloodID) 
);  


CREATE TABLE Recipient (
 	rID SERIAL UNIQUE, 
 	name char(40), 
 	dob date, 
 	gender char(40), 
 	weight DECIMAL(3,1), 
 	bloodType char(40), 
 	PRIMARY KEY (rID) 
);


CREATE TABLE Phlebotomist (
 	phlebID SERIAL UNIQUE, 
 	name char(40), 
 	instNo SERIAL UNIQUE, 
 	PRIMARY KEY (phlebID),
FOREIGN KEY (instNo) REFERENCES Blood_Bank(instNo)
);


CREATE TABLE Red_Blood_Cells (
 	bloodID SERIAL UNIQUE, 
 	hematocritLevel DECIMAL(4,2), 
 	hemoglobinLevel DECIMAL(3,1), 
 	CONSTRAINT fk_bloodID FOREIGN KEY(bloodID) REFERENCES Blood_Bag(bloodID) 
);

CREATE TABLE Plasma (
 	bloodID SERIAL UNIQUE, 
 	plasmaCount int, 
 	CONSTRAINT fk_bloodID FOREIGN KEY(bloodID) REFERENCES Blood_Bag(bloodID)
);


CREATE TABLE Platelets(
 	bloodID SERIAL UNIQUE, 
 	plateletsCount int, 
 	CONSTRAINT fk_bloodID FOREIGN KEY(bloodID) REFERENCES Blood_Bag(bloodID)
);

-- CREATE Relationship tables

CREATE TABLE Conduct_Questionnaire(
	vID SERIAL UNIQUE, 
donorID SERIAL UNIQUE,
PRIMARY KEY (vID, donorID),
	FOREIGN KEY (vID) REFERENCES Volunteer(vID)
ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (donorID) REFERENCES Donor(donorID)
		ON DELETE SET NULL
ON UPDATE CASCADE
);

CREATE TABLE Donate_Donor(
	donorID SERIAL UNIQUE,
 	time TIMESTAMP UNIQUE,
	driveID SERIAL UNIQUE,
	instNo SERIAL UNIQUE,
PRIMARY KEY (donorID, time),
	FOREIGN KEY (donorID) REFERENCES Donor(donorID)
ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (driveID) REFERENCES Blood_Drive(driveID)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (instNo) REFERENCES Blood_Bank(instNo)
		ON DELETE SET NULL
ON UPDATE CASCADE
);

CREATE TABLE Donate_Blood(
	bloodID SERIAL UNIQUE,
	donorID SERIAL UNIQUE,
 	time TIMESTAMP, 
 	PRIMARY KEY (bloodID),
 	FOREIGN KEY (bloodID) REFERENCES Blood_Bag(bloodID),
	FOREIGN KEY (donorID) REFERENCES Donor(donorID),
	FOREIGN KEY (time) REFERENCES Donate_Donor(time)
);

CREATE TABLE TransportToBloodBank(
	bloodID SERIAL UNIQUE,
	driveID SERIAL UNIQUE,
	instNo SERIAL UNIQUE,
	time TIMESTAMP,
	PRIMARY KEY (bloodID),
	FOREIGN KEY (bloodID) REFERENCES Blood_Bag(bloodID)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (driveID) REFERENCES Blood_Drive(driveID)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (instNo) REFERENCES Blood_Bank(instNo)
		ON DELETE SET NULL
ON UPDATE CASCADE
);

CREATE TABLE TransportToHospital(
	bloodID SERIAL UNIQUE,
	bankInstNo SERIAL UNIQUE,
	hospitalInstNo SERIAL UNIQUE,
	time TIMESTAMP,
	PRIMARY KEY (bloodID),
	FOREIGN KEY (bloodID) REFERENCES Blood_Bag(bloodID)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (bankInstNo) REFERENCES Blood_Bank(instNo)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (hospitalInstNo) REFERENCES Hospital(instNo)
		ON DELETE SET NULL
ON UPDATE CASCADE
);

CREATE TABLE DisposeBlood(
	bankInstNo SERIAL UNIQUE,
	bloodID SERIAL UNIQUE,
	time TIMESTAMP,
	PRIMARY KEY (bloodID),
	FOREIGN KEY (bankInstNo) REFERENCES Blood_Bank(instNo)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (bloodID) REFERENCES Blood_Bag(bloodID)
		ON DELETE SET NULL
ON UPDATE CASCADE
);

CREATE TABLE TestBlood(
	bloodID SERIAL UNIQUE,
	instNo SERIAL UNIQUE,
	phlebID SERIAL UNIQUE,
	time TIMESTAMP,	
	PRIMARY KEY (bloodID),
	FOREIGN KEY (bloodID) REFERENCES Blood_Bag(bloodID)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (instNo) REFERENCES Blood_Bank(instNo)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (phlebID) REFERENCES Phlebotomist(phlebID)
		ON DELETE SET NULL
ON UPDATE CASCADE
);

CREATE TABLE Transfusion(
	rID SERIAL UNIQUE,
	instNo SERIAL UNIQUE,
	time TIMESTAMP,
	FOREIGN KEY (rID) REFERENCES Recipient(rID)
		ON DELETE SET NULL
ON UPDATE CASCADE,
	FOREIGN KEY (instNo) REFERENCES Hospital(instNo)
		ON DELETE SET NULL
ON UPDATE CASCADE
);






-- POPULATE Tables
INSERT INTO public.blood_bag(
	bloodid, expirydate, bloodtype, quantity, donationdate, bloodstatus, curaddress)
	VALUES 
	(111, '2022-01-01', 'A+', 200, '2021-01-01', 'Ready For Transport', '3415 Okanagan, Armstrong, BC'),
	(222, '2022-02-02', 'B+', 210, '2021-02-02', 'Frozen', '2447 Main St, Westbank, BC'),
	(333, '2022-03-03', 'AB+', 220, '2021-03-03', 'Disposed', '4101 Shelbourne St, Toronto, ON'),
	(444, '2022-04-04', 'O+', 230, '2021-04-04', 'Testing', '1003 Frigon, Shawinigan, QC'),
	(555, '2022-05-5', 'O-', 240, '2021-05-05', 'Untested', '1015 Lake Shore Blvd, Toronto, ON'),
	(666, '2022-01-01','A+', 250, '2021-01-01', 'Ready For Transport', '3415 Okanagan, Armstrong, BC'),
	(777, '2022-02-02','B+', 260, '2021-02-02', 'Frozen', '2447 Main St, Westbank, BC'),
	(888, '2022-03-03','AB+',270, '2021-03-03', 'Disposed', '4101 Shelbourne St, Toronto, ON'),
	(999, '2022-04-04','O+', 280, '2021-04-04', 'Testing', '1003 Frigon, Shawinigan, QC'),
	(1111,'2022-05-05','O-', 290, '2021-01-01', 'Ready For Transport', '3415 Okanagan, Armstrong, BC'),
	(1222,'2022-01-01','A+', 300, '2021-02-02', 'Frozen','2447 Main St, Westbank, BC'),
	(1333,'2022-02-02','B+', 310, '2021-03-03', 'Disposed','4101 Shelbourne St, Toronto, ON'),
	(1444,'2022-03-03','AB+',320,'2021-04-04','Testing','1003 Frigon, Shawinigan, QC'),
	(1555,'2022-04-04','O+', 330,'2021-01-01','Ready For Transport','3415 Okanagan, Armstrong, BC'),
	(1666,'2022-05-05','O-', 340,'2021-02-02','Frozen','2447 Main St, Westbank, BC');

INSERT INTO public.blood_bank(
	instno, address)
	VALUES 
	(1, '3415 Okanagan, Armstrong, BC'),
	(2, '2447 Main St, Westbank, BC'),
	(3, '82 Buttonwood Ave, Toronto, ON'),
	(4, '1003 Frigon, Shawinigan, QC'),
	(5, '1015 Lake Shore Blvd, Toronto, ON');

INSERT INTO public.blood_drive(
	driveid, instno, address)
	VALUES 
	(1, 1, '1200 Okanagan, Armstrong, BC'),
	(2,2, '1580 Elm St, Westbank, BC'),
	(3,3, '100 Burner Ave, Toronto, ON'),
	(4,4, '8080 Frigon, Shawinigan, QC'),
	(5,5, '800 Night St, Toronto, ON');

INSERT INTO public.hospital(
	instno, address)
	VALUES 
	(11, '10315 120 St, Armstrong, BC'),
	(22, '800 Main, Westbank, BC'),
	(33, '4101 Shelbourne St, Toronto, ON'),
	(44, '3512 Roblin Blvd, Shawinigan, QC'),
	(55, '6110 Currents Drive, Toronto, ON');

INSERT INTO public.volunteer(
	vid, name)
	VALUES 
	(1, 'Sam Uley'),
	(2, 'Embry Call'),
	(3, 'Paul Lahote'),
	(4, 'Jared Cameron'),
	(5, 'Leah Clearwater');

INSERT INTO public.donor_contact(
	email, phoneno, address, name)
	VALUES 
	('Bella_Swan@gmail.com', '(250)-248-3720', '4031 Brassard, Toronto, ON', 'Bella Swan'),
	('Ed_cull@hotmail.com', '(450)-324-2149', '920 Boulevard, Grande Prairie, AB', 'Edward Cullen'),
	('J_black@aol.com', '(604)-231-3192','2430 Crowchild, Bayfield, BC', 'Jacob Black'),
	('CharlieS@sfu.ca', '(778)-783-1029','146 Main S,Markham, ON','Charlie Swan'),
	('bubblegumAlice@yahoo.com','(381)-060-0400','517 Bloor W, saskatoon, SK','Alice Cullen');

INSERT INTO public.donor(
	donorid, dob, gender, weight, totdonations, eligibility, bloodtype, email)
	VALUES 
	(1, '1971-06-06', 'F', 56.5, 2, 'Y', 'A+', 'Bella_Swan@gmail.com'),
	(2,'1982-01-12', 'M', 70.4, 1, 'Y', 'A-', 'Ed_cull@hotmail.com'),
	(3, '1977-07-12', 'M', 78.8, 0, 'N', 'B-','J_black@aol.com'),
	(4, '1982-10-27', 'M', 64.5, 6, 'Y', 'AB-', 'CharlieS@sfu.ca'),
	(5, '1999-12-25', 'F', 44.3, 9, 'N', 'O+', 'bubblegumAlice@yahoo.com');

INSERT INTO public.recipient(
	rid, name, dob, gender, weight, bloodtype)
	VALUES 
	(1,'Justice Goodwin', '1970-03-09', 'F',  56.3, 'A+'),
	(2, 'Keyon Pollich', '1999-02-07', 'M', 78.7, 'AB-'),
	(3, 'Harvey Walter', '1983-06-26', 'M', 69.3, 'O-'),
	(4, 'Claude Beatty', '1994-05-18', 'F', 87.6, 'B-'),
	(5, 'Halle Mann', '1981-11-07', 'F', 67.8, 'A-');

INSERT INTO public.phlebotomist(
	phlebid, name, instno)
	VALUES 
	(1000, 'Frederick Banting', 1),
	(2000, 'Charles Best', 2),
	(3000, 'Otto Octavius',3),
	(4000, 'Norman Osborn',4),
	(5000, 'Curt Connors',5);


INSERT INTO public.red_blood_cells(
	bloodid, hematocritlevel, hemoglobinlevel)
	VALUES 
	(111, 41.00,13.8),
	(222, 45.00,14.0),
	(333,50.00,14.5),
	(444, 40.00,15.0),
	(555,39.00,18.0);

INSERT INTO public.plasma(
	bloodid, plasmacount)
	VALUES 
	(666,150000),
	(777, 250000),
	(888, 200000),
	(999, 300000),
	(1111, 400000);

INSERT INTO public.platelets(
	bloodid, plateletscount)
	VALUES 
	(1222, 250000),
	(1333, 220000),
	(1444, 350000),
	(1555, 300000),
	(1666, 400000);

INSERT INTO public.conduct_questionnaire(
	vid, donorid)
	VALUES 
	(1,3),
	(2,4),
	(3,1),
	(4,5),
	(5,2);

INSERT INTO public.donate_donor(
	donorid, "time", driveid, instno)
	VALUES 
	(4, '2019-11-22 20:25:16', 1, 1),
	(3, '2017-03-17 07:40:34', 2, 2),
	(5, '2016-08-13 20:57:35', 3, 3),
	(1, '2021-11-06 17:22:11', 4, 4),
	(2, '2019-04-26 05:20:01', 5, 5);

INSERT INTO public.donate_blood(
	bloodid, donorid, "time")
	VALUES 
	(444, 4, '2019-11-22 20:25:16'),
	(333, 3, '2017-03-17 07:40:34'),
	(555, 5, '2016-08-13 20:57:35'),
	(111, 1, '2021-11-06 17:22:11'),
	(222, 2, '2019-04-26 05:20:01');

INSERT INTO public.transporttobloodbank(
	bloodid, driveid, instno, "time")
	VALUES 
	(111, 1, 1, '2019-11-22 21:25:16'),
	(222, 2, 2, '2017-03-17 08:40:34'),
	(333, 3, 3, '2016-08-13 21:57:35'),
	(444, 4, 4, '2021-11-06 18:22:11'),
	(555, 5, 5, '2019-04-26 06:20:01');

INSERT INTO public.transporttohospital(
	bloodid, bankinstno, hospitalinstno, "time")
	VALUES 
	(111, 1, 11, '2019-11-24 21:25:16'),
	(222, 2, 22, '2017-03-17 08:40:34'),
	(333, 3, 33, '2016-08-17 21:57:35'),
	(444, 4, 44, '2021-11-10 18:22:11'),
	(555, 5, 55, '2019-04-30 06:20:01');