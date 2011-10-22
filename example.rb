#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require 'fichteid-client'

enable :sessions

helpers do
  def client
    Fichteid::Client.new 'mypw', session, :site => 'http://titan:9292'
  end
end

get '/' do
  return_to = "http://#{request.host_with_port}/complete"
  realm = "http://#{request.host_with_port}"
  
  redirect client.redirect_url :return_to => return_to, :realm => realm
end

get '/complete' do
  begin
    info = client.complete(params, request.url)
    raise "yep, that worked. user data: #{info.inspect}"
  rescue Fichteid::Client::AuthenticationFailed
    raise "authentication failed."
  end
end
