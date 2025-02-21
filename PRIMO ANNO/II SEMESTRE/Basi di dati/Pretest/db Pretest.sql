create database pretest;

drop table if exists pretest.H;
create table pretest.H(a varchar(3), b varchar(3), c int, d date, e int);

insert into pretest.H values ('a0','b0',2,'2022-10-21',1);
insert into pretest.H values('a0','b2',NULL,'2022-10-21',NULL);
insert into pretest.H values('a1','b1',1,'2023-07-30',NULL);
insert into pretest.H values('a1','b2',1,'2022-10-12',1);
insert into pretest.H values('a1','b3',1,'2023-03-21',2);
insert into pretest.H values('a1','b4',2,NULL,2);
insert into pretest.H values('a2','b2',NULL,'2022-02-02',3);
insert into pretest.H values('a2','b3',2,'2023-03-21',1);

select * from pretest.H;

drop table if exists pretest.T;
create table pretest.T (a varchar(2), b varchar(2), c int, d date, e int);

insert into pretest.T values
--  ( a     b    c     d             e)
	('a0', 'b1', 9,    '2019-04-05', 1),
	('a1', 'b0', null, '2019-05-01', 1),
	('a1', 'b1', 0,    '2019-04-18', 1),
	('a3', 'b0', 3,    '2022-05-18', 1),
	('a3', 'b2', 2,    '2022-06-18', 2),
	('a5', 'b0', 3,    '2022-07-18', 1),
	('a5', 'b1', 1,    '2022-05-08', 2);


