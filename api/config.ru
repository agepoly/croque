require 'sinatra/base'
require 'rack/mount'
require 'net/http'
require 'sequel'

require './models'
require './app'
require './admin'

Routes = Rack::Mount::RouteSet.new do |set|
	set.add_route App, :path_info => %r{^/api$}
	set.add_route Admin, :path_info => %r{^/burger$}
end

run Routes
