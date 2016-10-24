create table users (
	id serial primary key,
	firstname varchar(16) not null,
	lastname varchar(16) not null,
	email text not null unique,
	password text not null,
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
	question_id integer references questions,
	body text,
	place integer,
	score integer
);

create table lunches (
	lunch_id serial primary key,
	time integer,
	date date not null
);

create table lunches_users (
	user_id integer references users,
	lunch_id integer references lunches
);

create table lunchrequests (
	id serial primary key,
	time integer,
	user_id integer references users
);

create table menus_questions (
	menu_id integer references menus,
	question_id integer references questions
);

create table answers_lunchrequests (
	lunchrequest_id integer references lunchrequests,
	answer_id integer references answers
);

create table distributions (
	id serial primary key,
	size integer unique not null,
	proportion integer
);
