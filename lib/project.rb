class Project
  attr_reader :branch, :test_cases, :name
  def initialize(name)
    cfg = YAML::load(File.open(SINATRA_ROOT + '/config/projects.yml'))
    @name = name
    @branch = cfg[name]['branch']
    @test_cases = cfg[name]['test_cases']
  end
  
  def path
    "#{SINATRA_ROOT}/../projects/#{name}"
  end
  
  def last_build_result
    TinyCI.builds(self.name).last.result
  end
end