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
		erb :'index', :layout => :'layout'
	end

	# Login page
	get '/login' do
		erb :'login', :layout => :'layout'
	end

	# Login action
	post '/login' do
		if params[:login]=="admin" && params[:password]=="jaimelesburgers"
			# Session uses cookies to differenciate users
			session[:logged] = "admin_true"
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
		erb :'questions/index', :layout => :'layout'
	end

	# Adding a question
	post '/questions' do
		protected!
		if params[:question]
			Question.new(:body => params[:question]).save
		end
		redirect '/questions'
	end

	# See a specific question, to edit it
	get '/questions/:id' do
		protected!
		@q = Question[params[:id].to_i]
		if @q
			erb :'questions/edit', :layout => :'layout'
		else
			redirect '/questions'
		end
	end

	# Edit a specific question
	post '/questions/:id' do
		protected!
		@q = Question[params[:id].to_i]
		if @q && params[:question]
			@q.update(:body => params[:question]).save
		end
		redirect '/questions'
	end

	# Delete a question
	get '/questions/:id/delete' do
		protected!
		@q = Question[params[:id].to_i]
		if @q
			Menu.where(:questions => @q).each{|m| m.remove_question(@q)}
			# Same for answers
			@q.delete
		end
		redirect '/questions'
	end

	# Menu list for today and the ten days surounding it
	get '/menus' do
		protected!
		@today = Date.today
		@menus = [*-5..5].map{|i|
			{
				:date => @today + i,
				:menu => Menu.where(:date => @today + i.to_i).first
			}
		}
		erb :'menus/index', :layout => :'layout'
	end

	# This will create a new menu
	get '/menus/:date' do
		protected!
		if real_date? params[:date]
			if !Menu.where(:date => Date.parse(params[:date])).first
				Menu.new(:date => Date.parse(params[:date])).save
			end
			@menu = Menu.where(:date => Date.parse(params[:date])).first
			erb :'menus/edit', :layout => :'layout'
		else
			redirect '/menus'
		end
	end

	get '/menus/:date/questions/:id' do
		protected!
		if real_date? params[:date]
			@menu = Menu.where(:date => Date.parse(params[:date])).first
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
			if session[:logged] == "admin_true"
				true
			else
				false
			end
		end

		def real_date? date
			return Date.valid_date? *date.split("-").map{|i| i.to_i}
		end

	end

	set :port, 8080
	set :bind, '0.0.0.0'
	# Using sessions
	use Rack::Session::Cookie, :key => 'rack.session', :path => '/', :secret => 'MANGER'
	run!
end
