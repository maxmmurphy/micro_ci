require 'net/smtp'
require 'rubygems'
require 'xmpp4r'
require 'xmpp4r/muc/helper/mucclient'
include Jabber

class Notifier

  class << self
    def compose_mail(recipients, from, subject, body)
      recipients = [recipients] if !recipients.kind_of?(Array)
      ["From: #{from}",
       "To: " + recipients.map { |r| "<#{r}>" }.join(', '),
       "Subject: #{subject}",
      ].join("\n") << "\n\n" << body << "\n"
    end

    def send_email(project, result)
      from = PROJECT_CONFIG[project.name]["email"]["from"]
      recipients = PROJECT_CONFIG[project.name]["email"]["to"]
      subject =  "CDBUILDER - #{project.name} build status has changed to #{result}"
      body = "CDBUILDER - #{project.name} build status has changed to #{result}\n\n Go to build server to see details."
      Net::SMTP.start(PROJECT_CONFIG[project.name]["email"]["smtp_server"], PROJECT_CONFIG[project.name]["email"]["port"], PROJECT_CONFIG[project.name]["email"]["domain"]) do |smtp|
        smtp.send_message compose_mail(recipients, from, subject, body), from, recipients
      end
    end
    
    def login_to_jabber(project)
      xmpp = Jabber::Client.new(Jabber::JID::new('PROJECT_CONFIG[project.name]['jabber']['user_id']jeberly@cdebiz005.candrugcorp')) # change me to yaml
      xmpp.connect
      xmpp.auth('PROJECT_CONFIG[project.name]['jabber']['password']') # change me to yaml password
      muc = Jabber::MUC::MUCClient.new(xmpp)
      muc.my_jid = PROJECT_CONFIG[project.name]['jabber']['password']'jeberly' # change me to yaml
      muc.join('panda@conference.cdebiz005/jeberly') # change me to yaml
    end

    def send_jabber_message(project, message)

      m = Jabber::Message::new(nil, message)
      muc.send m
    end
  end
  
end