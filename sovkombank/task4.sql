-- Пример 4.

create table rates
(
  curr_id   number not null,
  date_rate date not null,
  rate      number
);

alter table rates add constraint rates_pk unique (curr_id, date_rate);

--Курс валюты устанавливается не на каждую календарную дату.
--Уникальный ключ: curr_id + date_rate.

insert into rates(curr_id, date_rate, rate) values (1, date'2010-01-01', 30);
insert into rates(curr_id, date_rate, rate) values (2, date'2010-01-01', 40);
insert into rates(curr_id, date_rate, rate) values (1, date'2010-01-02', 32);
insert into rates(curr_id, date_rate, rate) values (1, date'2010-01-05', 33);
insert into rates(curr_id, date_rate, rate) values (2, date'2010-01-10', 41);
insert into rates(curr_id, date_rate, rate) values (2, date'2010-01-15', 42);
commit;

---- Итоговый запрос

-- 02.01.2010	- 32
select *
  from rates r
 where r.curr_id = 1
   and r.date_rate = 
       (select max(rr.date_rate)
          from rates rr
         where rr.curr_id = 1
           and rr.date_rate <= date '2010-01-03');

-- 10.01.2010	- 41
select *
  from rates r
 where r.curr_id = 2
   and r.date_rate = 
       (select max(rr.date_rate)
          from rates rr
         where rr.curr_id = r.curr_id
           and rr.date_rate <= date '2010-01-10');
           
