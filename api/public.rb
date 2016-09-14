class PublicApp < Sinatra::Base
	# Gives the menu for the day
	get '/' do
		@menu = Menu.where(:date => Date.today).first
		if @menu
			"There is hope".to_json
		else
			{:subject => "Pas Disponible"}.to_json
		end
	end

	# Setting basic options
	set :port, 8080
	set :bind, '0.0.0.0'
end
