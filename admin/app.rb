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
	post '/questions/:id/delete' do
		protected!
		@q = Question[params[:id].to_i]
		if @q
			@q.delete
		end
		redirect '/questions'
	end

	# This will list the menus, with a focus for today's menu
	get '/menus' do
		protected!
		erb :'menus/index', :layout => :'layout'
	end

	# This will create a new menu
	post '/menus' do
		protected!
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
	end

	set :port, 8080
	set :bind, '0.0.0.0'
	# Using sessions
	use Rack::Session::Cookie, :key => 'rack.session', :path => '/', :secret => 'MANGER'
	run!
end
