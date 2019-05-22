class AssignmentEventMailer < ActionMailer::Base
  def created(assignment_event_id)
    @assignment_event = AssignmentEvent.find(assignment_event_id)
    @conversation = @assignment_event.conversation
    @assigner = @assignment_event.user
    @assignee = @assignment_event.assignee

    to = @assignee.email

    from = Mail::Address.new("notifications@#{Hackraise.incoming_email_domain}")
    from.display_name = "Hackraise"

    subject = "#{@assigner.name} assigned you to a conversation"

    mail to: to, from: from, subject: subject
  end
end
