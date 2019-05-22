class IncomingMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    content_type = 'application/json'

    if params[:callback].present?
      request.format = 'json'
      content_type = 'text/javascript'
    end

    account = Account.find_by(slug: params.fetch(:account))
    person = Person.find_or_create_by_addr(
      Mail::Address.new(params.fetch(:email))
    )

    person.save!

    @message = MessageFactory.build(
      account: account,
      person: person,
      subject: "New message for #{account.email}",
      content: params.fetch(:content)
    )

    if @message.save
      respond_to do |format|
        format.json do
          render json: @message,
                 status: :created,
                 callback: params[:callback],
                 content_type: content_type
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: @message.errors,
                 status: :unprocessable_entity,
                 callback: params[:callback],
                 content_type: content_type
        end
      end
    end
  end
end
