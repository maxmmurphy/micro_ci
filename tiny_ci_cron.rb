#!`which ruby`
require 'yaml'
require 'ostruct'
SINATRA_ROOT = Dir.pwd

Dir[File.join(File.dirname(__FILE__), './lib', '*.rb')].each {|lib| require lib }

TinyCI.git_poller