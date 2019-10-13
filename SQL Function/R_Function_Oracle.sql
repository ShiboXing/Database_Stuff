create or replace function can_pay_loan(customer_ssn char(9))
    return boolean as

declare
    can_pay boolean :=false;
begin
    return can_pay;
end;