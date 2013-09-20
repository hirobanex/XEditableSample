CREATE TABLE user (
  id         INTEGER PRIMARY KEY,
  name       varchar(10),
  sex        varchar(10) default 'male',
  age        INTEGER,
  birth_date  date
);

insert into user (id,name,sex,age,birth_date) values(1,"hirobanex","male",30,"1980-10-22");
insert into user (id,name,sex,age,birth_date) values(2,"papix","male",30,"1980-10-22");
insert into user (id,name,sex,age,birth_date) values(3,"uzulla","male",30,"1980-10-22");
insert into user (id,name,sex,age,birth_date) values(4,"ytnobody","male",30,"1980-10-22");
insert into user (id,name,sex,age,birth_date) values(5,"moznion","male",30,"1990-10-22");
insert into user (id,name,sex,age,birth_date) values(6,"macopy","male",30,"1990-10-22");
