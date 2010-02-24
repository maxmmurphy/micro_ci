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

Array.class_eval do
  def paginate(opts = {})
    opts  = {:page => 1, :per_page => 15}.merge(opts)
    WillPaginate::Collection.create(opts[:page], opts[:per_page], size) do |pager|
      pager.replace self[pager.offset, pager.per_page].to_a
    end
  end
end

WillPaginate::ViewHelpers::LinkRenderer.class_eval do
  protected
  def url(page)
    url = @template.request.url
    if page == 1
      # strip out page param and trailing ? if it exists
      url.gsub(/page=[0-9]+/, '').gsub(/\?$/, '')
    else
      if url =~ /page=[0-9]+/
        url.gsub(/page=[0-9]+/, "page=#{page}")
      else
        url + "?page=#{page}"
      end
    end
  end
end


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
