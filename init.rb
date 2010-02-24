#!/usr/bin/env ruby
SINATRA_ROOT = Dir.pwd + '/' + File.dirname(__FILE__)                                                                                                 
require 'rubygems'
require 'sinatra'
require 'haml'
require "#{SINATRA_ROOT}/config"

  get '/' do
    @projects = MicroCI.projects
    haml :index
  end

  get '/projects/:project_name' do
    project_name = params[:project_name]
    @builds = Project.new(project_name).builds
    haml :project
  end

  get '/projects/:project_name/:build' do
    project_name = params[:project_name]
    @build = Build.new(params[:build], project_name)
    haml :build
  end
