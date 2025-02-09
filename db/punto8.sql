-- Runtime promedio (averageRuntime).
SELECT 
	ROUND(
		AVG(
			CAST(_embedded -> 'show' ->> 'averageRuntime' AS DECIMAL)
		), 
		1
	)
	 AS averageRuntime
FROM public.series; 

-- Conteo de shows de tv por género.
WITH genres AS (
	SELECT json_array_elements((_embedded -> 'show' -> 'genres')::json)::text genre
	FROM public.series
)
SELECT genre, COUNT(1) num_shows 
FROM genres
GROUP BY genre 
ORDER BY num_shows DESC;

-- Listar los dominios únicos (web) del sitio oficial de los shows.
select 
	DISTINCT REGEXP_REPLACE(REPLACE(official_website, '"', ''), '^(https?://)?(www\.)?([^/]+).*$', '\3') AS domain
from (
	select CAST(_embedded -> 'show' -> 'officialSite' AS VARCHAR) official_website 
	from public.series
	) official_sites;

--Export db
SELECT * FROM public.series