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

create or replace function check_customers_can_pay(rand_number Integer, discount integer)
returns text as
    $$
    declare
        report text default '';
        cc cursor
            for select name,ssn,phone from customer;
        rc record;
        count integer := 0;

    begin
        open cc;
        loop
            --fetch next row in to rc
            fetch cc into rc;
            --exit when no more row to fetch
            exit when not FOUND;

            if count=rand_number then
                if can_pay_loan(rc.ssn) then
                    report := report || '' ---to do
                end if;
            end if;
        end loop;
        close cc;
        return report;
    end;
     $$ Language plpgsql;


update account
set balance=99999999
where ssn='111222333';

select can_pay_loan(customer_ssn := '111222333');