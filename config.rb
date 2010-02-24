require 'yaml'
require 'ostruct'
PROJECT_CONFIG = YAML::load(File.open(SINATRA_ROOT + '/config/projects.yml'))
Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|lib| require lib }