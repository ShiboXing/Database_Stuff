-- assume pittID is unique, every personnel has a fname and lname
create table tech_personnel(
    pplSoft int not null,
    fname varchar2(10) not null,
    lname varchar2(10) not null,
    pittID varchar2(10) not null,
    expertise varchar2(10),
    office_phone int,
    constraint tech_personnel_pk primary key (pplSoft) deferrable,
    constraint tech_personnel_unique unique(pittID) initially deferred deferrable
);

-- assume pittID is unique, every user has a fname and lname
create table users(
    pplSoft int not null,
    fname int not null,
    lname int not null,
    pittID int not null,
    office_phone int,
    constraint user_pk primary key (pplSoft) deferrable,
    constraint users_unique unique(pittID) initially deferred deferrable
);

--assume building name is unique
create table user_office(
    office_no int not null,
    building varchar2(50),
    constraint user_office_pk primary key (office_no) deferrable,
    constraint user_office_unique unique(building) initially deferred deferrable
);
--
-- create table categories(
--
-- );


drop table tech_personnel;
drop table user_office;


