-- Пример 1.
create table t1(a number, b number);
create table t2(a number, b number);

-- Кейс с неидентичными данными 
insert into t1(a,b) values(1,1);
insert into t1(a,b) values(2,2);
insert into t1(a,b) values(2,2);
insert into t1(a,b) values(3,3);
insert into t1(a,b) values(4,4);

insert into t2(a,b) values(1,1);
insert into t2(a,b) values(2,2);
insert into t2(a,b) values(3,3);
insert into t2(a,b) values(3,3);
insert into t2(a,b) values(4,4);

commit;
/*
-- Кейс с идентичными данными
truncate table t1;
truncate table t2;

insert into t1(a,b) values(1,1);
insert into t1(a,b) values(2,2);
insert into t1(a,b) values(2,2);
insert into t1(a,b) values(3,3);
insert into t1(a,b) values(4,4);

insert into t2(a,b) values(1,1);
insert into t2(a,b) values(2,2);
insert into t2(a,b) values(2,2);
insert into t2(a,b) values(3,3);
insert into t2(a,b) values(4,4);
commit;*/


---- Итоговый запрос (для реальной задачи такой способ не подойдет)
select decode(max(case when t1.cnt is null or t2.cnt is null then 100 else 0 end), 100, 'не идентичны', 'идентичны') "идентичны ли две таблицы" 
  from (select a, b, count(*) cnt
          from t1
         group by a,b) t1
  full join (select a, b, count(*) cnt
               from t2
              group by a,b) t2
    on t1.a = t2.a and t1.b = t2.b and t1.cnt = t2.cnt;
