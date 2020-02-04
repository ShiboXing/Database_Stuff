--Shibo Xing
--shx26

commit;
drop table tech_personnel cascade constraints;
drop table assignment cascade constraints;
drop table users cascade constraints;
drop table user_office cascade constraints;
drop table categories cascade constraints;
drop table inventory cascade constraints;
drop table locations cascade constraints;
drop table tickets cascade constraints;

-- Question #1:
set transaction read write name 'create db';
-- assume pittID is unique, every personnel has a fname and lname
create table tech_personnel(
    pplSoft int not null,
    fname varchar2(20) not null,
    lname varchar2(20) not null,
    pittID varchar2(10) not null,
    expertise varchar2(20),
    office_phone varchar2(20),
    constraint tech_personnel_pk primary key (pplSoft) deferrable,
    constraint tech_personnel_unique unique(pittID) initially immediate deferrable
);

-- assume pittID is unique, every user has a fname and lname
create table users(
    pplSoft int not null,
    fname varchar2(20) not null,
    lname varchar2(20) not null,
    pittID varchar2(10) not null,
    office_phone varchar2(20),
    constraint user_pk primary key (pplSoft) deferrable,
    constraint users_unique unique(pittID) initially immediate deferrable
);

--assume office_no and building name are unique
create table user_office(
    office_no int not null,
    building varchar2(50),
    constraint pk_user_office primary key (office_no, building) deferrable,
    constraint user_office_unique unique(building) initially immediate deferrable
);

--assume category id and category are unique
create table categories(
    category_id int not null,
    category varchar(50) not null,
    description varchar(500),
    constraint categories_pk primary key (category_id) deferrable,
    constraint categories_unique unique(category) initially immediate deferrable
);

--assume machine name and MACADDR are unique
create table inventory(
    machine_name varchar2(20) not null,
    ip varchar2(15),
    network_port varchar2(20),
    MACADDR varchar2(50),
    location_id int,
    constraint inventory_pk primary key(machine_name) deferrable,
    constraint inventory_unique unique(MACADDR) initially immediate deferrable
);

--assume location id is unique
create table locations(
    location_id int not null,
    location varchar2(20),
    building varchar2(10),
    notes varchar2(200),
    constraint locations_pk primary key(location_id) deferrable
);

--assume ticket_number is unique
create table tickets(
    ticket_number varchar2(20) not null,
    owner_pplSoft int not null,
    date_submitted timestamp,
    date_closed timestamp,
    days_worked_on int,
    category_id int not null,
    machine_name varchar2(20) not null,
    description varchar2(500),
    constraint tickets_pk primary key (ticket_number) deferrable,
    constraint tickets_fk1 foreign key (owner_pplSoft) references users(pplSoft) initially deferred deferrable,
    constraint tickets_fk2 foreign key (category_id) references categories(category_id) initially deferred deferrable,
    constraint tickets_fk3 foreign key (machine_name) references inventory(machine_name) initially deferred deferrable
);

-- assume that one ticket cannot be assigned to one personnel twice
create table assignment (
    ticket_number varchar2(20) not null,
    tech_pplSoft int not null,
    date_assigned timestamp not null,
    status varchar2(50) not null,
    outcome varchar2(100),
    constraint assignment_pk primary key (ticket_number, tech_pplSoft) deferrable,
    constraint assignment_fk foreign key (tech_pplSoft) references tech_personnel(pplSoft) initially deferred deferrable
);

alter table inventory
    add constraint inventory_fk1 foreign key (location_id) references locations(location_id) initially deferred deferrable;

commit;

-- 2.a
alter table tickets
    modify days_worked_on default 0;
-- 2.b
alter table tickets
    add constraint tickets_check check (days_worked_on >= 0 ) initially immediate deferrable;
-- 2.c
alter table tech_personnel
    add super_pplSoft int default 1110001 not null
    add constraint tech_personnel_fk2 foreign key (super_pplSoft) references tech_personnel(pplSoft) initially deferred deferrable;
-- 2.d
-- TODO: ask senpai how to replace primary key
alter table user_office
    add pplSoft int
    add constraint fk_user_office foreign key (pplSoft) references users (pplSoft) not deferrable;
-- alter table user_office
--     drop constraint pk_user_office;
-- alter table user_office
--     add constraint user_office_pk primary key (office_no, pplSoft, building) deferrable;

-- 2.e
alter table user_office
    drop constraint fk_user_office;
alter table user_office
    add constraint fk_user_office foreign key (pplSoft) references users (pplSoft) deferrable;

