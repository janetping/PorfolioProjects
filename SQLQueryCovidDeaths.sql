/*
Covid 19 Data Exploration
Skill used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, 
Creating Views, Converting Data Types
*/

Select *
From PorfolioProject..CovidDeaths
Where continent is not null
order by 3,4


--Select Data that will be using

Select location,date,total_cases,new_cases,total_deaths,population
From PorfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract Covid in a particular country

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PorfolioProject..CovidDeaths
Where location like '%states%'
And continent is not null
order by 1,2


--Total Cases vs Population
Select location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From PorfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

Select location,population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent, population
order by PercentPopulationInfected desc

--Showing countries with highest death rate compared to population

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Breaking things down by continent

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Showing continents with the highest death count
Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PorfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group by date
order by 1,2


--Total Population vs Vaccinations
--USE CTE

with PopvsVac (Continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location
, dea.date) as RollingpeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccinations vac
    On dea.location=vac.location
	 and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
Select*,  (RollingPeopleVaccinated/population)*100
From PopvsVac


--TEMP table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location
, dea.date) as RollingpeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccinations vac
    On dea.location=vac.location
	 and dea.date= vac.date
--where dea.continent is not null
--order by 2,3

Select*, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

--Creating view to store data for later visulizations

Creat View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location
, dea.date) as RollingpeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccinations vac
    On dea.location=vac.location
	 and dea.date= vac.date
where dea.continent is not null

