class LunchApp < Sinatra::Base
	get '/lunches' do
	end

	post '/lunches' do
	end

	# Setting basic options
  set :port, 8080
  set :bind, '0.0.0.0'
end
