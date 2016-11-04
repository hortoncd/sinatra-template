require 'spec_helper.rb'

require 'rack/test'

require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara::DSL
end

include Rack::Test::Methods

require_relative '../application.rb'

def app
  Sinatra::Application
end

Capybara.app = Sinatra::Application

set :environment, :test
