#!/usr/bin/env ruby
SINATRA_ROOT = Dir.pwd + '/' + File.dirname(__FILE__)                                                                                                 
require 'rubygems'
require 'sinatra'
require 'haml'
require 'config'

  get '/' do
    @projects = TinyCI.projects
    haml :index
  end

  get '/projects/:project_name' do
    project_name = params[:project_name]
    @builds = Project.new(project_name).builds.sort! {|a,b| b.build_number <=> a.build_number}
    haml :project
  end

  get '/projects/:project_name/:build' do
    project_name = params[:project_name]
    @build = Build.new(params[:build], project_name)
    haml :build
  end
