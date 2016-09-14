Sequel::Model.plugin :force_encoding, 'UTF-8'
DB = Sequel.connect('postgres://hello:coffee@db/')

class User < Sequel::Model
	many_to_many :lunches
end
User.unrestrict_primary_key

class Lunch < Sequel::Model
	many_to_many :users
end

class Question < Sequel::Model
end

class Menu < Sequel::Model
end

#if !Question.where(:date_asked => Date.today).first
#	Question.new(:date_asked => Date.today,
#							 :question_body => "Quelle est votre couleur  ?",
#							 :question_subject => "Les Couleurs").save
#end
