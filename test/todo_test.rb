ENV['RACK_ENV'] = 'test'

require_relative '../todo'
require 'test/unit'
require 'rack/test'

class TodoTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  test "should match signup and login in index" do
    get '/'
    assert last_response.ok?
    assert_match 'Sign up', last_response.body
    assert_match 'Log in', last_response.body
  end
end