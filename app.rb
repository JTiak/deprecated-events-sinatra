# app.rb
require 'sinatra'
require 'sinatra/reloader' if development?
require 'mongoid'
require_relative 'models/event'
require_relative 'serializers/events'
require_relative 'errors'
require_relative 'controllers/events'

project_root = File.dirname(__FILE__)
Mongoid.load!(File.join(project_root, 'config', 'mongoid.yml'))

set :default_content_type, :json

get '/status' do
  "status: ok"
end

def require_authentication!
  halt(401, UnauthorizedError.new().to_json) unless authenicated?
end

def authenicated?
  auth_header = request.env['HTTP_AUTHORIZATION']
  if auth_header&.starts_with?('Bearer ') && auth_header.split(' ')[1] == ENV['ACCESS_TOKEN']
    return true
  end
  false
end
