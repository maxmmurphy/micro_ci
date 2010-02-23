#!`which ruby`
require 'yaml'

Dir[File.join(File.dirname(__FILE__), '../lib', '*.rb')].each {|lib| require lib }

TinyCI.git_poller