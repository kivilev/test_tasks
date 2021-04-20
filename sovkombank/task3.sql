-- Пример 3.

drop table t;
create table t (id number, pid number, nam varchar2(255 char));

insert into t(id, pid, nam) values (1, null, 'Корень');
insert into t(id, pid, nam) values (2, 1, 'Узел2');
insert into t(id, pid, nam) values (3, 1, 'Узел3');
insert into t(id, pid, nam) values (4, 2, 'Узел4');
insert into t(id, pid, nam) values (5, 4, 'Узел5');
insert into t(id, pid, nam) values (6, 5, 'Узел6');
insert into t(id, pid, nam) values (7, 4, 'Узел7');

commit;


---- Итоговый запрос

select id, pid, nam, prior nam
  from t 
 connect by prior id = pid and id <> 5
 start with pid is null 
 order siblings by id;
