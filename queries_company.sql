-- utilizando queries do BD company
show databases;
use company;
show tables;

select * from employee;

-- solicitando os gerentes de cada departamento
select Cpf, Fname, Dname from employee e, departament d where (e.Cpf = d.Mgr_cpf);

-- solicitando dependentes de cada employee
select Fname, Dependent_name, Relationship from employee e, dependent d where (e.Cpf = d.Ecpf);

-- solicitando horas trabalhadas por employee em cada projeto
select Pname, Ecpf, Fname, Hours from employee e, project p, works_on w where ( Pnumber = Pno and Ecpf =cpf);

-- solicitando employees e seus supervisore
select E.Fname, E.Lname,S.Fname,S.Lname from employee e, employee s where e.Super_cpf = s.Cpf;

-- solicitando gerentes dos departamentos
select Dname as Department, concat(Fname, ' ', Lname) as Manager, Dlocation as Location from departament d, dept_locations l, employee e
where d.Dnumber = l.Dnumber and Mgr_cpf = e.Cpf;

-- solicitando valores de INSS dos employees
select concat(Fname, ' ', Lname), Salary, round(Salary*0.11,2) as INSS from employee;


-- definir um aumento de salário para os employees que trabalham no projeto associado ao ProdutoX
select e.Fname, e.Lname, e.Salary, round(1.1*e.Salary,2) as Increased_salary from employee as e,
			works_on as w, project as p where e.Cpf = w.Ecpf and w.Pno = p.Pnumber and p.Pname='ProductX';

-- solicitando os gerentes de cada departamento
select Dname as Department, concat(Fname, ' ', Lname) as Manager, Dlocation as Location from departament d, dept_locations l, employee e
where d.Dnumber = l.Dnumber and Mgr_cpf = e.Cpf;

select * from dept_locations;

-- solicitando info dos projetos em Stafford
select Pname, Pnumber,Plocation, Dname, p.Dnumber, Mgr_cpf from project p, departament d where p.Dnumber = d.Dnumber and Plocation = 'Stafford';

-- solicitando employees de Huston-Tx
select concat(Fname, ' ', Lname) as Complete_name, Address, Dname from employee, departament where Dno = Dnumber and Address like '%Houston-TX%';

-- solicitando salarios entre dois valores
select concat(Fname, ' ', Lname) as Complete_name, Cpf, Salary, Dno from employee where (Salary between 30000 and 50000);

-- solicitando todos os projetos que Smith trabalha e gerencia
select distinct Pnumber from project where Pnumber in 
		(select Pnumber from project p, departament d, employee e
        where p.Dnumber=d.Dnumber and Mgr_cpf = Cpf and Lname='Smith')
        or 
        Pnumber in
        (select Pno from works_on, employee
        where Ecpf = Cpf and Lname='Smith');
        
-- solicitando employees que possuem dependentes
select e.Fname, e.Lname
	from employee e
	where exists (	select * from dependent as d 
                    where e.Cpf=d.Ecpf );

-- solicitando employees que possuem MAIS DE 1 dependentes
select e.Fname, e.Lname 
	from employee as e
	where (select count(*) from dependent 
                    where Cpf=Ecpf)>1; 
                    
-- recuperando o cpf de todos empregados que trabalham nos projetos 1,2 ou 3
select distinct Ecpf, Pno from works_on where Pno in (1,2,3);
  
select * from dependent;

--
-- cláusulas de ordenação
--

-- nome do departamento, nome do gerente dos projetos
SELECT distinct d.Dname, e.Fname, e.Lname , p.Pname FROM departament d, employee e, works_on w, project p
	where e.Cpf = d.Mgr_cpf and w.Ecpf = d.Mgr_cpf and w.Pno = p.Pnumber
	ORDER BY d.Dname desc, e.Lname, e.Fname;  

-- nome do departamento, nome do gerente
select distinct d.Dname, e.Fname,e.Lname, Address
	from departament as d, employee as e
	where (d.Dnumber = e.Dno and e.cpf=d.Mgr_cpf)
    order by d.Dname, e.Fname, e.Lname;

-- recupero todos os empregados e seus projetos em andamento
select concat(e.Fname,' ',e.Lname) as Employee, p.Pname as Project_Name, d.Dname as Department
	from departament as d, employee e, works_on w, project p
    where (d.Dnumber = e.Dno and e.cpf = w.Ecpf and w.Pno = p.Pnumber)
    order by d.Dname desc, e.Fname asc, e.Lname asc,  p.Pname;
 
