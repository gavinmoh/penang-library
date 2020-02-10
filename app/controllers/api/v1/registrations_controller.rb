class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  respond_to :json

  def create
    @user = User.new(sign_up_params)
    @user.role = 'PATREON'
    if @user.save
      render json: {
        message: "Signed up successfully.",
        data: { user: @user }
      }, status: :ok
    else
      render json: {
        message: "Something went wrong.",
        errors: @user.errors
      }, status: :unprocessable_entity
    end
  end

  # protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :name])
  end

end
