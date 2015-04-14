require 'sinatra'
require 'active_record'
require 'bcrypt'
require 'sqlite3'

# models
require_relative 'models/user'
require_relative 'models/todolist'

# database
config = YAML.load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(config)

# routes
get '/' do
  erb :index, layout: !request.xhr?
end

get '/todo' do
  erb :todo, layout: !request.xhr?
end

post '/signup' do
  erb :index, layout: !request.xhr?
end

post '/login' do
  erb :index, layout: !request.xhr?
end