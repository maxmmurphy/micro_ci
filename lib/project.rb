class Project
  attr_reader :branch, :test_cases, :name, :config, :cleanup_count
  def initialize(name)
    @config = PROJECT_CONFIG
    @name = name
    @branch = @config['projects'][name]['branch']
    @cleanup_count = @config['projects'][name]['cleanup_count']
    @test_cases = @config['projects'][name]['test_cases']
  end
  
  def path
    "#{SINATRA_ROOT}/../projects/#{name}"
  end
  
  def last_build_result
    last_build.result.chomp rescue 'UNKNOWN'
  end
  
  def last_build
    builds.first
  end
  
  def cleanup
    builds[cleanup_count..-1].each(&:destroy) if cleanup_count rescue nil
  end
  
  def builds
    Dir.glob(SINATRA_ROOT + "/builds/#{self.name}/*").map{|b| Build.new(File.basename(b, ".build_log"), self.name)}.sort! {|a,b| b.build_number <=> a.build_number}
  end
  
  def status_changed?
    builds[1].result != last_build_result rescue false
  end
  
  def notify
    return unless status_changed?
    subject = "MicroCI - #{name.upcase} build status has changed to #{last_build_result}"
    body = "MicroCI - #{name.upcase} build status has changed to #{last_build_result}\n\n Go to build server to see details."
    email(subject, body) if PROJECT_CONFIG["projects"][name]["email"]
    send_jabber_message(subject) if PROJECT_CONFIG["projects"][name]["jabber_room"]
  end
  
  def email(subject, body)
    Notifier.send_email(self, subject, body)
  end
  
  def send_jabber_message(message)
    connect_to_jabber_room
    Notifier.send_jabber_message(jabber_connection, message)
  end
  
  def jabber_connection
    eval("$jabber_room_#{name}")
  end
  
  def connect_to_jabber_room
    return if jabber_connection
    Notifier.jabber_client_init unless $jabber_client # reconnect to jabber if we are not already
    eval("$jabber_room_#{name} = Jabber::MUC::MUCClient.new($jabber_client)")
    eval("$jabber_room_#{name}.my_jid = '#{PROJECT_CONFIG['jabber']['user_id']}'")
    eval("$jabber_room_#{name}.join('#{PROJECT_CONFIG['projects'][name]['jabber_room']}/#{PROJECT_CONFIG['jabber']['user_id']}')")
  end
end