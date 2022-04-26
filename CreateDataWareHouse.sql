use MoviesDB

/*==============================================================*/
/* Table: CompanyDimension */
/*==============================================================*/
create table CompanyDimension(
	CompanyId int identity(1, 1) primary key,
	CompanyName nvarchar(100)
)
go

/*==============================================================*/
/* Table: DirectorDimension */
/*==============================================================*/
create table DirectorDimension(
	DirectorId int identity(1, 1) primary key,
	Name nvarchar(50),
	Surname nvarchar(50)
)
go

/*==============================================================*/
/* Table: StarDimension */
/*==============================================================*/
create table StarDimension(
	StarId int identity(1, 1) primary key,
	Name nvarchar(50),
	Surname nvarchar(50)
)
go

/*==============================================================*/
/* Table: RatingAgeDimension */
/*==============================================================*/
create table RatingAgeDimension(
	RatingId int identity(1, 1) primary key,
	RatingName nvarchar(50)
)
go

/*==============================================================*/
/* Table: YearDimension */
/*==============================================================*/
create table YearDimension(
	YearId int identity(1, 1) primary key,
	Year int,
)
go

/*==============================================================*/
/* Table: MonthDimension */
/*==============================================================*/
create table MonthDimension(
	MonthId int identity(1, 1) primary key,
	Month nvarchar(50),
)
go

/*==============================================================*/
/* Table: CountryDimension */
/*==============================================================*/
create table CountryDimension(
	CountryId int identity(1, 1) primary key,
	CountryName nvarchar(50)
)
go

/*==============================================================*/
/* Table: NameDimension */
/*==============================================================*/
create table NameDimension(
	NameId int identity(1, 1) primary key,
	Name nvarchar(150)
)
go

/*==============================================================*/
/* Table: GenreDimension */
/*==============================================================*/
create table GenreDimension(
	GenreId int identity(1, 1) primary key,
	GenreName nvarchar(50)
)
go

/*==============================================================*/
/* Table: OscarDimension */
/*==============================================================*/
create table OscarDimension(
	OscarId int identity(1, 1) primary key,
	CeremonyYear int,
	Category nvarchar(150),
	isWinner bit,
	name nvarchar(300)
)

/*==============================================================*/
/* Table: FactTable */
/*==============================================================*/
create table FactTable(
	id int identity(1,1) primary key,
	NameId int foreign key references NameDimension(NameId),
	MonthId int foreign key references MonthDimension(MonthId),
	YearId int foreign key references YearDimension(YearId),
	RatingId int foreign key references RatingAgeDimension(RatingId),
	ImbdScore float,
	VotesNumber int,
	DurationMinutes float,
	Budget float,
	Gross float
)
go

/*==============================================================*/
/* Table: OscarMovie */
/*==============================================================*/
create table OscarMovie(
	OscarId int foreign key references OscarDimension(OscarId),
	FactId int foreign key references FactTable(id)
)
go

/*==============================================================*/
/* Table: CompanyMovie */
/*==============================================================*/
create table CompanyMovie(
	CompanyId int foreign key references CompanyDimension(CompanyId),
	FactId int foreign key references FactTable(id)
)
go

/*==============================================================*/
/* Table: DirectorMovie */
/*==============================================================*/
create table DirectorMovie(
	DirectorId int foreign key references DirectorDimension(DirectorId),
	FactId int foreign key references FactTable(id)
)
go

/*==============================================================*/
/* Table: StarMovie */
/*==============================================================*/
create table StarMovie(
	StarId int foreign key references StarDimension(StarId),
	FactId int foreign key references FactTable(id)
)
go

/*==============================================================*/
/* Table: CountryMovie */
/*==============================================================*/
create table CountryMovie(
	CountryId int foreign key references CountryDimension(CountryId),
	FactId int foreign key references FactTable(id)
)
go

/*==============================================================*/
/* Table: GenreMovie */
/*==============================================================*/
create table GenreMovie(
	GenreId int foreign key references GenreDimension(GenreId),
	FactId int foreign key references FactTable(id)
)
go

drop table CompanyMovie

drop table DirectorMovie

drop table CountryMovie

drop table StarMovie

drop table GenreMovie

drop table OscarMovie

drop table FactTable

drop table CompanyDimension

drop table CountryDimension

drop table DirectorDimension

drop table GenreDimension

drop table MonthDimension

drop table NameDimension

drop table OscarDimension

drop table RatingAgeDimension

drop table StarDimension

drop table YearDimension