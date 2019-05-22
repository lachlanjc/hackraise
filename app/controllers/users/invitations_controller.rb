class Users::InvitationsController < Devise::InvitationsController
  before_filter :find_account!, only: [:create]

  def create
    if existing_user = User.find_by(email: params[:user][:email])
      @user = existing_user

      if current_user.email == params[:user][:email]
        set_flash_message :notice, :no_self_invite
        return redirect_to edit_account_path(@account, anchor: 'team')
      end

      # check if we only need to resend the invitation
      existing_membership = Membership.find_by(user: @user, account: @account)

      if existing_membership && !@user.invitation_accepted?
        @user.invite!

        return respond_with @user do |format|
          format.html do
            redirect_to edit_account_path(@account, anchor: 'team')
          end

          format.json
        end
      end
    else
      @user = invite_resource
    end

    @membership = Membership.new(
      user: @user,
      account: @account
    )

    @person = Person.new

    authorize! InvitationCreatePolicy.new(@account, current_user, @membership)

    if @membership.save
      respond_with @user do |format|
        format.html do
          set_flash_message :notice, :send_instructions, email: @user.email if @user.invitation_sent_at
          redirect_to edit_account_path(@account, anchor: 'team')
        end

        format.json
      end
    else
      respond_with @user do |format|
        format.html { render 'accounts/edit' }
        format.json
      end
    end
  end

  def update
    self.resource = resource_class.accept_invitation!(update_resource_params)

    resource.accounts.each do |account|
      resource.create_person(
        account: account,
        email: resource.email,
        name: params[:person][:name],
        user: resource,
      )
    end

    if resource.valid?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message :notice, flash_message
      sign_in(resource_name, resource)
      respond_with resource, location: account_path(resource.accounts.first)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

  def find_account!
    @account = Account.find_by!(slug: params.fetch(:account_id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end
end
