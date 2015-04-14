ENV['RACK_ENV'] = 'test'

require_relative '../todo'
require 'rspec'
require 'rack/test'

describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "signup and login in index" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match('Sign up')
    expect(last_response.body).to match('Log in')
  end
end