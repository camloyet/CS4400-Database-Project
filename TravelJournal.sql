CREATE TABLE ACCOUNT(
	FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    Username VARCHAR(30) PRIMARY KEY NOT NULL,
    Email VARCHAR(40) UNIQUE NOT NULL,
    UserPassword VARCHAR(20) NOT NULL
);


CREATE TABLE USER(
	Username VARCHAR(30) NOT NULL PRIMARY KEY,
    MembershipDate DATE NOT NULL,
    IsPublic BOOLEAN NOT NULL,
    IsBanned BOOLEAN DEFAULT FALSE,
	FOREIGN KEY (Username) REFERENCES ACCOUNT(Username)
        ON DELETE CASCADE
);

CREATE TABLE ADMIN(
	Username VARCHAR(30) NOT NULL PRIMARY KEY,
    StartDate DATE NOT NULL,
    FOREIGN KEY (Username) REFERENCES ACCOUNT(Username)
		ON DELETE CASCADE
);

CREATE TABLE LOCATION(
	LocationID INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE CITY(
	CityName VARCHAR(20),
    Country VARCHAR(20),
    LocationID INT NOT NULL,
    PRIMARY KEY (CityName, Country),
    FOREIGN KEY (LocationID) REFERENCES LOCATION(LocationID)
);

CREATE TABLE SITE(
	SiteID INT PRIMARY KEY AUTO_INCREMENT,
	SiteName VARCHAR(30) NOT NULL,
    CityName VARCHAR(20) NOT NULL,
    Country VARCHAR(20) NOT NULL,
    LocationID INT NOT NULL,
    FOREIGN KEY (CityName, Country) REFERENCES CITY(CityName, Country),
    UNIQUE (SiteName, CityName, Country),
    FOREIGN KEY (LocationID) REFERENCES LOCATION(LocationID)
);

CREATE TABLE TRIP(
	TripName VARCHAR(30),
    Username VARCHAR(30),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PRIMARY KEY (TripName, Username),
    FOREIGN KEY (Username) REFERENCES USER(Username)
        ON DELETE CASCADE,
    CHECK (StartDate <= EndDate)
);


CREATE TABLE JOURNAL_ENTRY(
	Username VARCHAR(30) NOT NULL,
    EntryDate DATE NOT NULL,
    LocationID INT NOT NULL,
    Note VARCHAR(250),
    Rating INT 
		CHECK (Rating >= 1 AND Rating <= 5),
	PrivacyLevel BOOLEAN,
    EntryID INT AUTO_INCREMENT PRIMARY KEY,
    FOREIGN KEY (Username) REFERENCES USER(Username)
        ON DELETE CASCADE,
    FOREIGN KEY (LocationID) REFERENCES LOCATION(LocationID),
    CHECK (Rating IS NOT NULL OR Note IS NOT NULL),
    UNIQUE (Username, EntryDate, LocationID)
);

-- add assertion to set default if privacy level is null 


CREATE TABLE ENTRY_IN_TRIP(
	Username VARCHAR(30),
    EntryID INT,
    TripName VARCHAR(30),
    PRIMARY KEY (Username, EntryID, TripName),
    FOREIGN KEY (TripName, Username) REFERENCES TRIP(TripName, Username)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (EntryID) REFERENCES JOURNAL_ENTRY(EntryID)
        ON DELETE CASCADE
);

CREATE TABLE REASON(
    Reason VARCHAR(50),
    PRIMARY KEY(Reason)
);

CREATE TABLE USER_FLAGS(
    Username VARCHAR(30) NOT NULL,
    EntryID INT NOT NULL,
    FlagID INT AUTO_INCREMENT NOT NULL,
    PRIMARY KEY(FlagID),
	FOREIGN KEY (Username) REFERENCES USER(Username)
        ON DELETE CASCADE,
    FOREIGN KEY (EntryID) REFERENCES JOURNAL_ENTRY(EntryID)
        ON DELETE CASCADE
);

CREATE TABLE FLAG_REASON(
    FlagID INT NOT NULL,
    Reason VARCHAR(50) NOT NULL,
    PRIMARY KEY(FlagID, Reason),
    FOREIGN KEY (Reason) REFERENCES REASON(Reason),
    FOREIGN KEY (FlagID) REFERENCES USER_FLAGS(FlagID)
        ON DELETE CASCADE
);

CREATE TABLE CATEGORY(
    Category VARCHAR(50),
    PRIMARY KEY(Category)
);

CREATE TABLE SITE_CATEGORIES(
    SiteID INT,
    Category VARCHAR(50),
    PRIMARY KEY(SiteID, Category),
    FOREIGN KEY (Category) REFERENCES CATEGORY(Category)
        ON DELETE CASCADE,
    FOREIGN KEY (SiteID) REFERENCES SITE(SiteID)
);