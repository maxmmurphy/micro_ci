#!/usr/bin/env ruby                                                                                                    
require 'rubygems'
require 'sinatra'
require 'haml'
require 'yaml'


Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|lib| require lib }

  get '/' do
    @projects = TinyCI.projects
    haml :index
  end

  get '/projects/:project_name' do
    @project = params[:project_name]
    @builds = Dir.glob("builds/#{params[:project_name]}/*")
    haml :project
  end

  get '/projects/:project/:build' do
    @project = params[:project]
    @build = params[:build]
    haml :build
  end
