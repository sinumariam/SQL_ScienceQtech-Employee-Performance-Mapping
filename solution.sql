-- ScienceQtech Employee Performance Mapping
/* Create a database named employee, then import data_science_team.csv proj_table.csv 
and emp_record_table.csv into the employee database from the given resources.*/
create database employee;
use employee;
show tables;
describe emp_record_table;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER,DEPT from
 emp_record_table group by DEPT,FIRST_NAME, LAST_NAME,EMP_ID,GENDER;
 select
  DEPT,
  GROUP_CONCAT(
    CONCAT(EMP_ID, ' – ', FIRST_NAME, ' ', LAST_NAME, ' (', GENDER, ')')
    ORDER BY LAST_NAME, FIRST_NAME
    SEPARATOR '\n'
  ) AS employees
FROM emp_record_table
GROUP BY DEPT;
select count(*) from emp_record_table;
/*Write a query to fetch 
EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
less than two
greater than four 
between two and four  */
desc emp_record_table;
select emp_rating from emp_record_table;
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table where EMP_RATING!=2 and emp_rating!=4;

/* Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees
 in the Finance department from the employee table 
 and then give the resultant column alias as NAME*/
 select concat( first_name, ' ', last_name) , DEPT from emp_record_table where Dept='FINANCE';
 desc emp_record_table;
 
/* Write a query to list only those employees 
who have someone reporting to them. 
Also, show the number of reporters (including the President).*/

-- ANSWER
select first_name, Last_name from emp_record_table where emp_id in
(select manager_id from emp_record_table);
select count(*) from emp_record_table where manager_id is not null;

/* Write a query to list down all 
the employees from the healthcare and finance departments using union.
 Take data from the employee record table.
*/

(select first_name,last_name,dept from emp_record_table where dept='finance') union
 (select first_name,last_name,dept from emp_record_table where dept='healthcare' );
 
 /*8.Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, 
 DEPARTMENT, and EMP_RATING grouped by dept.
 Also include the respective employee rating along with the max emp rating for the department.*/
 
 select EMP_ID, FIRST_NAME, LAST_NAME,role ,DEPT, EMP_RATING,
 max(EMP_RATING) over (partition by dept) as Max_Rating
 from emp_record_table;

/* Write a query to calculate 
the minimum and the maximum salary of the employees in each role. 
Take data from the employee record table.*/
 select distinct dept,max(salary) over (partition by dept) as Max_salary,
 min(salary) over (partition by dept) as Min_salary
 from emp_record_table;

/* Write a query to assign ranks to each employee based on their experience. 
Take data from the employee record table.*/

select first_name,last_name,exp, dense_rank() over (order by exp desc) from emp_record_table;

/*Write a query to create a view that displays employees in various countries whose salary is more
 than six thousand. Take data from the employee record table. */
 
select first_name,last_name,salary,country from emp_record_table having salary >6000 ;
create view AAA as (select first_name,last_name,salary,country from emp_record_table having salary >6000 ) ;
  
  /* Write a nested query 
  to find employees with experience of more than ten years. Take data from the employee record table. */
 
 select first_name, exp from emp_record_table where exp>10;
 select first_name from (select first_name,exp from emp_record_table where exp>10)temp;
 
 /* Write a query to create a stored procedure to retrieve the details of the employees 
 whose experience is more than three years. Take data from the employee record table.*/
 
DELIMITER $$ 
create procedure emp_exp_greater()
BEGIN
 select emp_id,first_name,gender,exp from emp_record_table where exp>3;
END $$ 
DELIMITER ;

call emp_exp_greater();
 
 /* Write a query using stored functions in the project table to check whether 
 the job profile assigned to each employee in the data science team matches the organization’s set standard.
The standard being:

For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',

For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',

For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',

For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',

For an employee with the experience of 12 to 16 years assign 'MANAGER'. */
 
 
 delimiter $$
 create function role_correct3(exp int)
 returns varchar(30)
 deterministic
 
 Begin
 declare profession varchar(30);
 if exp <=2 then set profession= 'JUNIOR DATA SCIENTIST';
 elseif exp > 2 and exp <=5 then set profession= 'ASSOCIATE DATA SCIENTIST';
 elseif exp > 5 and exp <=10 then set profession='SENIOR DATA SCIENTIST';
 elseif exp >  10 and exp <=12 then set profession= 'SENIOR DATA SCIENTIST';
 elseif exp > 12 and exp <=16 then set profession= 'MANAGER';
 else set profession= 'role not identified';
 end if;
 return profession;
 end $$
 delimiter ;
 
 select first_name,last_name,role,exp,role_correct3(exp) from data_science_team where role!=role_correct3(exp);
 
 select first_name,last_name,role,exp,role_correct3(exp),
 case
 when role_correct3(exp)=role then 'match'
 else 'mismatch'
 end 
 as checked_status
 from data_science_team;
 
 /* Create an index to improve the cost and performance of 
 the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after 
 checking the execution plan.*/
 
 select * from emp_record_table where first_name='Eric';
 create index Index_For_name on emp_record_table(first_name(10));
 show indexes from emp_record_table;
 
 /*Write a query to calculate the bonus for all the employees,
 based on their ratings and salaries (Use the formula: 5% of salary * employee rating). */
 select emp_id, concat(first_name," ",last_name)as Name,salary,emp_rating ,(salary *0.05)*emp_rating as bonus
 from emp_record_table;
 
 /* Write a query to calculate the average salary distribution based on 
 the continent and country. Take data from the employee record table.*/
 
 select continent, country,
 avg(salary)  from emp_record_table group by continent, country order by continent, country ;