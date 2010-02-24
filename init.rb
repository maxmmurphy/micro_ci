#!/usr/bin/env ruby
$LOAD_PATH.unshift File.dirname(__FILE__) + '/vendor/gems/will_paginate/lib' # using agnostic branch
SINATRA_ROOT = Dir.pwd + '/' + File.dirname(__FILE__)                                                                                                 
require 'rubygems'
require 'sinatra'
require 'haml'
require File.dirname(__FILE__) + '/vendor/gems/will_paginate/lib/will_paginate'
require File.dirname(__FILE__) + '/vendor/gems/will_paginate/lib/will_paginate/view_helpers/link_renderer'
require File.dirname(__FILE__) + '/vendor/gems/will_paginate/lib/will_paginate/view_helpers/base'
require "#{SINATRA_ROOT}/config"
include WillPaginate::ViewHelpers::Base

get '/' do
  @projects = MicroCI.projects
  haml :index
end

get '/projects/:project_name' do
  project_name = params[:project_name]
  @builds = Project.new(project_name).builds.paginate(:page => params[:page] || 1)
  haml :project
end

get '/projects/:project_name/:build' do
  project_name = params[:project_name]
  @build = Build.new(params[:build], project_name)
  haml :build
end
