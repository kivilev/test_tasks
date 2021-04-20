-- Пример 2.
create table t (a number, b number);

insert into t(a,b) values(1,1);
insert into t(a,b) values(2,2);
insert into t(a,b) values(2,2);
insert into t(a,b) values(3,3);
insert into t(a,b) values(3,3);
insert into t(a,b) values(3,3);
commit;


-- Способ 1. Аналитич функция.
delete from t
 where rowid in (select rowid
                   from (select a
                               ,b
                               ,rowid
                               ,row_number() over(partition by a, b order by 1) rn
                           from t)
                  where rn > 1);

select * from t;

-- Способ 2. Минимальный rowid
delete from t
 where rowid not in (select min(rowid)
                       from t
                      group by a,b);
                      
-- Способ 3. PK + reject limit
create table t2 as select * from t where 1=0;
alter table t2 add constraint t2_pk primary key (a, b);

call  dbms_errlog.create_error_log('t2', 'errors_tbl');

insert into t2 select * from t log errors into errors_tbl reject limit unlimited;

truncate table t;

insert into t select * from t2;
select * from t;

-- Способ 4. Ошибки в DDL

create table errors2_tbl(
 row_id rowid,
 owner varchar2(30),
 table_name varchar2(30),
 constraint_name varchar2(30)
);

alter table t add constraint t_pk primary key (a, b) exceptions into errors2_tbl;

delete from errors2_tbl
 where row_id in (select min(t.rowid)
                    from t      
                        ,errors2_tbl e
                   where t.rowid = e.row_id
                   group by t.a, t.b);

delete from t where t.rowid in (select e.row_id  from errors2_tbl e);
select * from t;


                      

