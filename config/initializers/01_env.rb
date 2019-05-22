# Confy::Config.env(ENV['CONFY_URL']) if ENV['CONFY_URL']

module Hackraise
  extend self

  def incoming_email_domain
    ENV['INCOMING_EMAIL_DOMAIN'] || 'hackraise.com'
  end

  def outgoing_email_domain
    ENV['OUTGOING_EMAIL_DOMAIN'] || 'hackraise.com'
  end
end
