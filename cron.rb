#!`which ruby`
SINATRA_ROOT = Dir.pwd + '/' + File.dirname(__FILE__)                                                                                                 
require "#{SINATRA_ROOT}/config.rb"

TinyCI.git_poller