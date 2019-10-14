--1a
create or replace function proUpdateLastRead(input_sensor_id int, read_time timestamptz)
    returns void as
$$
    begin
        update sensor
        set last_read=read_time
        where sensor_id=input_sensor_id;
    end;
$$ language plpgsql;
commit;
--select proUpdateLastRead(1, to_timestamp('01-DEC-1567 00:00:00', 'DD-MON-YYYY HH24:MI:SS'));

--1b
create or replace function fun_Compute_Percentage(input_forest_no char(10), area_covered float)
    returns float as
$$
    declare
        res float:=.0;
    begin
        select area_covered/area
        into res
        from forest
        where forest_no=input_forest_no;

        return res;
    end;
$$ language plpgsql;

--select fun_Computer_Percentage('1',16000.0);

--2a
drop trigger if exists trig_Last_Read on report;
create trigger trig_Last_Read
    after insert
    on report
    for each statement
execute procedure proUpdateLastRead( new.sensor_id,  new.report_time );

--2b
--drop trigger if exists


drop function proupdatelastread(input_sensor_id integer, last_read timestamptz);
drop function fun_compute_percentage(input_forest_no char, area_covered float);