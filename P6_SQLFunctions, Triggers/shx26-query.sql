--Shibo Xing
--shx26

--1a
 create or replace procedure proUpdateLastRead(input_sensor_id int, read_time timestamp)
     language plpgsql
 as
     $$
     begin
         update sensor
         set last_read=read_time
         where sensor_id=input_sensor_id;
     end
     $$;

--1b
 create or replace function fun_Compute_Percentage(input_forest_no varchar(10), area_covered float)
     returns float as
 $$
     declare
         res float:=.0;
     begin
         select area_covered/F.area
         into res
         from forest F
         where forest_no=input_forest_no;
         if res>1
             then res:=1;
         end if;
         return res;
     end;
 $$ language plpgsql;

--2a
create or replace function TrigUpdateLastRead() returns trigger as
 $$
     begin
         call proUpdateLastRead(new.sensor_id,new.report_time);
         return new;
     end
 $$ language plpgsql;
drop trigger if exists tri_Last_Read on report;
create trigger tri_Last_Read
                     after insert on report for each row
                 execute procedure TrigUpdateLastRead();
--2b
create or replace function TrigUpdatePercentage() returns trigger as
                     $$
                         begin
                             update coverage
                             set percentage= fun_Compute_Percentage(new.forest_no,new.area)
                             where forest_no=new.forest_no;
                             return new;
                         end;
                     $$ language plpgsql;
drop trigger if exists tri_Percentage on coverage;
create trigger tri_Percentage
                     after update of area on coverage
                     for each row
                 execute function TrigUpdatePercentage();

--2c
create or replace function TrigAddEmergency() returns trigger as
                     $$
                         begin
                             insert into emergency
                             values(new.sensor_id,new.report_time);
                             return new;
                         end;
                     $$ language plpgsql;
drop trigger if exists tri_Emergency on report;
create trigger tri_Emergency
                     after insert on report for each row when(new.temperature>100)
                 execute function trigAddEmergency();

--3a
select * from sensor;
insert into report values(1,55,'3318-01-01 10:00:00.000000');
select * from sensor;

--3b
select * from coverage;
update coverage set area=5000 where forest_no='2' and state='PA';
select * from coverage;

--3c
select * from emergency;
insert into report values(1,101,'9899-01-01 10:00:00.000000');
select * from emergency;


delete from emergency where report_time='9899-01-01 10:00:00.000000';
delete from report where report_time='3318-01-01 10:00:00.000000';
delete from report where report_time='9899-01-01 10:00:00.000000';

--4 explicit
 create or replace procedure ListForestName1() as
 $$
     declare
         cur cursor for select forest_no,name from forest;
         name record;
     begin
         open cur;
         loop
             fetch cur into name;
             exit when not found;
             raise notice '%', name.name;
         end loop;
         close cur;
     end;
 $$ language plpgsql;

call listforestname1();

--4 implicit
 create or replace procedure ListForestName2() as
 $$
     declare
         curr record;
     begin
         for curr in (select * from forest) loop
             raise notice '%', curr.name;
         end loop;
     end;
 $$ language plpgsql;

call listforestname2();