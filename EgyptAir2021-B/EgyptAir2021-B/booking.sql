CREATE TABLE [dbo].[Flight] (
    [FlightNo]   NCHAR (5)     NOT NULL,
    [FlightDate] DATE          NOT NULL,
    [Dairport]   NVARCHAR (20) NOT NULL,
    [Dtime]      NCHAR (5)     NOT NULL,
    [Aairport]   NVARCHAR (20) NOT NULL,
    [Atime]      NCHAR (5)     NOT NULL,
    [Seats]      INT           NOT NULL,
    CONSTRAINT [PK_Flight] PRIMARY KEY CLUSTERED ([FlightNo] ASC, [FlightDate] ASC)
);

CREATE TABLE [dbo].[Booking] (
    [RefNo]         INT           NOT NULL,
    [Username]      NVARCHAR (20) NOT NULL,
    [FlightNo]      NCHAR (5)     NOT NULL,
    [FlightDate]    DATE          NOT NULL,
    [PassengerName] NVARCHAR (30) NULL,
    [SeatNo]        NCHAR (3)     NULL,
    CONSTRAINT [PK_Booking] PRIMARY KEY CLUSTERED ([RefNo] ASC),
    CONSTRAINT [FK_Booking_Member1] FOREIGN KEY ([Username]) REFERENCES [dbo].[Member] ([Username]),
    CONSTRAINT [FK_Booking_Flight1] FOREIGN KEY ([FlightNo], [FlightDate]) REFERENCES [dbo].[Flight] ([FlightNo], [FlightDate])
);

CREATE TABLE [dbo].[FlightSeats] (
    [FlightNo]      NCHAR (5)     NOT NULL,
    [FlightDate]    DATE          NOT NULL,
    [seatType]      NVARCHAR (10) NOT NULL,
    [seatNo]        NCHAR (3)     NOT NULL,
    [PassengerName] NVARCHAR (30) NULL,
    CONSTRAINT [PK_FlightSeats] PRIMARY KEY CLUSTERED ([FlightNo] ASC, [FlightDate] ASC, [seatType] ASC, [seatNo] ASC),
    CONSTRAINT [FK_FlightSeats_Flight] FOREIGN KEY ([FlightNo], [FlightDate]) REFERENCES [dbo].[Flight] ([FlightNo], [FlightDate])
);
