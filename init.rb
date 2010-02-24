#!/usr/bin/env ruby                                                                                                    
require 'rubygems'
require 'sinatra'
require 'haml'
require 'yaml'
SINATRA_ROOT = Dir.pwd + '/' + File.dirname(__FILE__)

Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|lib| require lib }

  get '/' do
    @projects = TinyCI.projects
    haml :index
  end

  get '/projects/:project_name' do
    project_name = params[:project_name]
    @builds = TinyCI.builds(project_name).reverse
    haml :project
  end

  get '/projects/:project_name/:build' do
    project_name = params[:project_name]
    @build = Build.new(params[:build], project_name)
    haml :build
  end
