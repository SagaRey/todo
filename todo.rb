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

# session
use Rack::Session::Pool, :expire_after => 2592000

# routes
get '/' do
  erb :index, layout: !request.xhr?
end

get '/todo' do
  if session['user_id'].nil?
    redirect to '/'
  else
    @user = User.find(session['user_id'])
    erb :todo, layout: !request.xhr?
  end
end

post '/signup' do
  name = params['name']
  password = params['password']
  repassword = params['repassword']
  if User.where('name = ?', name).count < 1 && password == repassword
    User.create!( name: name,
                  password: password,
                  updated_at: Time.now.utc,
                  created_at: Time.now.utc )
    session['user_id'] = User.where('name = ?', name).first.id
    redirect to '/todo'
  else
    redirect to '/?error=signup'
  end
end

post '/login' do
  name = params['name']
  password = params['password']
  if User.where('name = ?', name).count < 1 || User.where('name = ?', name).first.password != password
    redirect to '/?error=login'
  else
    session['user_id'] = User.where('name = ?', name).first.id
    redirect to '/todo'
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect to '/'
end