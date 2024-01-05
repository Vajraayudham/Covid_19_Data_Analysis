SELECT * FROM `my-sample-project-coursera.covid_data.CovidDeath` LIMIT 1000

-- Selecting Particular data that want to be use
SELECT 
  location, date, total_cases,
  new_cases, total_deaths, population
from 
  `my-sample-project-coursera.covid_data.CovidDeath` 
limit 1000

-- total cases vs total deaths 
select  
	location, `date` ,total_cases ,total_deaths ,
	(total_deaths/total_cases ) * 100 as DeathPercentage
from  
	`my-sample-project-coursera.covid_data.CovidDeath` 
where 
	location = 'India' 
order by 1,2 

-- total cases vs population , shows % of population got covid
select  
	location, `date` ,population  ,total_cases ,
	(total_cases /population  ) * 100 as CasesPercentage
from  
	`my-sample-project-coursera.covid_data.CovidDeath` 
-- where location = 'India' 
order by 1,2 

-- highest infection rates compated to  population
select 
	location as Country, population  , MAX(total_cases) as HighInfectionRate,
	MAX((total_cases /population  )) * 100 as CasesPercentage
from
	`my-sample-project-coursera.covid_data.CovidDeath` 
group by 
	location , population 
order by 	CasesPercentage desc 

-- Highest Death counts per population
select 
	location,sum(total_deaths) as TotalDeathCount
from
	`my-sample-project-coursera.covid_data.CovidDeath` 
group by 	location  
order by 	TotalDeathCount desc 


-- Top 10 countried with total death , total cases count

select 
	population , location,
	max(total_deaths) as TotalDeathCount,
	max(total_cases) as TotalCases
from
	`my-sample-project-coursera.covid_data.CovidDeath` 
where location  not like '%income' 
group by 	location , population 
order by 	TotalDeathCount desc 
limit 11

-- countries highest death counts per population   
select 
	location,MAX(cast(total_deaths as int)) as TotalDeathCount
from
	`my-sample-project-coursera.covid_data.CovidDeath` 
where  continent  is not null
group by 	location  
order by 	TotalDeathCount desc

-- Working with continent  
select 
	continent ,MAX(total_deaths) as TotalDeathCount 
from
	`my-sample-project-coursera.covid_data.CovidDeath`
group by 	continent  
order by 	TotalDeathCount desc

-- continent with highest death count per population
select 
	continent ,MAX(total_deaths) as TotalDeathCount 
from
	`my-sample-project-coursera.covid_data.CovidDeath`
group by 	continent  
order by 	TotalDeathCount desc 

-- Global Numbers 
select 
	sum(new_cases) as totalCases,
	sum(new_deaths) as totalDeaths,
	sum(new_deaths)/ sum(new_cases) * 100 as DeathPercentage  
from 
	`my-sample-project-coursera.covid_data.CovidDeath` 
order by 1,2

-- Join two tables `my-sample-project-coursera.covid_data.CovidDeath`s and `my-sample-project-coursera.covid_data.CovidVaccination`
select *
from 
	`my-sample-project-coursera.covid_data.CovidDeath` cd 
join 
	`my-sample-project-coursera.covid_data.CovidVaccination` cv 
on	cd.location = cv.location and cd.`date` = cv.`date` 

-- total population vs vaccination
select 
	cd.continent , cd.location ,
	cd.`date`,cd.population,
	cv.new_vaccinations,
	sum(cv.new_vaccinations) over (partition by cd.location order by cv.location, cv.date) as RollingPeopleVaccin
from 
	`my-sample-project-coursera.covid_data.CovidDeath` cd 
join 
	`my-sample-project-coursera.covid_data.CovidVaccination` cv 
on	cd.location = cv.location and cd.`date` = cv.`date` 
where cd.continent is not null and cv.new_vaccinations is not null 
order by 1,2,3

-- use cte 

with PopVsVacc AS
(
  select 
	cd.continent , cd.location ,
	cd.`date`,cd.population,
	cv.new_vaccinations,
	sum(cv.new_vaccinations) over (partition by cd.location order by cv.location, cv.date) as RollingPeopleVaccin
from 
	`my-sample-project-coursera.covid_data.CovidDeath` cd 
join 
	`my-sample-project-coursera.covid_data.CovidVaccination` cv 
on	cd.location = cv.location and cd.`date` = cv.`date` 
where cd.continent is not null and cv.new_vaccinations is not null 
-- order by 1,2,3
) 
select *,(RollingPeopleVaccin / population)* 100 from PopVsVacc

-- Temporary Table
CREATE TEMP TABLE PercentPopVaccinated  AS  
select cd.continent , cd.location ,cd.`date`,cd.population,cv.new_vaccinations,
     sum(cv.new_vaccinations) over (partition by cd.location order by cv.location, cv.date) as RollingPeopleVaccin
from 
	`my-sample-project-coursera.covid_data.CovidDeath` cd 
join 
	`my-sample-project-coursera.covid_data.CovidVaccination` cv 
on	cd.location = cv.location and cd.`date` = cv.`date` 
where cd.continent is not null and cv.new_vaccinations is not null 


SELECT *,(RollingPeopleVaccin / population)* 100 from  PercentPopVaccinated

-- Create View
create view PercentPopVaccinated  AS  
select cd.continent , cd.location ,cd.`date`,cd.population,cv.new_vaccinations,
     sum(cv.new_vaccinations) over (partition by cd.location order by cv.location, cv.date) as RollingPeopleVaccin
from 
	`my-sample-project-coursera.covid_data.CovidDeath` cd 
join 
	`my-sample-project-coursera.covid_data.CovidVaccination` cv 
on	cd.location = cv.location and cd.`date` = cv.`date` 
where cd.continent is not null and cv.new_vaccinations is not null 

