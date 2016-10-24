class UserApp < Sinatra::Base
	# Creates a new user (temporary)
	post '/users' do
		@data = JSON.parse(request.body.read)
		@email = @data['email']
		@firstname = @data['firstname']
		@lastname = @data['lastname']
		@password = @data['password']
		if @email != nil && @firstname != nil && @lastname != nil && @password != nil
			# Adds a user to the database using the User object (see models.rb)
			User.new(:email => @email, :firstname => @firstname, :lastname => @lastname, :password => BCrypt::Password.create(@password)).save
			200
		else
			400
		end
	end

	# Lists all users (temporary)
	get '/users' do
		@out = ""
		User.each { |u| @out+=u.email+"<br/>" }
		@out
	end

	post '/users/login' do
		@data = JSON.parse(request.body.read)
		@email= @data['email']
		@password = @data['password']
		if @email != nil && @password != nil
			@user = User.where(:email => @email).first
			if @user
				if BCrypt::Password.new(@user.password) == @password
					session[:logged] = @user.id
					halt 200
				end
			end
			halt 401
		end
		halt 400
	end

	get '/users/me' do
		protected!
		session[:logged].to_s.to_json
	end

	# Get a tequila token
	get '/users/gettoken' do

	end

	# Confirm Login was done well and get info
  post '/users/checklogin' do
		@proxy = Net::HTTP.new('tequila.epfl.ch', 80)
		if params['key']
			@res = @proxy.post('/cgi-bin/tequila/fetchattributes', 'key='+params['key'])
			if @res.code == "200"
				puts @res.body
				return @res.body['name']
			else
				return 406
			end
		else
			return 406
		end
	end

	# Setting basic options
  set :port, 8080
  set :bind, '0.0.0.0'
	helpers HelpersApp
end
