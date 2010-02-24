class TinyCI
  class << self
    def projects
      YAML::load(File.open(SINATRA_ROOT + '/config/projects.yml')).keys.map {|pname| Project.new(pname)}
    end
    
    def builds(project_name)
      Dir.glob(SINATRA_ROOT + "/builds/#{project_name}/*").map{|b| Build.new(File.basename(b, ".build_log"), project_name)}
    end
  
    def running?
      IO.popen("ps") {|io| @running = io.read}
      is_running = @running.include?("tiny_ci/../projects")
      is_running
    end
    
    def git_poller
      return if running?
      projects.each do |project|
        IO.popen("cd #{project.path};git pull") {|io| @output = io.read }
        if @output.include?("Already up-to-date.")
          puts "#{project.name} - up_to_date"
          next
        else
          puts "about to build - #{project.name}"
          build_it(project)
        end
      end
    end


    def build_it(project)
      results = run_test_cases(project)
      write_output(results, project)
      #notify(results)
    end

    def write_output(results, project)
      filename = "#{SINATRA_ROOT}/builds/#{project.name}/" + Time.now.strftime("%Y-%m-%d-%H%M%S") + '.build_log'
      results.each do |result| 
        File.open(filename, 'a')  do |f|
          f.write("=============#{result.test_case}-#{result.success ?  "SUCCESS" : "FAILED"}==================== \n")
          f.write(result.output)
          f.write("\n")
        end
      end
      File.open(filename, 'a') {|f| f.write(build_result(results))}
    end

    def build_result(results)
      failed = results.map{|result| result.success}.include?(false)
      failed ? "FAILED" : "SUCCESS"
    end

    def run_test_cases(project)
      @results = []
      project.test_cases.each do |tc|
        result = OpenStruct.new(:test_case => tc)
        IO.popen("cd #{project.path};#{tc}") {|io| result.output = io.read}
        result.success = $?.success?
        @results << result
      end
      @results
    end
  end
end