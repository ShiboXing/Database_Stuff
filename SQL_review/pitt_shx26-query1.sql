--Shibo Xing
--shx26

-- set linesize 100;
-- set pagesize 2000;
-- set sqlblanklines on;
-- alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';

-- Question #4:
commit;
--4.a
select fname, lname, OFFICE_PHONE
from (
         select fname, lname, OFFICE_PHONE, PPLSOFT, count(PPLSOFT) cnt
         from users
                  join tickets on USERS.PPLSOFT = TICKETS.OWNER_PPLSOFT
         group by fname, lname, OFFICE_PHONE, PPLSOFT
     )
order by cnt desc;


-- return the personnels with most tickets resolve count
--4.b
select fn, ln, cnt from
    (
        select fname fn, lname ln, PPLSOFT, count(PPLSOFT) cnt
        from TECH_PERSONNEL join ASSIGNMENT on TECH_PERSONNEL.PPLSOFT = ASSIGNMENT.TECH_PPLSOFT
        where status = 'closed_successful'
        group by fname, lname, PPLSOFT
    )
where
    (
        cnt =
            (
                select max(count(PPLSOFT)) cnt
                from TECH_PERSONNEL join ASSIGNMENT on TECH_PERSONNEL.PPLSOFT = ASSIGNMENT.TECH_PPLSOFT
                where status = 'closed_successful'
                group by fname, lname, PPLSOFT
            )
    );

--4.c
select machine_name from
    (
        select machine_name, count(MACHINE_NAME) cnt
        from tickets
        where DATE_SUBMITTED between to_date('2015-12-01','yyyy/mm/dd') and to_date('2016-01-31','yyyy/mm/dd')
        group by machine_name
    )
where cnt =
    (
        select max(count(MACHINE_NAME)) max_cnt
        from tickets
        where DATE_SUBMITTED between to_date('2015-12-01','yyyy/mm/dd') and to_date('2016-01-31','yyyy/mm/dd')
        group by machine_name
    );

--4.d
select count(MACHINE_NAME)/31 avg_cnt
from tickets
where DATE_SUBMITTED between to_date('2016-01-01','yyyy/mm/dd') and to_date('2016-01-31','yyyy/mm/dd');

--4.e
select TECH_PPLSOFT, FNAME, LNAME, sum(DAYS_WORKED_ON) days
from ASSIGNMENT join TICKETS on assignment.TICKET_NUMBER = tickets.TICKET_NUMBER
                join TECH_PERSONNEL on ASSIGNMENT.TECH_PPLSOFT = TECH_PERSONNEL.PPLSOFT
where date_closed between to_date('2016-01-01','yyyy/mm/dd') and to_date('2016-01-31','yyyy/mm/dd')
group by (TECH_PPLSOFT, fname, lname)
order by days asc;


-- week (1-52), start date, end date, number of successfully closed tickets
-- weekly between 2015/01/01 and 2015/12/31, sorted by descending week
--4.f
select to_char(date_submitted, 'ww') as week, min(date_submitted) as start_date, max(date_closed) as end_date, count(*)
from tickets
where date_closed is not null and date_submitted between to_date('2015-01-01','yyyy/mm/dd') and to_date('2015-12-31','yyyy/mm/dd')
group by to_char(date_submitted, 'ww')
order by week desc;
