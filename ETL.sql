use MoviesDB

with tempNames(name)
as
(
	select tb.name
	from (select name from moviesStage 
	      union
	      select Name from imdbStage where Type = 'Film') tb
	where tb.name !=''
)
insert into NameDimension 
select name
from tempNames;

select * from NameDimension;

with tempCountries(country)
as
(
	select distinct country from moviesStage
)
insert into CountryDimension
select country
from tempCountries;

select * from CountryDimension;


with tempCompanies(company)
as
(
	select distinct company from moviesStage
)
insert into CompanyDimension
select company
from tempCompanies;

select * from CompanyDimension;


insert into YearDimension
select distinct year_film
from theOscarAwardStage
union
select distinct Date
from imdbStage
union
select distinct year
from moviesStage;

select * from YearDimension;


insert into MonthDimension
select distinct left(released, charindex(' ', released) - 1)
from moviesStage
where released != '' and isnumeric(left(released, charindex(' ', released) - 1)) = 0;

select * from MonthDimension;

insert into DirectorDimension
select distinct left(trim(director), charindex(' ', trim(director)) - 1) Name, right(trim(director), len(trim(director)) - charindex(' ', trim(director))) Surname
from moviesStage
where director != '' and charindex(' ', trim(director)) != 0
union
select distinct director, null
from moviesStage
where director != '' and charindex(' ', trim(director)) = 0;

select * from DirectorDimension;

insert into StarDimension
select distinct left(trim(star), charindex(' ', trim(star)) - 1) Name, right(trim(star), len(trim(star)) - charindex(' ', trim(star))) Surname
from moviesStage
where star != '' and charindex(' ', trim(star)) != 0
union
select distinct star, null
from moviesStage
where star != '' and charindex(' ', trim(star)) = 0;

select * from StarDimension;

insert into RatingAgeDimension
select distinct Certificate
from imdbStage
where Certificate != '' and Certificate != 'None'
union
select distinct rating
from moviesStage
where rating != '' and rating != 'None';

select *
from RatingAgeDimension;


insert into GenreDimension
select distinct genre
from moviesStage
union
select distinct genre
from getImdbGenres();


create function getImdbGenres()
returns @imdbGenresTable table(genre nvarchar(100))
as
begin

	declare @imdbGenresForMovie nvarchar(200);

	declare imdbGenresCursor cursor
		for select Genre from imdbStage;
	open imdbGenresCursor;

	fetch next from imdbGenresCursor
	into @imdbGenresForMovie;

	while @@FETCH_STATUS = 0
	begin
		with tempGenres(genre) 
		as
		(
			select * from string_split(@imdbGenresForMovie, ',')
		)
		insert @imdbGenresTable
		select trim(genre) from tempGenres;

		fetch next from imdbGenresCursor
		into @imdbGenresForMovie;
	end

	close imdbGenresCursor;
	deallocate imdbGenresCursor;
	return;
end;

select distinct *
from getImdbGenres();

select * from GenreDimension;


select * from theOscarAwardStage;

insert into OscarDimension
select year_ceremony CeremonyYear, category Category, winner isWinner, name
from theOscarAwardStage;

select * from OscarDimension;

select * from NameDimension

with tb
as
(
select distinct dbo.getName(MovieName, imdbFilmName) NewName, 
dbo.getMonth(released) NewMonth, 
				dbo.getYear( cast(Date as int), year) NewYear,
				dbo.getScore(score, Rate) imdbScore,
				dbo.getVotesNumber(Votes, MovieVotes) * 1000 as VotesNumber, 
				dbo.getDurationMinutes(runtime, Duration) DurationMinutes, 
				budget Budget, 
				gross Gross, 
				Rate, 
				dbo.getCertificate(Certificate, rating) AgeCertificate
from (select distinct name as MovieName, 
                      rating, 
					  year, 
					  released, 
					  score, 
					  votes as MovieVotes,  
					  budget, 
					  gross,
					  runtime 
      from moviesStage) tb1
full join (select distinct Name as imdbFilmName, 
                           Date, 
						   Rate, 
						   Votes,
						   Duration, 
						   Certificate 
		   from imdbStage where Type = 'Film') tb2
on tb1.MovieName = tb2.imdbFilmName
),
tbRes as 
(select distinct NameId, 
				 MonthId, 
				 YearId,
				 RatingId, 
				 imdbScore, 
				 VotesNumber, 
				 DurationMinutes, 
				 Budget, 
				 Gross
from tb
left join NameDimension on NameDimension.Name = NewName
left join MonthDimension on MonthDimension.Month = NewMonth
left join YearDimension on YearDimension.Year = NewYear
left join RatingAgeDimension ON RatingAgeDimension.RatingName = AgeCertificate
)
insert into FactTable select * from tbRes;

select * from FactTable;


insert into StarMovie
select StarDimension.StarId StarId, FactTable.id FactId
from FactTable
INNER JOIN NameDimension on NameDimension.NameId = FactTable.NameId
INNER JOIN moviesStage ON NameDimension.Name = moviesStage.name
INNER JOIN StarDimension on StarDimension.Name + ' ' + StarDimension.Surname = moviesStage.star
UNION
select st2.StarId StarId, FactTable.id FactId
from FactTable
INNER JOIN NameDimension on NameDimension.NameId = FactTable.NameId
INNER JOIN moviesStage ON NameDimension.Name = moviesStage.name
INNER JOIN StarDimension st2 on st2.Name = moviesStage.star;

select * from StarMovie;

create function getName(@Name1 nvarchar(200), @Name2 nvarchar(200))
returns nvarchar(200)
as
begin
	if(@Name1 = @Name2)
		return @Name1
	else
	begin
		if(@Name1 is null)
			return @Name2			
	end
	return @Name1
end;

create function getYear(@year1 int, @year2 int)
returns int
as
begin
	if(@year1 = @year2)
		return @year1
	else
	begin
		if(@year1 is null)
			return @year2			
	end
	return @year1
end;

create function getMonth(@released nvarchar(50))
returns nvarchar(50)
as
begin
	if(@released = '' or isnumeric(left(@released, charindex(' ', @released) - 1)) = 1)
		return null
	return left(@released, charindex(' ', @released) - 1)
end

create function getVotesNumber(@votes1 nvarchar(50), @votes2 nvarchar(50))
returns float 
as
begin
	if(@votes1 = @votes2)
		return try_convert(float, replace(@votes1, ',', '.'))
	else
	begin
		if(@votes1 is null)
			return try_convert(float, replace(@votes2, ',', '.'))		
	end
	return try_convert(float, replace(@votes1, ',', '.'))	
end;

create function getScore(@score1 nvarchar(50), @score2 nvarchar(50))
returns float 
as
begin
	if(@score1 = @score2)
		return try_convert(float, @score1)
	else
	begin
		if(@score1 is null)
			return try_convert(float, @score2)		
	end
	return try_convert(float, @score1)	
end;

create function getDurationMinutes(@duration1 nvarchar(50), @duration2 nvarchar(50))
returns float 
as
begin
	if(@duration1 = @duration2)
		return try_convert(float, @duration1)
	else
	begin
		if(@duration1 is null)
			return try_convert(float, @duration2)		
	end
	return try_convert(float, @duration1)	
end;

create function getCertificate(@cert1 nvarchar(50), @cert2 nvarchar(50))
returns nvarchar(50) 
as
begin
	if(@cert1 = @cert2)
		return @cert1
	else
	begin
		if(@cert1 is null)
			return @cert2	
	end
	return @cert1
end;