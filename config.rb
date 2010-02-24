require 'yaml'
require 'ostruct'

PROJECT_CONFIG = YAML::load(File.open(SINATRA_ROOT + '/config/projects.yml'))
Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|lib| require lib }


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