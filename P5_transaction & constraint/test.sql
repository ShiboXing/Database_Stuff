declare
 cursor st_cursor IS
    select FOREST_NO, STATE from COVERAGE;
 x integer := 0;
 y coverage%rowtype;
 bad_data exception;
begin
     select count(*) into x
     from coverage;
     if x<1 then RAISE bad_data;
     else dbms_output.put_line('number of coverage= ' || x);
     end if;
     open st_cursor;
     loop
         fetch st_cursor into y;
         if not found then
             exit;
         end if;
     end loop;

exception
    when bad_data then
        dbms_output.put_line('trouble');
end;