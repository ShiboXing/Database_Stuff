select S.sensor_id from sensor as S join report as R
on S.sensor_id = R.sensor_id
group by S.sensor_id
order by count(R.sensor_id) desc
limit 3;

select S.sensor_id from sensor as S join report as R
on S.sensor_id = R.sensor_id
group by S.sensor_id
order by count(R.sensor_id) desc
offset 3 row
fetch next 2 rows only;
