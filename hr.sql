--Create Database 

Create database project_hr;

use project_hr;

--retrive Data

select * from hr;

SET SQL_SAFE_UPDATES = 0;

-- Department wise emp

select Department,count(ID)
from hr 
group by Department;

-- Count the frequency of gender

select count( distinct Gender) as count_Gender from hr;

-- Count the frequenc of department

select count(distinct Department) as count_Dept  from hr;

-- Count the frequenc of race

select count(distinct Race) as count_race from hr;

-- Count the frequency of Jobtitle

select count(distinct Jobtitle) as count_jobtitle from hr;

-- distribution of gender and race 
select Gender, count(*) as Gender_count 
from hr
where termdate is null
group by Gender;

select Race,count(*) as Race_count 
from hr
where termdate is null
group by Race;

-- Avgerage of age ,min of age,max of age

select round(avg(Age),0) as Avg_Age,
	max(Age) as Max_Age,
	min(Age) as Min_Age 
from hr ;

-- Which Department has highest number of employees

select Department ,count(ID) as count_emp 
from hr
group by Department 
order by count_emp desc
limit 1;

-- lowest number
 select Department ,count(ID) as count_emp 
from hr
group by Department 
order by count_emp asc
limit 1;

-- Average Age,tenure distribution within each department

select Department ,round(avg(Age),0) as avg_age,Tenure 
from hr
group by Department,Tenure
order by avg_age desc, Tenure desc;

-- Avg tenure of employees

select avg(Tenure) as avg_tenure 
from hr ;


-- employee who have been with company the longest time

select id,First_name ,last_name , max(Tenure) as long_tenure 
from hr
where Termdate is not null
group by id,First_name,Last_name
order by  long_tenure desc
limit 1;


select ID,concat(First_name,' ' ,Last_name) as fullname , min(Tenure) as small_tenure 
from hr
where Termdate is not null
group by ID, First_name,Last_name
order by  small_tenure asc
limit 1;

-- the distribution of employees across different departments.

select Department, count(*) as Dept_count,
round(count(*)/(select count(*) from hr) * 100,2) as Percentage 
from hr 
group by Department
order by Percentage desc;

-- Determine which location (city or state) has the highest number of employees.

select State ,count(*) as emp_count from hr
group by State 
order by emp_count desc
limit 1;

select City,count(*) as emp_count from hr 
group by City 
order by emp_count desc;

-- most common job titles within the organization.

select Jobtitle,count(*) as emp_count from hr 
group by Jobtitle
order by emp_count desc
limit 5;

-- gender distribution vary across different job titles?

select Gender,Jobtitle,count(*) as emp_count from hr 
group by Jobtitle,Gender
order by Jobtitle, emp_count desc;


-- Age distribution of employees in company 

select 
	case
		when age>=20 and age<=30 then '20-30'
        when age>=31 and age<=40 then '31-40'
        when age>=41 and age<=50 then '41-50'
        when age>=51 and age<=60 then '51-60'
        else '60+'
    end as age_group,
count(*)  as emp_count from hr 
where Termdate is Null
group by age_group
order by age_group;

    
-- How many employees work at HQ vs Remote

select Location,count(*) as count_emp
from hr 
where Termdate is null
group by Location;

-- How many employee count changed over time based on hire and termination date 

select year,hires,
		termination,
        hires-termination as net_change,
        (termination/hires)*100 as change_percent 
from (
	select year(Hiredate) as year,
    count(*) as hires,
    count(case when Termdate is not null and Termdate<=curdate() then 1 end )
    as termination
    from hr
    group by year(Hiredate)) as subquery
group by year    
order by year;
