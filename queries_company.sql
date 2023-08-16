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