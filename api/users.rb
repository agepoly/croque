class UserApp < Sinatra::Base
	post '/users' do
		if params['sciper'] && params['email'] && params['firstname'] && params['lastname']
			User.new(:sciper => params['sciper'].to_i, :email => params['email'], :firstname => params['firstname'], :lastname => params['lastname']).save
			200
		else
			400
		end
	end

	get '/users' do
		@out = ""
		User.each { |u| @out+="x=>"+u.email+"<br/>" }
		@out
	end

	# Confirm Login was done well and get info
  post '/checklogin' do
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
	# enable :logging
  # Let's go !!
  # run!
end
