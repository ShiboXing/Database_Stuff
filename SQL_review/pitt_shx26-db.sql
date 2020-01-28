
-- assume pittID is unique, every personnel has a fname and lname
create table tech_personnel(
    pplSoft int not null,
    fname varchar2(10) not null,
    lname varchar2(10) not null,
    pittID varchar2(10) not null,
    expertise varchar2(10),
    office_phone int,
    constraint tech_personnel_pk primary key (pplSoft) deferrable,
    constraint tech_personnel_unique unique(pittID) initially immediate deferrable,
    constraint tech_personnel_fk foreign key(office_phone) references user_office(office_phone) initially deferred deferrable
);

-- assume pittID is unique, every user has a fname and lname
create table users(
    pplSoft int not null,
    fname int not null,
    lname int not null,
    pittID int not null,
    office_phone int,
    constraint user_pk primary key (pplSoft) deferrable,
    constraint users_unique unique(pittID) initially immediate deferrable
);

--assume office_no and building name are unique
create table user_office(
    office_no int not null,
    building varchar2(50),
    constraint user_office_pk primary key (office_no) deferrable,
    constraint user_office_unique unique(building) initially immediate deferrable
);

--assume category id and category are unique
create table categories(
    category_id int not null,
    category varchar(20) not null,
    description varchar(100),
    constraint categories_pk primary key (category_id) deferrable,
    constraint categories_unique unique(category) initially immediate deferrable
);

--assume machine name and MACADDR are unique
create table inventory(
    machine_name varchar2(20) not null,
    IP int,
    network_port int,
    MACADDR int not null,
    location_id int,
    constraint inventory_pk primary key(machine_name) deferrable,
    constraint inventory_unique unique(MACADDR) initially immediate deferrable
);

--assume location id  and location are unique
create table locations(
    location_id varchar2(20) not null,
    location varchar2(20) not null,
    building varchar2(10),
    notes varchar2(100),
    constraint locations_pk primary key(location_id) deferrable,
    constraint locations_unique unique(location) initially immediate deferrable
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
    description varchar2(100),
    constraint tickets_pk primary key (ticket_number) deferrable,
    constraint tickets_fk1 foreign key (category_id) references categories(category_id) initially deferred deferrable,
    constraint tickets_fk2 foreign key (machine_name) references inventory(machine_name) initially deferred deferrable
);


create table assignment (
    ticket_number varchar2(20) not null,
    tech_pplSoft int not null,
    date_assigned timestamp not null,
    status varchar2(10) not null,
    outcome varchar2(20) not null,
    constraint assignment_pk primary key (ticket_number) deferrable,
    constraint assignment_fk foreign key (tech_pplSoft) references tech_personnel(tech_pplSoft) initially deferrable deferrable
);


drop table tech_personnel;
drop table user_office;
drop table categories;
drop table inventory;
drop table locations;
drop table tickets;
drop table assignment;



