CREATE VIEW moviesAnalysis AS
SELECT FactTable.id, Name, Genres, RatingName, Year, Month, OscarWinSum, NominatedNumber, Gross, Budget, DurationMinutes, VotesNumber, FactTable.ImbdScore
FROM FactTable
INNER JOIN NameDimension ON FactTable.NameId = NameDimension.NameId
INNER JOIN ( SELECT STRING_AGG(GenreDimension.GenreName, '-') as Genres, FactTable.id
			 FROM FactTable
			 INNER JOIN GenreMovie ON FactTable.id = GenreMovie.FactId
			 INNER JOIN GenreDimension ON GenreDimension.GenreId = GenreMovie.GenreId
			 GROUP BY FactTable.id) genres 
ON genres.id = FactTable.id
LEFT JOIN RatingAgeDimension ON FactTable.RatingId = RatingAgeDimension.RatingId
LEFT JOIN YearDimension ON FactTable.YearId = YearDimension.YearId
LEFT JOIN MonthDimension ON FactTable.MonthId = MonthDimension.MonthId
INNER JOIN (
	SELECT oscars.id, ISNULL(oscars.WinSum, 0) as OscarWinSum
	FROM (
	SELECT FactTable.id, SUM(CONVERT(INT, isWinner)) as WinSum
	FROM FactTable
	LEFT JOIN OscarMovie ON FactTable.id = OscarMovie.FactId
	LEFT JOIN OscarDimension ON OscarMovie.OscarId = OscarDimension.OscarId
	GROUP BY id
	) oscars
) oscarTable ON oscarTable.id = FactTable.id
INNER JOIN (
	SELECT oscars.id, ISNULL(oscars.OscarCount, 0) as NominatedNumber
	FROM (
	SELECT FactTable.id, COUNT(OscarDimension.OscarId) as OscarCount
	FROM FactTable
	LEFT JOIN OscarMovie ON FactTable.id = OscarMovie.FactId
	LEFT JOIN OscarDimension ON OscarMovie.OscarId = OscarDimension.OscarId
	GROUP BY id
	) oscars
) nominationsTable ON nominationsTable.id = FactTable.id;


CREATE VIEW moviesAnalysisWithAge AS
ALTER VIEW moviesAnalysisWithAge AS
SELECT *
FROM moviesAnalysis
WHERE RatingName != 'Not Rated' AND RatingName != 'Unrated' AND RatingName IS NOT NULL