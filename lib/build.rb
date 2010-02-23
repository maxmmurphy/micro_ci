class Build

  attr_reader :project_name, :build_number

  def initialize(date, project_name)
    @project_name = project_name
    @build_number = date
  end
  
  def url
    "/projects/#{project_name}/#{build_number}"
  end

  def name
    "#{project_name}-#{build_number}"
  end
  
  def output_path
    "#{SINATRA_ROOT}/builds/#{project_name}/#{build_number}.build_log"
  end
  
  def result
    `tail -1 #{output_path}` 
  end
  
end