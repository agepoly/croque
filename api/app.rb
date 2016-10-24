#!/usr/local/bin/ruby
require 'sinatra/base'
require 'rack/mount'
require 'net/http'
require 'sequel'
require 'date'
require 'json'
require 'bcrypt'
require 'rufus-scheduler'

require './helpers'
require './models'
require './users'
require './lunches'
require './public'

class Routes < Sinatra::Base
  get('/users*') { UserApp.call(env) }
  post('/users*') { UserApp.call(env) }
  get('/lunches*') { LunchApp.call(env) }
  post('/lunches*') { LunchApp.call(env) }
  get('/*') { PublicApp.call(env) }
  post('/*') { PublicApp.call(env) }

	use Rack::Session::Cookie, :key => 'rack.session', :path => '/', :secret => 'BURGERRR'
  set :port, 8080
  set :bind, '0.0.0.0'
  run!
end
