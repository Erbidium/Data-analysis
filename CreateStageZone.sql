use MoviesDB

/*==============================================================*/
/* Table: imdbStage */
/*==============================================================*/
create table imdbStage(
	Name nvarchar(150),
	Date nvarchar(50),
	Rate nvarchar(50),
	Votes nvarchar(50),
	Genre nvarchar(50),
	Duration nvarchar(50),
	Type nvarchar(50),
	Certificate nvarchar(50),
	Episodes nvarchar(50),
	Nudity nvarchar(50),
	Violence nvarchar(50),
	Profanity nvarchar(50),
	Alcohol nvarchar(50),
	Frightening nvarchar(50)
)
go

/*==============================================================*/
/* Table: moviesStage */
/*==============================================================*/
create table moviesStage(
	name nvarchar(150),
	rating nvarchar(50),
	genre nvarchar(50),
	year int,
	released nvarchar(50),
	score nvarchar(50),
	votes nvarchar(50),
	director nvarchar(50),
	writer nvarchar(50),
	star nvarchar(50),
	country nvarchar(50),
	budget nvarchar(50),
	gross nvarchar(50),
	company nvarchar(100),
	runtime nvarchar(50)
)
go

/*==============================================================*/
/* Table: theOscarAwardStage */
/*==============================================================*/
create table theOscarAwardStage(
	year_film int,
	year_ceremony int,
	ceremony int,
	category nvarchar(150),
	name nvarchar(300),
	film nvarchar(150),
	winner nvarchar(150)
)
go

drop table imdbStage
go

drop table moviesStage
go

drop table theOscarAwardStage
go
