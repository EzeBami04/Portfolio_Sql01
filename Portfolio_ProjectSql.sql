
Select*
From Project_Portfolio..Covid_death 
Where continent is not null
Order by 3,4

Select*
From Project_Portfolio..CovidVaccinationI

Select Location, date, total_cases, new_cases,total_deaths, population
From Project_portfolio..Covid_death
Where location like '%Nigeria%'
Order by 1,2


-- Looking at Total Cases vs Population
-- Shows total number of population got Covid

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentofPopulationInfected
From Project_portfolio..Covid_death
Where location like '%States%'
Order by 1,2

-- Looking at Countries with highest inspection rate compared to its population 

Select Location, population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as
PercentofPopulationInfected
From Project_portfolio..Covid_death
--Where location like '%States%'
Where Continent is not null
Group by location, population
Order by PercentofPopulationInfected Desc

-- Looking at total cases vs Total deaths 
-- Shows the likelihood of dying if you contract Covid

Select Location, Population, (convert int, total_deaths))/total_cases)*100 as DeathPercentage
From Project_portfolio..Covid_death
--Where location like '%States%'
Where continent is not null
Order by 1,2

-- Showing the Countries with the highest death

Select Location, Max(cast (total_deaths as int)) as TotalDeathCount
From Project_portfolio..Covid_death
Where continent is not null
Group by location
Order by TotalDeathCount Desc

-- Analysis of total death in Countries

Select continent, Max(cast (total_deaths as int)) as TotalDeathCount
From Project_portfolio..Covid_death
Where continent is not null
Group by continent
Order by TotalDeathCount Desc

-- Showing total death by Continent

Select continent, Max(cast (total_deaths as int)) as TotalDeathCount
From Project_portfolio..Covid_death
Where continent is not null
Group by continent
Order by TotalDeathCount Desc

-- Global Cases and Deaths Per Cases Per day 

Select Date, Sum(new_cases)as TotalnewCases, Sum(cast(new_deaths as int))as TotalDeaths
From Project_portfolio..Covid_death
Where Continent is not null
Group by date

-- Showing Percentage of Global death per day on all Cases
Select Date, Sum(new_cases)as TotalnewCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(New_cases)*100 as Percentagedeath
From Project_portfolio..Covid_death
Where Continent is not null
Group by date
Order by 1,2

Select Sum(new_cases)as TotalnewCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as Percentagedeath
From Project_portfolio..Covid_death
Where Continent is not null
Group by date
Order by 1,2

--Looking at Total Population vs Vaccination

Select dea.continent, Dea.location, dea.date, dea.population, vac.new_vaccinations
From Project_Portfolio..Covid_death Dea
Join Project_Portfolio..CovidVaccinationI Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where dea.continent is not null
Order by 2,3

-- Partioning by Location and Using CTEs

Select dea.continent, Dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Project_Portfolio..Covid_death Dea
Join Project_Portfolio..CovidVaccinationI Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where dea.continent is not null
Order by 2,3


-- USING CTEs

with Popvsvac (Continent, location, date, Population, new_vaccinations, RollingPeopleVacinnated) 
as
(
Select dea.continent, Dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Project_Portfolio..Covid_death Dea
Join Project_Portfolio..CovidVaccinationI Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
Where dea.continent is not null
--Order by 2,3
)
Select*
From PopvsVac

-- creating Percantage with the Ctes
Select*, (RollingPeopleVaccinated/Population)*100
From Popvsvac

--TEMP TABLE
Drop Table if exists #PercentPeopleVaccinated
Create Table #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVacinnated numeric
)

Insert into #PercentpeopleVaccinated
Select dea.continent, Dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Project_Portfolio..Covid_death Dea
Join Project_Portfolio..CovidVaccinationI Vac
	on Dea.location = Vac.location
	and Dea.date = Vac.date
--Where dea.continent is not null
Select*
From  #PercentPeopleVaccinated

-- CREATING VIEW 
Create view TotalDeathPerContinent as
Select continent, Max(cast (total_deaths as int)) as TotalDeathCount
From Project_portfolio..Covid_death
Where continent is not null
Group by continent
--Order by TotalDeathCount Desc

Select*
from TotalDeathPerContinent

Create View TotalDeathPerCountry as
Select Location, Max(cast (total_deaths as int)) as TotalDeathCount
From Project_portfolio..Covid_death
Where continent is not null
Group by location
--Order by TotalDeathCount Desc

Select* 
From TotalDeathPerCountry


