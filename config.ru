require File.join(File.dirname(__FILE__), 'application')

set :run, false

if ENV['RACK_ENV']
  set :environment, ENV['RACK_ENV']
else
  set :environment, :develop
end

run Sinatra::Application
