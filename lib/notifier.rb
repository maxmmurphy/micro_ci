require 'net/smtp'
class Notifier

  def self.compose_mail(recipients, from, subject, body)
    recipients = [recipients] if !recipients.kind_of?(Array)
    ["From: #{from}",
     "To: " + recipients.map { |r| "<#{r}>" }.join(', '),
     "Subject: #{subject}",
    ].join("\n") << "\n\n" << body << "\n"
  end

  def self.send_email(project, result)
    from = PROJECT_CONFIG[project.name]["email"]["from"]
    recipients = PROJECT_CONFIG[project.name]["email"]["to"]
    subject =  "CDBUILDER - #{project.name} build status has changed to #{result}"
    body = "CDBUILDER - #{project.name} build status has changed to #{result}\n\n Go to build server to see details."
    Net::SMTP.start(PROJECT_CONFIG[project.name]["email"]["smtp_server"], PROJECT_CONFIG[project.name]["email"]["port"], PROJECT_CONFIG[project.name]["email"]["domain"]) do |smtp|
      smtp.send_message compose_mail(recipients, from, subject, body), from, recipients
    end
  end
end