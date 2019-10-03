--Shibo Xing
--shx26

--1a
select name from forest
where acid_level>0.65 and acid_level<0.85;

--1b
select name from forest natural join coverage
where state='PA' and percentage>50;

--1c
select R.name from road as R natural join intersection as I inner join Forest as F
on I.forest_no = F.forest_no
where F.name='Allegheny National Forest';

--1d
select sensor_id, name from sensor left join worker
on sensor.maintainer = worker.ssn;

--1e
select least(A.state,B.state), greatest(A.state,B.state) from coverage as A inner join coverage as B
on A.forest_no=B.forest_no
where not A.state=B.state;

--1f
select F.name, count(R.sensor_id),avg(temperature) as avg_temp from (forest as F join sensor as S
on S.x between F.mbr_xmin and F.mbr_xmax and S.y between F.mbr_ymin and F.mbr_ymax)
                    inner join report as R on R.sensor_id=S.sensor_id
group by F.name
order by avg_temp desc;

--1g
select X,Y from sensor natural join report
where temperature = (select max(temperature) from report );

--1h
select distinct state from coverage as C1
where (select sum(percentage) from coverage as C2 where C1.state=C2.state)>30;

--1i
select distinct state from coverage as C
where (select sum(percentage) from coverage where state = C.state) >
      (select sum(percentage) from coverage where state='OH');

--1j
select name from forest
where name not in (select name from sensor natural join report join forest
    on X between mbr_xmin and mbr_xmax and Y between mbr_ymin and mbr_ymax
    where report_time between '2019-01-09 00:00:00' and '2019-01-11 23:59:59');


