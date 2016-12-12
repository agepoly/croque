class LunchApp < Sinatra::Base
  get '/lunch' do
    protected!
    @lunch = User[session[:logged]].lunches_dataset.where(date: Date.today).first
    if @lunch
      {id: @lunch[:lunch_id], users: @lunch.users.map{|u| {id: u[:id], name: getDescription(u[:description])}}}.to_json
    else
      "No lunch prepared yet".to_json
    end
  end

  post '/lunch' do
    protected!
    @data = JSON.parse(request.body.read)
    @time = @data['time']
    @answers = @data['answers']
		if @time == nil
			halt 400, 'time must not be empty'
		elsif !([11, 12, 13].include? @time.to_i)
			halt 400, 'time must be 11, 12 or 13'
		end
		if @answers != nil && @answers != [] && !Lunchrequest.where(user_id: session[:logged]).first && !User[session[:logged]].lunches_dataset.where(date: Date.today).first
      @lr = Lunchrequest.new(time: @time.to_i, user_id: session[:logged]).save
      @answers.each {|a|
        if Answer[a]
          @lr.add_answer(Answer[a])
        end
      }
      200
    else
      400
    end
  end

  get '/lunches' do
    protected!
    @lunches = User[session[:logged]].lunches_dataset.all
    @lunches.to_json
  end

  # Setting basic options
  set :port, 8080
  set :bind, '0.0.0.0'
	helpers HelpersApp
end
