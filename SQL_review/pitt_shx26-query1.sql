--Shibo Xing
--shx26

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

--4.b
--Todo: ask if cnt needs to be greater than all other cnts
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
    )

--4.c


