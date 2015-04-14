ENV['RACK_ENV'] = 'test'

require_relative '../todo'
require 'test/unit'
require 'rack/test'

class TodoTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    @valid_user = { name: 'test', password: 'test' }
    @invalid_user = { name: 'test20', password: 'test20' }
  end

  test "should match signup and login in index" do
    get '/'
    assert last_response.ok?
    assert_match 'Sign up', last_response.body
    assert_match 'Log in', last_response.body
  end

  test "should redirect to index when visit todo without login" do
    get '/todo'
    follow_redirect!
    assert_match 'Sign up', last_response.body
    assert_match 'Log in', last_response.body
  end

  test "should redirect to index when login as invalid user" do
    post '/login', @invalid_user
    follow_redirect!
    assert_match 'Sign up', last_response.body
    assert_match 'Log in', last_response.body
  end

  test "should redirect to todo when login as valid user" do
    post '/login', @valid_user
    follow_redirect!
    assert_match 'TODO', last_response.body
    assert_match 'test', last_response.body
  end

  test "user name should be unique" do
    assert !User.new(@valid_user).valid?
    assert  User.new(@invalid_user).valid?
  end
end