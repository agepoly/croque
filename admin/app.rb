#!/usr/local/bin/ruby
require 'sinatra/base'
require 'rack/mount'
require 'sequel'
require 'date'

require './models'

class Admin < Sinatra::Base
  # Stats page
  get '/' do
    protected!
    erb :index, layout: :layout
  end

  # Login page
  get '/login' do
    erb :login, layout: :layout
  end

  # Login action
  post '/login' do
    if params[:login] == 'admin' && params[:password] == 'jaimelesburgers'
      # Session uses cookies to differenciate users
      session[:logged] = 'admin_true'
      redirect '/'
    else
      redirect '/login'
    end
  end

  # Listing of all questions
  get '/questions' do
    protected!
    # Queries all questions, in descending order
    @questions = Question.order(Sequel.desc(:id))
    erb :'questions/index', layout: :layout
  end

  # Adding a question
  post '/questions' do
    protected!
    Question.new(body: params[:question]).save if params[:question]
    redirect '/questions'
  end

  # See a specific question, to edit it
  get '/questions/:id' do
    protected!
    @q = Question[params[:id].to_i]
    if @q
      erb :'questions/edit', layout: :layout
    else
      redirect '/questions'
    end
  end

  # Edit a specific question
  post '/questions/:id' do
    protected!
    @q = Question[params[:id].to_i]
    @q.update(body: params[:question]).save if @q && params[:question]
    redirect '/questions'
  end

  # Delete a question
  get '/questions/:id/delete' do
    protected!
    @q = Question[params[:id].to_i]
    if @q
      Menu.where(questions: @q).each { |m| m.remove_question(@q) }
      Answer.where(question: @q).each(&:delete)
      @q.delete
    end
    redirect '/questions'
  end

  # Create an answer for a question
  post '/questions/:id/answers' do
    protected!
    @q = Question[params[:id].to_i]
    if @q
      if params[:body] != ""
        @q.add_answer(Answer.new(body: params[:body], place: params[:place] || 0, score: 0).save)
      end
    end
    redirect back
  end

  # Edit an answer
  post '/answers/:id' do
    protected!
    @a = Answer[params[:id].to_i]
    if @a
      if params[:body] != ""
        if params[:place] != ""
          @a.update(body: params[:body], place: params[:place])
        else
          @a.update(body: params[:body])
        end
			else
				if params[:place] != ""
          @a.update(place: params[:place])
				end
      end
    end
    redirect back
  end

  # Delete an answer
  get '/answers/:id/delete' do
    protected!
    @a = Answer[params[:id].to_i]
    @a.delete if @a
    redirect back
  end

  # Menu list for today and the ten days surounding it
  get '/menus' do
    protected!
    @today = Date.today
    @menus = [*-5..5].map do |i|
      {
        date: @today + i,
        menu: Menu.where(date: @today + i.to_i).first
      }
    end
    erb :'menus/index', layout: :layout
  end

  # This will create a new menu
  get '/menus/:date' do
    protected!
    if real_date? params[:date]
      unless Menu.where(date: Date.parse(params[:date])).first
        Menu.new(date: Date.parse(params[:date])).save
      end
      @menu = Menu.where(date: Date.parse(params[:date])).first
      erb :'menus/edit', layout: :layout
    else
      redirect '/menus'
    end
  end

  # Adding or deleting a question to a menu
  get '/menus/:date/questions/:id' do
    protected!
    if real_date? params[:date]
      @menu = Menu.where(date: Date.parse(params[:date])).first
      @question = Question[params[:id].to_i]
      if @menu && @question
        if !@menu.questions.include? @question
          @menu.add_question(@question)
        else
          @menu.remove_question(@question)
        end
        redirect "/menus/#{@menu.date}"
      end
    end
    redirect '/menus'
  end

  get '/tests' do
    protected!
    @requests = Lunchrequest.all
    @lunches = Lunch.where(date: Date.today)
    erb :'tests/index', layout: :layout
  end

  get '/tests/distribute' do
    protected!
    redirect back
  end

  helpers do
    # A protected page will only be available if you are authorized
    def protected!
      if authorized?
        true
      else
        halt 401, "401 - Not authorized. <a href=\"/login\">Login &raquo;</a>\n"
      end
    end

    # You are autorized if you have logged in
    def authorized?
      if session[:logged] == 'admin_true'
        true
      else
        false
      end
    end

    # Is this string a valid date ?
    def real_date?(date)
      Date.valid_date? *date.split('-').map(&:to_i)
    end
  end

  set :port, 8080
  set :bind, '0.0.0.0'
  # Using sessions
  use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'MANGER'
  run!
end
