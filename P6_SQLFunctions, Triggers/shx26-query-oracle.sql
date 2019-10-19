--Shibo Xing
--shx26

--1a
 create or replace procedure proUpdateLastRead(input_sensor_id int, read_time timestamp)
 as
     begin
         update sensor
         set last_read=read_time
         where sensor_id=input_sensor_id;
     end;
/
commit;

--1b
create or replace function fun_Compute_Percentage (input_forest_no in varchar2, area_covered in float)
     return float as
     res float:=0.0;
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
/
commit;

--2a
create or replace trigger tri_Last_Read
after insert on report for each row
    begin
        proUpdateLastRead(:new.SENSOR_ID,:new.REPORT_TIME);
    end;
/
commit;


--2b
create or replace trigger tri_Percentage
before update on coverage for each row
    begin
        :new.percentage :=fun_Compute_Percentage(:new.FOREST_NO,:new.AREA);
    end;
/
commit;

--2c
create or replace trigger tri_Emergency
after insert on report for each row when(new.temperature>100)
begin
    insert into emergency
    values(:new.sensor_id,:new.report_time);
end;
/
commit;

--3a
select * from sensor;
insert into report values(1,55,'01-JAN-3000 10:00:00.000000');
select * from sensor;

--3b
select * from coverage;
update coverage set area=5000 where forest_no='2' and state='PA';
select * from coverage;

--3c
select * from emergency;
insert into report values(1,101,'01-JAN-9000 10:00:00.000000');
select * from emergency;

delete from emergency where report_time='01-JAN-9000 10:00:00.000000';
update coverage set area=10000 where forest_no='2' and state='PA';
delete from report where report_time='01-JAN-3000 10:00:00.000000';
delete from report where report_time='01-JAN-9000 10:00:00.000000';

--4 explicit
 create or replace procedure ListForestName1 as
    cursor cur is select forest_no,name from forest;
    f_row cur%rowtype;
     begin
         open cur;
         loop
             fetch cur into f_row;
             exit when cur%notfound;
             dbms_output.put_line(f_row.name);
         end loop;
         close cur;
     end;
/
call listforestname1();

--4 implicit
 create or replace procedure ListForestName2 as
     begin
         for f_row in (select * from forest) loop
             dbms_output.put_line(f_row.name);
         end loop;
     end;
/
call listforestname2();



