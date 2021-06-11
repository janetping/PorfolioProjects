
--1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as 
  DeathPercentage
From PorfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group by date
order by 1,2


--2.

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3.

Select location,population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject..CovidDeaths
--Where location like '%states%'
--Where continent is not null
Group by location, population
order by PercentPopulationInfected desc

--4. 
Select location,population,date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject..CovidDeaths
--Where location like '%states%'
--Where continent is not null
Group by location, population, date
order by PercentPopulationInfected desc