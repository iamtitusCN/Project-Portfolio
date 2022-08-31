/*
The dataset used for this analysis was gotten from OurWorldInData/Covid website and Exploratory Data Analysis was ran on it.
The following Functions/Skills were used on this dataset to achieve the purpose of this analysis: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
The RDBM that was used is Mysql Workbench
*/


create database covid;
use covid;

-- This syntax shows the first 100 rows in the dataset 
select * from CovidDeaths limit 100;


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2
limit 100;


-- Total Cases vs Total Deaths(Shows likelihood of dying if you contract covid in your country)

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From CovidDeaths
Where location like '%africa%'
and continent is not null 
order by 1,2;

-- This syntax shows the total number of cases, deaths and percentages per death based off a particular location
select location, max(total_cases) Max_cases, max(total_deaths) Max_deaths, max((total_deaths/total_cases)*100) Max_per
from CovidDeaths 
where location = 'africa' 
group by Location;


-- This syntax shows the total number of cases, deaths and percentages based off a particular continent
select continent, max(total_cases) Max_cases, max(total_deaths) Max_deaths, max((total_deaths/total_cases)*100) Max_per
from CovidDeaths 
where continent = 'africa' 
group by continent;


-- This syntax shows the total number of cases and deaths based off a particular location
select location, max(total_cases) Max_cases, max(total_deaths) Max_deaths, max((total_deaths/total_cases)*100) Max_per 
from CovidDeaths 
where continent = 'africa' 
group by Location;

-- The syntax shows the max total_cases, max total_death and percentage for a specific location(Nigeria) 
select location, max(total_cases) Max_Tot_cases, max(total_deaths) Max_Tot_deaths, max((total_deaths/total_cases)*100) Percentage_Of_Deaths 
from CovidDeaths 
where location = 'Nigeria';


-- This syntax shows the number of people who had been vaccinated based on a specific location(Nigeria)
Select dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccins vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.location = 'Nigeria'
order by 2,3
limit 100;


-- Total Cases vs Population(Shows the percentage of population infected with Covid based on a specific location(Africa))

select location, count(*)No_Of_Times_App, max(total_cases) Max_Tot_Cases, population, max(total_cases/population)*100 Percentage_Infected 
from CovidDeaths 
where continent = 'africa' 
group by location, population
order by 1;


-- Showing Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc;


-- Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as signed)) as TotalDeathCount
From CovidDeaths
-- where continent is not null
Group by Location
having MAX(cast(Total_deaths as unsigned))  < 2500000
order by TotalDeathCount desc;



-- BREAKING THINGS DOWN BY CONTINENT(Showing contintents with the highest death count per population)


Select continent, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
From CovidDeaths
where continent is not null
Group by continent
having MAX(cast(Total_deaths as unsigned))  < 2500000
order by TotalDeathCount desc;



-- GLOBAL NUMBERS (This shows the sum total of cases, deaths and the % of both all over the world)

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as unsigned)) as total_deaths, SUM(cast(new_deaths as unsigned))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2;





-- Total Population vs Vaccinations(Shows Percentage of Population that has recieved at least one Covid Vaccine)


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccins vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
limit 100;


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccins vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert ignore PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccins vac
	On dea.location = vac.location
	and dea.date = vac.date;
    
Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated;




-- Creating View to store data for later visualizations

Create View PercentPopVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccins vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

