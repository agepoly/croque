# Sequel => access to database

Sequel::Model.plugin :force_encoding, 'UTF-8'
DB = Sequel.connect('postgres://hello:coffee@db/')

class User < Sequel::Model
	many_to_many :lunches
end
User.unrestrict_primary_key

class Lunch < Sequel::Model
	many_to_many :users
end

class Lunchrequest < Sequel::Model
	many_to_many :answers
end

class Question < Sequel::Model
	many_to_many :menus
	one_to_many :answers
end

class Answer < Sequel::Model
	many_to_one :question
	many_to_many :lunchrequests
end

class Menu < Sequel::Model
	many_to_many :questions
end
