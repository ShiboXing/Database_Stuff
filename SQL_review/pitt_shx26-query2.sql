--Shibo Xing, Paul Elder
--shx26, pye1

--drop materialized view MV_WORKING_TICKETS;

-- 9.a
create or replace view working_tickets as
    select ASSIGNMENT.TECH_PPLSOFT, ASSIGNMENT.STATUS, last_date,
           fname, lname, tickets.*
    from (
            select TICKET_NUMBER, max(DATE_ASSIGNED) last_date
            from ASSIGNMENT
            group by TICKET_NUMBER
        ) last_dates
        join assignment on last_dates.TICKET_NUMBER = ASSIGNMENT.TICKET_NUMBER
        join TECH_PERSONNEL on TECH_PERSONNEL.PPLSOFT = ASSIGNMENT.TECH_PPLSOFT
        join TICKETS on tickets.TICKET_NUMBER = ASSIGNMENT.TICKET_NUMBER
    where DATE_ASSIGNED = last_date;

select * from working_tickets;

-- 9.b
create materialized view MV_WORKING_TICKETS
    build immediate as
    select * from working_tickets;

-- 9.c
-- Q1
select count(*) from working_tickets
where STATUS = 'closed_successful';
-- Q2
select count(*) from mv_working_tickets
where STATUS = 'closed_successful';

--9.d
--after populating the data with perl ticketGen.sql -t 10000
-- query:
    -- set timing on;
    -- select count(*) from working_tickets
    -- where STATUS = 'closed_successful';
    --
    -- set timing on;
    -- select count(*) from mv_working_tickets
    -- where STATUS = 'closed_successful';
    --

-- output:

    -- SQL> @time_9d.sql
    --
    --   COUNT(*)
    -- ----------
    -- 	12
    --
    -- Elapsed: 00:00:00.00
    --
    --   COUNT(*)
    -- ----------
    -- 	12
    --
    -- Elapsed: 00:00:00.00








