class Build

  attr_reader :project_name, :build_number

  def initialize(epoch_time, project_name)
    @project_name = project_name
    @build_number = epoch_time
  end
  
  def url
    "/projects/#{project_name}/#{build_number}"
  end

  def name
    "#{project_name}-#{build_number}"
  end
  
  def date
    Time.at(build_number.to_i).strftime("%Y-%m-%d-%H:%M:%S")
  end
  
  def output_path
    "#{SINATRA_ROOT}/builds/#{project_name}/#{build_number}.build_log"
  end
  
  def result
    result = `tail -1 #{output_path}`
    result.chomp.empty? ? 'UNKNOWN' : result
  end
  
end