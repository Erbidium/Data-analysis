use MoviesDB

create table CompanyDimension(
	CompanyId int identity(1, 1) primary key,
	CompanyName nvarchar(100)
)
go

create table CompanyFact(
	CompanyId int foreign key references CompanyDimension(CompanyId),
	FactId int foreign key references FactTable(id)
)
go

create table DirectorDimension(
	DirectorId int identity(1, 1) primary key,
	Name nvarchar(50),
	Surname nvarchar(50)
)
go

create table DirectorFact(
	DirectorId int foreign key references DirectorDimension(DirectorId),
	FactId int foreign key references FactTable(id)
)
go

create table StarDimension(
	StarId int identity(1, 1) primary key,
	Name nvarchar(50),
	Surname nvarchar(50)
)
go

create table StarFact(
	StarId int foreign key references StarDimension(StarId),
	FactId int foreign key references FactTable(id)
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

create table CountryFact(
	CountryId int foreign key references CountryDimension(CountryId),
	FactId int foreign key references FactTable(id)
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

create table GenreFact(
	GenreId int foreign key references GenreDimension(GenreId),
	FactId int foreign key references FactTable(id)
)
go

create table OscarDimension(
	OscarId int identity(1, 1) primary key,
	CeremonyYear int,
	Category nvarchar(50),
	isWinner bit,
	name nvarchar(50)
)

create table FactTable(
	id int identity(1,1) primary key,
	NameId int foreign key references NameDimension(NameId),
	MonthId int foreign key references MonthDimension(MonthId),
	YearId int foreign key references YearDimension(YearId),
	RatingId int foreign key references RatingAgeDimension(RatingId),
	OscarId int foreign key references OscarDimension(OscarId),
	ImbdScore float,
	VotesNumber int,
	DurationMinutes float,
	HasOscar bit,
	Budget float,
	Gross float
)
go

drop table MonthDimension

drop table DirectorDimension

drop table RatingAgeDimension

drop table CompanyFact

drop table DirectorFact

drop table CountryFact

drop table StarFact

drop table GenreFact

drop table FactTable