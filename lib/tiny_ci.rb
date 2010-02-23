class TinyCI
  class << self
    def projects
      YAML::load(File.open('../config/projects.yml')).keys.map {|pname| Project.new(pname)}
    end
  
    def running?
      IO.popen("ps") {|io| @running = io.read}
      @running.include?("./../projects")
    end
    
    def git_poller
      return if running?
      projects.each do |project|
        IO.popen("cd #{project.path};git pull") {|io| @output = io.read }
        if @output.include?("Already up-to-date.")
          puts "up_to_date"
          return
        else
          puts "about to build"
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
      filename = "../builds/#{project.name}/" + Time.now.strftime("%Y-%m-%d-%H%M%S") + '.build_log'
      results.each do |result| 
        File.open(filename, 'a')  do |f|
          f.write("=======================#{result.test_case}================================== \n")
          f.write(result.output)
          f.write("\n")
        end
      end
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