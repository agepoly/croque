DB = Sequel.connect('postgres://hello:coffee@db/')

class User < Sequel::Model
	many_to_many :lunches
end
User.unrestrict_primary_key

#class Lunch < Sequel::Model
#	many_to_many :users
#end

