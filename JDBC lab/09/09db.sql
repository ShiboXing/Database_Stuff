drop schema if exists recitation9 cascade;
create schema recitation9;

drop table if exists recitation9.users cascade;
create table recitation9.users
(
	username varchar(50)
		constraint users_pk
			primary key,
	password varchar(50) not null
);

INSERT INTO recitation9.users (username, password) VALUES ('costas', 'secretpassword');
INSERT INTO recitation9.users (username, password) VALUES ('panos', 'strongpassword');

drop table if exists recitation9.student cascade;
create table recitation9.student
(
    sid   varchar(5)  not null
        constraint pk_student
            primary key,
    name  varchar(15) not null,
    class integer,
    major varchar(10)
);

INSERT INTO recitation9.student (sid, name, class, major) VALUES ('123', 'John', 3, 'CS');
INSERT INTO recitation9.student (sid, name, class, major) VALUES ('124', 'Mary', 3, 'CS');
INSERT INTO recitation9.student (sid, name, class, major) VALUES ('126', 'Sam', 2, 'CS');
INSERT INTO recitation9.student (sid, name, class, major) VALUES ('129', 'Julie', 2, 'Math');
INSERT INTO recitation9.student (sid, name, class, major) VALUES ('11', 'costa', 3, 'CS');

drop table if exists recitation9.class cascade;
create table recitation9.class
(
  classid          int,
  max_num_students int,
  cur_num_students int,
  primary key (classid)
);

drop table if exists recitation9.register cascade;
create table recitation9.register
(
  student_name    varchar(10),
  classid         int,
  date_registered date,
  primary key (student_name, classid),
  foreign key (classid) references recitation9.class (classid)
);

insert into recitation9.class
values (1, 2, 1);
insert into recitation9.class
values (2, 4, 0);

insert into recitation9.register
values ('Mary', 1, '03-JAN-2012');
