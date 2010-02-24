#!/usr/bin/env ruby
SINATRA_ROOT = File.dirname(__FILE__)                                                                                     
require "#{SINATRA_ROOT}/config.rb"

unless MicroCI.running?
  system("touch #{SINATRA_ROOT}/running.txt")
  begin
    MicroCI.git_poller
    sleep 10
  ensure
    system("rm #{SINATRA_ROOT}/running.txt") # make sure to clean up if fatal error
  end
end