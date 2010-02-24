require 'net/smtp'
class Project
  attr_reader :branch, :test_cases, :name, :config
  def initialize(name)
    @config = YAML::load(File.open(SINATRA_ROOT + '/config/projects.yml'))
    @name = name
    @branch = @config[name]['branch']
    @test_cases = @config[name]['test_cases']
  end
  
  def path
    "#{SINATRA_ROOT}/../projects/#{name}"
  end
  
  def last_build_result
    builds.last.result rescue 'UNKNOWN'
  end
  
  def builds
    Dir.glob(SINATRA_ROOT + "/builds/#{self.name}/*").map{|b| Build.new(File.basename(b, ".build_log"), self.name)}
  end

end