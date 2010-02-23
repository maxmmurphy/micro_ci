class Project
  attr_reader :branch, :test_cases, :name
  def initialize(name)
    cfg = YAML::load(File.open('../config/projects.yml'))
    @name = name
    @branch = cfg[name]['branch']
    @test_cases = cfg[name]['test_cases']
  end
  
  def path
    "./../projects/#{name}"
  end
end