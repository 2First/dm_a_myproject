create table books(
    id int not null auto_increment primary key,
    isbn varchar(200) not null,
    openid varchar (500) not null,
    title varchar (1000) not null,
    image varchar (1000),
    alt varchar (1000) not null,
    publisher varchar (1000) not null,
    summary varchar (10000) not null,
    price varchar (1000),
    rate float,
    tags varchar(1000),
    author varchar(1000)
)


create table comments(
    id int not null auto_increment primary key,
    openid varchar(100) not null,
    bookid varchar(10) not null,
    comment varchar(200) not null,
    phone varchar(50),
    location varchar(50)
)