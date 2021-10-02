
CREATE TABLE [dbo].[FlightSeats] (
    [FlightNo]      NCHAR (5)     NOT NULL,
    [FlightDate]    DATE          NOT NULL,
    [seatType]      NVARCHAR (10) NOT NULL,
    [seatNo]        NCHAR (3)     NOT NULL,
    [PassengerName] NVARCHAR (30) NULL,
    CONSTRAINT [PK_FlightSeats] PRIMARY KEY CLUSTERED ([FlightNo] ASC, [FlightDate] ASC, [seatType] ASC, [seatNo] ASC),
    CONSTRAINT [FK_FlightSeats_Flight] FOREIGN KEY ([FlightNo], [FlightDate]) REFERENCES [dbo].[Flight] ([FlightNo], [FlightDate])
);


INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'C01', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'C02', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'C03', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'C04', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'C05', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'D06', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'D07', null);

INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'D01', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'D02', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'D03', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Aisle', 'D04', null);

INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Window', 'A01', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Window', 'A02', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Window', 'A03', null);

INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Middle', 'F01', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Middle', 'F02', null);
INSERT INTO FlightSeats VALUES('MS101', '7/20/2021', 'Middle', 'F03', null);

