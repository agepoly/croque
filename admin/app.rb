#!/usr/local/bin/ruby
require 'sinatra/base'
require 'rack/mount'
require 'sequel'
require 'date'

require './models'

class Admin < Sinatra::Base
	get '/' do
		protected!
		erb :'index', :layout => :'layout'
	end

	get '/login' do
		erb :'login', :layout => :'layout'
	end

	post '/login' do
		if params[:login]=="admin" && params[:password]=="jaimelesburgers"
			session[:logged] = "admin_true"
			redirect '/'
		else
			redirect '/login'
		end
	end

	get '/menus' do
		protected!
		erb :'menus/index', :layout => :'layout'
	end

	get '/questions' do
		protected!
		@questions = Question.order(Sequel.desc(:id))
		erb :'questions/index', :layout => :'layout'
	end

	post '/questions' do
		protected!
		if params[:question]
			Question.new(:body => params[:question]).save
		end
		redirect '/questions'
	end

	get '/questions/:id' do
		protected!
		@q = Question[params[:id].to_i]
		if @q
			erb :'questions/edit', :layout => :'layout'
		else
			redirect '/questions'
		end
	end

	post '/questions/:id' do
		protected!
		@q = Question[params[:id].to_i]
		if @q && params[:question]
			@q.update(:body => params[:question]).save
		end
		redirect '/questions'
	end

	post '/questions/:id/delete' do
		protected!
		@q = Question[params[:id].to_i]
		if @q
			@q.delete
		end
		redirect '/questions'
	end

	get '/menus' do
		protected!
		erb :'menus/index', :layout => :'layout'
	end

	post '/menus' do
		protected!
	end

	helpers do
		def protected!
			if authorized?
				true
			else
				halt 401, "401 - Not authorized. <a href=\"/login\">Login &raquo;</a>\n"
			end
		end

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
	use Rack::Session::Cookie, :key => 'rack.session', :path => '/', :secret => 'MANGER'
	run!
end
