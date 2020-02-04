-- 9.a
create or replace view working_tickets as
    select ASSIGNMENT.TECH_PPLSOFT, last_date,
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



