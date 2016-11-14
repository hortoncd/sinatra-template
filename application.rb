require 'sinatra'
require_relative 'lib/sinatra-template'

module AppHelpers
  def escape(m)
    Rack::Utils.escape_html(m)
  end
end

set :title, 'Sinatra Template'
set :pages, [
  {
    'name' => 'about',
    'link' => '/about',
    'title' => 'About',
    'erb' => 'page',
    'content' => "About #{settings.title}"
  },
  {
    'name' => 'contact',
    'link' => '/contact',
    'title' => 'Contact',
    'erb' => 'page',
    'content' => 'Contact Us by <a href="mailto:fakeemail@fakedomain.fakeyfake?Subject=Hello%20Fake" target="_top">email.</a>'
  },
]

helpers AppHelpers

configure :production, :development do
  enable :logging
end

get '/' do
  @title = settings.title
  @navbar_brand = settings.title
  erb :main
end

# Setup routes for all of the different pages
settings.pages.each do |p|
  get p['link'] do
    @title = p['title']
    @navbar_brand = settings.title
    @action = p['name']
    @content = p['content']
    erb p['erb'].to_sym
  end

  post p['link'] do
    @title = p['title']
    @navbar_brand = settings.title
    @action = p['name']
    @content = p['content']
    erb p['erb'].to_sym
  end
end

not_found do
  @title = "Error: 404"
  @navbar_brand = settings.title
  @content= "This is not the page you're looking for (hand-waviness here)"
  erb :error
end
