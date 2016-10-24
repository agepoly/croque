class PublicApp < Sinatra::Base
	# Gives the menu for the day
	get '/' do
		@menu = Menu.where(:date => Date.today).first
		if @menu
			@menu.questions.map{ |q|
				{
					id: q.id,
					body: q.body,
					answers: q.answers.map{|a| {place: a.place, body: a.body}}
				}
			}.to_json
		else
			"CLOSED".to_json
		end
	end

	# Setting basic options
	set :port, 8080
	set :bind, '0.0.0.0'
end
