use MoviesDB

with tempNames(name)
as
(
	select tb.name
	from (select name from moviesStage union
	select Name from imdbStage where Type = 'Film' union
	select distinct film from theOscarAwardStage where category !='ACTOR' and category !='ACTRESS' and category !='MAKEUP') tb
	where tb.name !=''
)
insert into NameDimension 
select name
from tempNames

select * from NameDimension


with tempCountries(country)
as
(
	select distinct country from moviesStage
)
insert into CountryDimension
select country
from tempCountries

select * from CountryDimension


with tempCompanies(company)
as
(
	select distinct company from moviesStage
)
insert into CompanyDimension
select company
from tempCompanies

select * from CompanyDimension


insert into YearDimension
select distinct year_film
from theOscarAwardStage
union
select distinct Date
from imdbStage
union
select distinct year
from moviesStage

select * from YearDimension


insert into MonthDimension
select distinct left(released, charindex(' ', released) - 1)
from moviesStage
where released != '' and isnumeric(left(released, charindex(' ', released) - 1)) = 0

select * from MonthDimension

insert into DirectorDimension
select distinct left(trim(director), charindex(' ', trim(director)) - 1) Name, right(trim(director), len(trim(director)) - charindex(' ', trim(director))) Surname
from moviesStage
where director != '' and charindex(' ', trim(director)) != 0
union
select distinct director, null
from moviesStage
where director != '' and charindex(' ', trim(director)) = 0

select * from DirectorDimension

insert into StarDimension
select distinct left(trim(star), charindex(' ', trim(star)) - 1) Name, right(trim(star), len(trim(star)) - charindex(' ', trim(star))) Surname
from moviesStage
where star != '' and charindex(' ', trim(star)) != 0
union
select distinct star, null
from moviesStage
where star != '' and charindex(' ', trim(star)) = 0

select * from StarDimension

insert into RatingAgeDimension
select distinct Certificate
from imdbStage
where Certificate != '' and Certificate != 'None'
union
select distinct rating
from moviesStage
where rating != '' and rating != 'None'

select *
from RatingAgeDimension

insert into GenreDimension
select distinct genre
from moviesStage
union
select distinct Genre
from imdbStage
where charindex(',', Genre) = 0
union
select distinct left(Genre, charindex(',', Genre) - 1)
from imdbStage
where charindex(',', Genre) != 0

select * from GenreDimension

with tb
as
(
select distinct dbo.getName(MovieName, imdbFilmName) NewName, company NewCompany, DirectorId, dbo.getMonth(released) NewMonth, dbo.getYear( cast(Date as int), year) NewYear, StarId, CountryId, MovieGenre, dbo.getScore(score, Rate) imdbScore, country NewCountry, dbo.getVotesNumber(Votes, MovieVotes) * 1000 as VotesNumber, dbo.getDurationMinutes(runtime, Duration) DurationMinutes, budget Budget, gross Gross, Rate, Genre, Certificate, rating
from (select distinct name as MovieName, rating, genre as MovieGenre, year, released, score, votes as MovieVotes, director, star, country, budget, gross, company, runtime from moviesStage) tb1
full join (select distinct Name as imdbFilmName, Date, Rate, Votes, Genre, Duration, Certificate from imdbStage where Type = 'Film') tb2
on tb1.MovieName = tb2.imdbFilmName
left join StarDimension on StarDimension.Name + ' ' + StarDimension.Surname = star
left join CountryDimension on country = CountryDimension.CountryName
left join DirectorDimension on director = DirectorDimension.Name + ' ' + DirectorDimension.Surname
),
tbRes as 
(select distinct NameId, CompanyId, DirectorId, MonthId, YearId, StarId, CountryId as CountryNameId, null GenreId, null RatingId, imdbScore, VotesNumber, DurationMinutes, null HasOscar, Budget, Gross   from tb
left join NameDimension on NameDimension.Name = NewName
left join CompanyDimension on CompanyDimension.CompanyName = NewCompany
left join MonthDimension on MonthDimension.Month = NewMonth
left join YearDimension on YearDimension.Year = NewYear
)
insert into FactTable select * from tbRes

select * from FactTable

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
end

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
end

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
end

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
end

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
end

create function getCertificate(@cert1 nvarchar(50), @cert2 nvarchar(50))
returns float 
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
end