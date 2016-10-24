class LunchApp < Sinatra::Base
  get '/lunches' do
    protected!
    @lunch = User[session[:logged]].lunches_dataset.where(date: Date.today).first
    if @lunch
      {id: @lunch.id, users: @lunch.users}.to_json
    else
      "No lunch prepared yet".to_json
    end
  end

  post '/lunches' do
    protected!
    @data = JSON.parse(request.body.read)
    @time = @data['time']
    @answers = @data['answers']
    if @time != nil && @answers != nil && @answers != [] && !Lunchrequest.where(user_id: session[:logged]).first && !User[session[:logged]].lunches_dataset.where(date: Date.today).first
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

  # Setting basic options
  set :port, 8080
  set :bind, '0.0.0.0'
	helpers HelpersApp
end
