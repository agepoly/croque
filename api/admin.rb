class Admin < Sinatra::Base
	get '/burger' do
		'Admin Site, get out!!'
	end

	set :port, 8080
	set :bind, '0.0.0.0'
	# run!
end
