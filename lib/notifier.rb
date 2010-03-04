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

    def send_email(project, subject, body)
      from = PROJECT_CONFIG["projects"][project.name]["email"]["from"]
      recipients = PROJECT_CONFIG["projects"][project.name]["email"]["to"]
      Net::SMTP.start(PROJECT_CONFIG["projects"][project.name]["email"]["smtp_server"], PROJECT_CONFIG["projects"][project.name]["email"]["port"], PROJECT_CONFIG["projects"][project.name]["email"]["domain"]) do |smtp|
        smtp.send_message compose_mail(recipients, from, subject, body), from, recipients
      end
    end
    
    def jabber_user
      "#{PROJECT_CONFIG['jabber']['user_id']}@#{PROJECT_CONFIG['jabber']['domain']}"
    end

    def jabber_client_init
      # Jabber::debug = true
      $jabber_client = Jabber::Client.new(Jabber::JID::new(jabber_user)) 
      $jabber_client.connect
      $jabber_client.auth(PROJECT_CONFIG['jabber']['password'])
    end
    
    def send_jabber_message(muc, message)
      m = Message::new(nil, message)
      muc.send m
    end
  end
  
end