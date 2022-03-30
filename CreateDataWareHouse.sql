use MoviesDB

create table CompanyDimension(
	CompanyId int identity(1, 1) primary key,
	CompanyName nvarchar(100)
)
go

create table DirectorDimension(
	DirectorId int identity(1, 1) primary key,
	Name nvarchar(50),
	Surname nvarchar(50)
)
go

create table StarDimension(
	StarId int identity(1, 1) primary key,
	Name nvarchar(50),
	Surname nvarchar(50)
)
go

create table RatingAgeDimension(
	RatingId int identity(1, 1) primary key,
	RatingName nvarchar(50)
)
go

create table YearDimension(
	YearId int identity(1, 1) primary key,
	Year int,
)
go

create table MonthDimension(
	MonthId int identity(1, 1) primary key,
	Month nvarchar(50),
)
go

create table CountryDimension(
	CountryId int identity(1, 1) primary key,
	CountryName nvarchar(50)
)
go

create table NameDimension(
	NameId int identity(1, 1) primary key,
	Name nvarchar(150)
)
go

create table GenreDimension(
	GenreId int identity(1, 1) primary key,
	GenreName nvarchar(50)
)
go

create table FactTable(
	id int identity(1,1) primary key,
	NameId int foreign key references NameDimension(NameId),
	CompanyId int foreign key references CompanyDimension(Companyid),
	DirectorId int foreign key references DirectorDimension(DirectorId),
	MonthId int foreign key references MonthDimension(MonthId),
	YearId int foreign key references YearDimension(YearId),
	StarId int foreign key references StarDimension(StarId),
	CountryNameId int foreign key references CountryDimension(CountryId),
	GenreId int foreign key references GenreDimension(GenreId),
	RatingId int foreign key references RatingAgeDimension(RatingId),
	ImbdScore float,
	VotesNumber int,
	DurationMinutes float,
	HasOscar bit,
	Budget float,
	Gross float
)
go

drop table MonthDimension

drop table FactTable

drop table DirectorDimension

drop table RatingAgeDimension