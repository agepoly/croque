create table users (
	sciper integer primary key,
	firstname varchar(16) not null,
	lastname varchar(16) not null,
	email text not null unique,
	description integer[]
);

create table questions (
	date_asked date not null,
	question_body text,
	answers text[]
);

create table lunches (
	lunch_id serial primary key,
	date date not null
);

create table lunch_user (
	user_id integer references users,
	lunch_id integer references lunches
);

create table subjects (
	subject_id serial primary key,
	body text not null
);
