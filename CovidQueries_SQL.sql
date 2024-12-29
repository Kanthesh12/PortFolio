select *from PortFolio ..CovidDeaths
order by 3,4


select *from PortFolio ..CovidVaccinations
order by 3,4



select location, date, total_cases, total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
from PortFolio ..CovidDeaths
order by 1,2


select location, date, population, total_cases , (total_cases/population)*100 as PercentagePopulationInfected 
from PortFolio ..CovidDeaths
order by 1,2


select location, population, max(total_cases) as Max_Affected , max((total_cases/population))*100 as  PercentagePopulationInfected 
from PortFolio ..CovidDeaths
group by location , population
order by PercentagePopulationInfected desc


select location, max(cast(total_deaths as int)) as Total_Deaths 
from PortFolio ..CovidDeaths
where continent is not null 
group by location 
order by Total_Deaths  desc

select continent, sum(cast(total_deaths as int)) as Total_Deaths 
from PortFolio ..CovidDeaths
where continent is not null 
group by continent
order by Total_Deaths  desc


select   sum(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeaths,(sum(cast(new_deaths as int)) /sum(new_cases))*100 as DeathPrecentages
from PortFolio ..CovidDeaths
where continent is not null
order by 1,2


with PopvsVac(Continent ,Location , Date, Population, New_vaccinations,RollingPeopleVaccinated)
as 
(select dea.Continent , dea.Location, dea.Date,dea.Population ,vac.New_vaccinations
,sum(cast(vac.New_vaccinations as int))  over (partition by dea.Location order by dea.Location ,dea.Date) as RollingPeopleVaccinated
from PortFolio ..CovidDeaths dea 
join PortFolio ..CovidVaccinations vac
on dea.Location=vac.Location
and dea.Date=vac.Date
where dea.Continent is not null
)
select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac





create table #PercentPopulationVaccinated
(Continent nvarchar(255),
 Location  nvarchar(255),
 Date DateTime,
 Population Numeric,
 New_vaccinations  numeric,
 RollingPeopleVaccinated numeric)

insert into #PercentPopulationVaccinated
select dea.Continent , dea.Location, dea.Date,dea.Population ,vac.New_vaccinations
,sum(cast(vac.New_vaccinations as int))  over (partition by dea.Location order by dea.Location ,dea.Date) as RollingPeopleVaccinated
from PortFolio ..CovidDeaths dea 
join PortFolio ..CovidVaccinations vac
on dea.Location=vac.Location
and dea.Date=vac.Date

select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



create view PercentPopulationVaccinated as
 select dea.Continent , dea.Location, dea.Date,dea.Population ,vac.New_vaccinations
,sum(cast(vac.New_vaccinations as int))  over (partition by dea.Location order by dea.Location ,dea.Date) as RollingPeopleVaccinated
from PortFolio ..CovidDeaths dea 
join PortFolio ..CovidVaccinations vac
on dea.Location=vac.Location
and dea.Date=vac.Date
where dea.continent is not null


select *
from PercentPopulationVaccinated