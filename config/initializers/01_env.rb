module Hackraise
  extend self

  def incoming_email_domain
    ENV['INCOMING_EMAIL_DOMAIN'] || 'hackraise.com'
  end

  def outgoing_email_domain
    ENV['OUTGOING_EMAIL_DOMAIN'] || 'hackraise.com'
  end
end
