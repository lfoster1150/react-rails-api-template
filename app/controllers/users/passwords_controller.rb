class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if resource_class.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource, store: false)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      respond_with resource
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  private

  def respond_with(resource, _opts = {})
    email_check = resource.is_a?(Hash) && _opts[:location].to_s === "/auth/login"
    if email_check
      render json: {
        status: {code: 200, message: "Email sent."},
      }, status: :ok
    elsif resource.persisted?
      render json: {
        status: {code: 200, message: "Update successful."},
      }, status: :ok
    else
      puts resource.errors.full_messages.to_sentence
      render json: {
        status: { message: "Failed to update password. #{resource.errors.full_messages.to_sentence}" },
      }, status: :unprocessable_entity
    end
  end
end
