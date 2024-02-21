
--SQL DATA EXPLORATION PROJECT COVID

SELECT *
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data]
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data]
ORDER BY 1

--Looking at death percentage which is total deaths by total cases

SELECT location, date, total_cases, total_deaths, 
CASE WHEN total_cases > 0 THEN (cast(total_deaths AS float)/cast(total_cases AS float))*100
ELSE 0
END as DeathPercentage
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data]
ORDER BY 1

--Looking at Total cases vs Population which shows how much population got covid

SELECT location, date, total_cases, population, 
CASE WHEN total_cases > 0 THEN (cast(total_cases AS float)/cast(population AS float))*100
ELSE 0
END as CovidPopulationPercentage
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data]
ORDER BY 1

--Looking at Countries with highest infection rate compared to the Population.

SELECT location, population, MAX(total_cases), 
CASE WHEN total_cases > 0 THEN MAX(cast(total_cases AS float)/cast(population AS float))*100
ELSE 0
END as CovidPopulationPercentage
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data]
GROUP BY location, population, total_cases

--Showing continent with highest death count

SELECT continent, MAX(cast (total_deaths as int))as MaxTotalDeaths
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data]
WHERE continent is not null 
GROUP BY continent

--(you need to cast it as int or else you'll get wrong numbers)

--Looking at TOTAL POPULATION VS TOTAL VACCINATIONS

SELECT CVDEATHS.continent, CVDEATHS.location, CVDEATHS.date, CVDEATHS.population, CVACCS.total_vaccinations
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data] CVDEATHS
JOIN PortfolioProjectDatabase.dbo.[Covid Vaccinations Data] CVACCS
ON CVDEATHS.location = CVACCS.location
AND CVDEATHS.date = CVACCS.date
WHERE CVDEATHS.continent is not null
ORDER BY location, date asc

--Percent of population vaccinated

SELECT location, date, totaL_vaccinations, population, 
CASE WHEN total_vaccinations > 0 THEN (cast(total_vaccinations AS float)/cast(population AS float))*100
ELSE 0
END as VaccinatedPopulationPercentage
FROM PortfolioProjectDatabase.dbo.[Covid Vaccinations Data]
ORDER BY 1

--TEMP TABLE
DROP TABLE IF EXISTS #VaccinationVsPopulation
CREATE TABLE #VaccinationVsPopulation
(continent varchar(255),
location nvarchar(255),
date nvarchar(255),
population nvarchar(255),
total_vaccinations nvarchar(255)
)

INSERT INTO #VaccinationVsPopulation
SELECT CVDEATHS.continent, CVDEATHS.location, CVDEATHS.date, CVDEATHS.population, CVACCS.total_vaccinations
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data] CVDEATHS
JOIN PortfolioProjectDatabase.dbo.[Covid Vaccinations Data] CVACCS
ON CVDEATHS.location = CVACCS.location
AND CVDEATHS.date = CVACCS.date
WHERE CVDEATHS.continent is not null
ORDER BY location, date asc

SELECT *
FROM #VaccinationVsPopulation

--CREATING A VIEW FOR TABLEAU VISUALIZATION LATER

CREATE VIEW TotalPopulationVaccinated as
SELECT CVDEATHS.continent, CVDEATHS.location, CVDEATHS.date, CVDEATHS.population, CVACCS.total_vaccinations
FROM PortfolioProjectDatabase.dbo.[Covid Deaths Data] CVDEATHS
JOIN PortfolioProjectDatabase.dbo.[Covid Vaccinations Data] CVACCS
ON CVDEATHS.location = CVACCS.location
AND CVDEATHS.date = CVACCS.date
WHERE CVDEATHS.continent is not null
--WE CUT ORDER BY BECAUSE IN VIEWS IT IS INVALID 































