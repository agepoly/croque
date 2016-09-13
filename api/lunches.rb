class LunchApp < Sinatra::Base
	post '/lunches' do
	end

	get '/lunches' do
	end

	# Setting basic options
  set :port, 8080
  set :bind, '0.0.0.0'
	# enable :logging
  # Let's go !!
  # run!
end
