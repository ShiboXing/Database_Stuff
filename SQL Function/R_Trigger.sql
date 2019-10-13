create or replace function can_pay_loan(customer_ssn char(9))
    returns boolean as
$$
declare
    can_pay boolean := false;
begin
    select (a.ssn=$1)
        into can_pay
    from account a
        left join loan l on a.ssn=l.ssn
    where a.ssn=$1 and a.balance>l.amount
        or l.ssn is null;
    return can_pay;
end;
$$ Language plpgsql;
commit;

drop trigger if exists trig_1 on account;
create trigger trig_1
    after insert
    on account
    for each row
execute procedure can_pay_loan('111222333');
