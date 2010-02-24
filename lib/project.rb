class Project
  attr_reader :branch, :test_cases, :name, :config
  def initialize(name)
    @config = PROJECT_CONFIG
    @name = name
    @branch = @config[name]['branch']
    @test_cases = @config[name]['test_cases']
  end
  
  def path
    "#{SINATRA_ROOT}/../projects/#{name}"
  end
  
  def last_build_result
    builds.last.result.chomp rescue 'UNKNOWN'
  end
  
  def builds
    Dir.glob(SINATRA_ROOT + "/builds/#{self.name}/*").map{|b| Build.new(File.basename(b, ".build_log"), self.name)}.sort! {|a,b| a.build_number <=> b.build_number}
  end
  
  def status_changed?
    builds[-2].result != last_build_result rescue false
  end
  
  def notify
    return unless status_changed?
    email(last_build_result) if PROJECT_CONFIG[name]["email"]
  end
  
  def email(result)
    Notifier.send_email(self, result)
  end
end