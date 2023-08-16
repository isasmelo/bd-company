create schema if not exists company;
use company;

create table employee(
	fname varchar(15) not null,
	Minit char(3),
	Lname varchar(15) not null,
	Cpf char(11) not null,
	Bdate date,
	Address varchar(100),
	Sex char,
	Salary decimal(10,2),
	Super_cpf char(11),
	Dno int not null,
	primary key(Cpf)
);

create table departament(
	Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_cpf char(11),
    Mgr_start_date date,
    primary key (Dnumber),
    unique (Dname),
    foreign key (Mgr_cpf) references employee(Cpf)
);
ALTER TABLE departament ADD COLUMN Dept_create_date date;

create table dept_locations(
	Dnumber int not null,
    Dlocation varchar(15) not null,
    primary key (Dnumber, Dlocation),
    foreign key (Dnumber) references departament(Dnumber)
);

create table project(
	Pname varchar(15) not null,
    Pnumber int not null,
    Plocation varchar(15),
    Dnumber int not null,
    primary key (Pnumber),
    unique(Pname),
    foreign key (Dnumber) references departament(Dnumber)
);

create table works_on(
	Ecpf char(11) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Ecpf, Pno),
	foreign key (Ecpf) references employee(Cpf),
	foreign key (Pno) references project(Pnumber)
);

create table dependent(
	Ecpf char(11) not null,
    Dependent_name varchar(15) not null,
    Sex char, -- F , M or O
    Bdate date,
    Relationship varchar(9),
    primary key (Ecpf, Dependent_name),
    foreign key (Ecpf) references employee(Cpf)
);
show tables;
desc dependent;
