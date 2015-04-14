ENV['RACK_ENV'] = 'test'

require_relative '../todo'
require 'rspec'
require 'rack/test'

describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match('Sign up')
    expect(last_response.body).to match('Log in')
  end
end

describe "POST #create" do
  context "with valid attributes" do
    it "saves the new xxx in the database"
    it "redirects to xxx#show"
  end
end