--
-- funções e cláusulas de agrupamento
--

-- media salarial por deoartamento
select Dno, count(*) as Number_of_employees, round(avg(Salary),2) as Salary_avg from employee
	group by Dno;

-- employees por projeto
select Pnumber, Pname, count(*) as number_of_employee, round(avg(salary),2) as AVG_salary
	from project, works_on, employee
    where Pnumber = Pno and cpf = Ecpf
    group by Pnumber, Pname
    order by avg(salary);

-- num de salarios distintos
select count(distinct Salary) from employee;

-- valores dos salarios
select sum(Salary) as total_sal, max(Salary) as Max_sal, min(Salary) as Mini_sal, round(avg(Salary),2) as Avg_sal from employee;

--
-- group by e having
--

--
select Pnumber, Pname, count(*) as number_of_employee
	from project, works_on
	where Pnumber = Pno
	group by Pnumber, Pname
	having count(*) > 2
    order by Pnumber;

-- quantidade de employees que ganham mais que x por departamento
select Dno, count(*) as Number_of_employee
	from employee 
	where Salary > 20000
    group by Dno
    having count(*)>=2
    order by Dno;
-- =
select Dno as Department, count(*) as NumberOfEmployess from employee
	where Salary>20000 
		and Dno in (select Dno from employee
					group by Dno
					having count(*)>=2)
	group by Dno;


--
-- case statement
--

select Fname, Salary, Dno from employee;

UPDATE EMPLOYEE
SET Salary =
	CASE 
		WHEN Dno = 5 THEN Salary + 2000
		WHEN Dno = 4 THEN Salary + 1500
		WHEN Dno = 1 THEN Salary + 3000
		ELSE (Salary + 0) 
	END;
    
--
-- JOIN --> CROSS JOIN
--

select * from employee JOIN works_on;

-- JOIN ON -> INNER JOIN ON
select * from employee JOIN works_on on Cpf = Ecpf;

select Fname, Lname, Address, Dno
	from (employee e join departament d on Dno=Dnumber)
    where Dname='Research';

select * from employee;
select * from dept_locations;  
select * from departament;  

select Dname as Department, Dept_create_date as StartDate, Dlocation as Location
	from departament JOIN dept_locations using(Dnumber)
    order by StartDate; 

-- JOIN com mais de 3 tabelas

-- project, works_on e employee
select concat(Fname,' ', Lname) as Complete_name, Dno as DeptNumber, Pname as ProjectName, 
		Pno as ProjectNumber, Plocation as Location from employee
	inner join works_on on Cpf = Ecpf
    inner join project on Pno = Pnumber
    where Pname like 'Product%'
	order by Pnumber;

-- departament, dept_location, employee(gerentes)
select Dnumber, Dname,  Dlocation, concat(Fname,' ',Lname) as Manager, Salary, round(Salary*0.05,2) as Bonus from departament
		inner join dept_locations using(Dnumber)
        inner join employee on Cpf = Mgr_cpf
        group by Dnumber, Dlocation;

-- gerentes que possuem +1 dependentes  
select Dnumber, Dname, concat(Fname,' ',Lname) as Manager, Salary, round(Salary*0.05,2) as Bonus from departament
		inner join dept_locations using(Dnumber)
        inner join (dependent inner join employee on Cpf = Ecpf) on Cpf = Mgr_cpf
        group by Dnumber
        having count(*)>1;

-- gerentes que começaram a atuar a partir de 1980 dentro de Houston
SELECT a.Fname, a.Lname, a.Salary
	FROM employee a INNER JOIN
		(SELECT Dname, Dnumber, Mgr_cpf
		FROM departament
		WHERE Mgr_start_date > '1980-01-01') e
		ON a.Cpf = e.Mgr_cpf
	INNER JOIN
		(SELECT *
		FROM project
		WHERE Plocation like '%Houston%') b
		ON e.Dnumber = b.Dnumber;
        
--
-- OUTER JOIN
--

select * from employee inner join dependent on Cpf = Ecpf;
select * from employee left join dependent on Cpf = Ecpf;
select * from employee left outer join dependent on Cpf = Ecpf;

SELECT E.Lname AS Employee_name,
S.Lname AS Supervisor_name
FROM (EMPLOYEE AS E LEFT OUTER JOIN EMPLOYEE AS S
ON E.Super_cpf = S.Cpf);

-- NATURAL JOIN
SELECT Dname, Dnumber, Mgr_cpf
	FROM (departament NATURAL JOIN
	(dept_locations))
WHERE Dlocation = 'Houston';





