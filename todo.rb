require 'sinatra'
require 'active_record'
require 'bcrypt'
require 'sqlite3'

# models
require './models/user'
require './models/todolist'

# database
config = YAML.load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(config)

# session
use Rack::Session::Pool, :expire_after => 2592000

# routes
get '/' do
  erb :index, layout: !request.xhr?
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

get '/todo' do
  redirect to '/' if session['user_id'].nil?
  @user = User.find(session['user_id'])
  @todolists = @user.todolists.where('status in (?)', ['actived', 'completed'])
  @count = @todolists.count
  @left_items = @todolists.where('status = ?', 'actived').count
  erb :todo, layout: !request.xhr?
end

post '/todo' do
  redirect to '/' if session['user_id'].nil?
  content = params['content']
  return if content.blank?
  user = User.find(session['user_id'])
  user.todolists.create!(
    content: content,
    status: 'actived',
    updated_at: Time.now.utc,
    created_at: Time.now.utc )
  user.todolists.where('status in (?)', ['actived', 'completed']).count.to_s
end

put '/todo' do
  redirect to '/' if session['user_id'].nil?
  todolist_id = params['todolist_id']
  return if todolist_id.blank?
  todolist = Todolist.find(todolist_id)
  if todolist.status == 'completed'
    todolist.update_attribute(:status, 'actived')
  elsif todolist.status == 'actived'
    todolist.update_attribute(:status, 'completed')
  end
end

delete '/todo' do
  redirect to '/' if session['user_id'].nil?
  todolist_id = params['todolist_id']
  return if todolist_id.blank?
  user = User.find(session['user_id'])
  todolists = user.todolists.where('status = ?', 'completed')
  if todolist_id == 'ids'
    todolists.each do |todo|
      todo.update_attribute(:status, 'deleted')
    end
  else
    Todolist.find(todolist_id).update_attribute(:status, 'deleted')
  end
  user.todolists.where('status in (?)', ['actived', 'completed']).count.to_s
end