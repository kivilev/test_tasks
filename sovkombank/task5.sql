-- Пример 5.

drop table payments;
create table payments (
  id number,
  pay_type number,
  pay_date date,
  pay_sum number
);

alter session set nls_date_format = 'dd.mm.YYYY';

insert into payments(id, pay_type, pay_date, pay_sum) values (1, 1, '01.01.2012', 100);
insert into payments(id, pay_type, pay_date, pay_sum) values (2, 1, '02.01.2012', 200);
insert into payments(id, pay_type, pay_date, pay_sum) values (3, 1, '03.01.2012', 300);
insert into payments(id, pay_type, pay_date, pay_sum) values (4, 1, '01.02.2012', 400);
insert into payments(id, pay_type, pay_date, pay_sum) values (5, 1, '01.02.2012', 500);
insert into payments(id, pay_type, pay_date, pay_sum) values (6, 2, '01.01.2012', 600);
insert into payments(id, pay_type, pay_date, pay_sum) values (7, 2, '01.02.2012', 700);
insert into payments(id, pay_type, pay_date, pay_sum) values (8, 2, '01.04.2012', 800);
insert into payments(id, pay_type, pay_date, pay_sum) values (9, 2, '01.05.2012', 900);
insert into payments(id, pay_type, pay_date, pay_sum) values (10, 2, '01.06.2012', 1000);
insert into payments(id, pay_type, pay_date, pay_sum) values (11, 3, '10.01.2012', 1100);
insert into payments(id, pay_type, pay_date, pay_sum) values (12, 3, '01.03.2012', 1200);
insert into payments(id, pay_type, pay_date, pay_sum) values (13, 3, '01.05.2012', 1300);
insert into payments(id, pay_type, pay_date, pay_sum) values (14, 3, '05.05.2012', 1400);
insert into payments(id, pay_type, pay_date, pay_sum) values (15, 3, '01.06.2012', 1500);
commit;

---- Итоговый запрос (на скорую руку)
select p3.id, p3.pay_type, p3.pay_date, p3.pay_sum, p3.curr_sum
  from (select p.*
              ,sum(p.pay_sum) over(partition by pay_type) all_sum
              ,sum(p.pay_sum) over(partition by pay_type order by p.pay_date) curr_sum
          from payments p) p3
 where p3.all_sum =
       (select max(sum(pay_sum)) from payments p2 group by p2.pay_type);

