-- Пример 7.
with dates as
 (select date '2013-02-10' end_date
        ,date '2013-01-10' start_date
    from dual)
select dates.start_date + level - 1
  from dates
      ,dual
connect by level <= (end_date - start_date) + 1
