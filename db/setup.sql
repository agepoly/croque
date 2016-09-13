create table users (
	sciper integer primary key,
	firstname varchar(16) not null,
	lastname varchar(16) not null,
	email text not null unique,
	description integer[]
);
create index user_index on users (sciper)

create table questions (
	id integer primary key,
	question_body text,
	answers text[]
);
create index question_index on questions (id)

create table daily (
	date_asked date primary key,
	question_id, integer not null,
	
	foreign key (question_id) references questions(id)
);
create index daily_index on daily (date_asked)

create answers (
	date_asked date,
	user_id integer,
	answer varchar(200) not null,
	
	foreign key (date_asked) references daily(date_asked),
	foreign key (user_id) references users(id),
	primary key (date_asked, user_id)
);
create index answers_index on answers (date_asked, user_id)

create table lunch_groups (

	id serial primary key,
	date date not null;
	user_id_1 integer not null,
	user_id_2 integer not null,
	user_id_3 integer,
	user_id_4 integer,
	
	foreign key (date) references daily (date_asked),
	foreign key (user_id_1) references questions (id),
	foreign key (user_id_2) references questions (id),
	foreign key (user_id_3) references questions (id),
	foreign key (user_id_4) references questions (id),
	
);
# Maybe we should create an index on each usersid as we will often be searching through them 

create table messages (
	id serial primary key,
	lunch_group_id integer not null,
	time date not null,
	expeditor_id integer not null,
	message text,
	
	foreign key (lunch_group_id) references lunch_groups (id),
	foreign key (expeditor_id) references users (id),
	
);
create index messages_index on messages (lunch_group_id)
