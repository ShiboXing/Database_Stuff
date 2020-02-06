--Shibo Xing, Paul Elder
--shx26, pye1

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
select to_char(date_submitted, 'ww') as week,
       min(DATE_SUBMITTED) - to_char(min(DATE_SUBMITTED), 'D') + 1 start_date,
       min(DATE_SUBMITTED) - to_char(min(DATE_SUBMITTED), 'D') + 7 end_date, count(*)
from tickets
where date_closed is not null and date_submitted between to_date('2015-01-01','yyyy/mm/dd') and to_date('2015-12-31','yyyy/mm/dd')
group by to_char(date_submitted, 'ww')
order by week desc;


--5.a
create or replace view UnresolvedTKTS as
    select fname, lname, TICKET_NUMBER, DATE_SUBMITTED, DESCRIPTION
    from tickets join users on TICKETS.OWNER_PPLSOFT = USERS.PPLSOFT
    where DATE_CLOSED is null;
select * from UnresolvedTKTS;

--5.b
create or replace view ProblematicMachine as
    select mn, IP, NETWORK_PORT, MACADDR, LOCATION_ID
    from (
            select I.MACHINE_NAME mn, count(TICKET_NUMBER) cnt
            from INVENTORY I join TICKETS on I.MACHINE_NAME = TICKETS.MACHINE_NAME
            where (to_char(DATE_SUBMITTED, 'yyyy') = to_char(current_date, 'yyyy')
                    and to_char(DATE_SUBMITTED, 'mm') + 1 = to_char(current_date, 'mm'))
                or (to_char(DATE_SUBMITTED, 'yyyy') + 1 = to_char(current_date, 'yyyy')
                    and to_char(DATE_SUBMITTED, 'mm') = 12 and to_char(current_date, 'mm') = 1)
            group by I.MACHINE_NAME
         )
    join INVENTORY on mn = INVENTORY.MACHINE_NAME
    where cnt > 3;
select * from ProblematicMachine;

--5.c
create or replace view TechPerformance as
    select TECH_PPLSOFT, count(TICKET_NUMBER) tk_count
    from assignment
    where status = 'closed_successful'
    group by TECH_PPLSOFT
    order by tk_count desc;
select * from TechPerformance;

--6.a
select mn
from
    (
        select TICKETS.MACHINE_NAME mn, count(TICKET_NUMBER) cnt
        from TICKETS join INVENTORY on TICKETS.MACHINE_NAME = INVENTORY.MACHINE_NAME
                     join LOCATIONS on INVENTORY.LOCATION_ID = LOCATIONS.LOCATION_ID
        where LOCATION = '5th floor'
        group by TICKETS.MACHINE_NAME
    )
where cnt =
    (
        select max(count(TICKET_NUMBER)) max_cnt
        from TICKETS join INVENTORY on TICKETS.MACHINE_NAME = INVENTORY.MACHINE_NAME
                     join LOCATIONS on INVENTORY.LOCATION_ID = LOCATIONS.LOCATION_ID
        where LOCATION = '5th floor'
        group by TICKETS.MACHINE_NAME
    );

--6.b
select day_of_week, ticket_count
from
     (
        select to_char(date_submitted, 'D') day_of_week, count(ticket_number) ticket_count
        from tickets
        where date_submitted between to_date('2015-12-01','yyyy/mm/dd') and to_date('2015-12-31','yyyy/mm/dd')
        group by to_char(date_submitted, 'D')
     )
where ticket_count  =
     (
        select max(count(ticket_number)) ticket_count
        from tickets
        where date_submitted between to_date('2015-12-01','yyyy/mm/dd') and to_date('2015-12-31','yyyy/mm/dd')
        group by to_char(date_submitted, 'D')
     );

--7.a
create or replace trigger ClosedTicket
    after update on assignment
    for each row
    when(new.status = 'closed_successful' or new.status = 'closed_unsuccessful')
begin
    update tickets
    set date_closed = current_date
    where ticket_number = :new.ticket_number;
end;
/
--
-- update assignment
-- set status = 'closed_successful'
-- where ticket_number = 000000567856;
-- select * from tickets;

--7.b
create or replace trigger WorkedDays
    before update on assignment
    for each row
    when(new.status = 'closed_successful'
             or new.status = 'closed_unsuccessful'
             or new.status = 'delegated')
begin
    update tickets
    set days_worked_on = current_date - to_date(to_char(date_submitted, 'yyyy-mm-dd'), 'yyyy-mm-dd')
    where tickets.ticket_number = :new.ticket_number;
end;
/
--
-- update assignment
-- set status = 'closed_successful'
-- where ticket_number = 000000567852;
-- select * from assignment;
-- select * from tickets;

