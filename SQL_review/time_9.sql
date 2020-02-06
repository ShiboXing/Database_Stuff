set timing on;
select count(*) from working_tickets
where STATUS = 'closed_successful';

set timing on;
select count(*) from mv_working_tickets
where STATUS = 'closed_successful';
