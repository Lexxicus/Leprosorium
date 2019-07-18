#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'

def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.result_as_hash = true
end

before do
  init_db
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/New' do
  erb :New
end

get '/Posts' do
  erb "Hello World"
end

post '/New' do
  @content = params[:newpost]
  erb "You typed: #{@content}"
end