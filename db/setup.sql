create table users (
	sciper integer primary key,
	firstname varchar(16) not null,
	lastname varchar(16) not null,
	email text not null unique,
	description integer[]
);

create table menus (
	id serial primary key,
	date date unique
);

create table questions (
	id serial primary key,
	body text
);

create table answers (
	id serial primary key,
	question integer references questions,
	body text,
	place integer,
	score integer
);

create table lunches (
	lunch_id serial primary key,
	date date not null
);

create table lunch_user (
	user_id integer references users,
	lunch_id integer references lunches
);

create table menu_question (
	menu_id integer references menus,
	question_id integer references questions
);
