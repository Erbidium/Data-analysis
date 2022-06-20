SELECT * FROM moviesAnalysisWithAge

SELECT DISTINCT moviesAnalysisWithAge.id, temp.title, temp.budget
FROM (
SELECT id, title, budget
FROM (SELECT id, title, budget, ROW_NUMBER() OVER (PARTITION BY id ORDER BY budget DESC) AS RowNumber FROM movies) tb
WHERE tb.RowNumber = 1
) temp
INNER JOIN moviesAnalysisWithAge ON temp.title = moviesAnalysisWithAge.Name
WHERE moviesAnalysisWithAge.Budget IS NULL AND temp.budget != '0.0'

