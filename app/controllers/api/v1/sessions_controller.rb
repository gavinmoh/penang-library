class Api::V1::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  #
  # protected
  #
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  # end

 private

 def respond_with(resource, _opts = {})
    render json: {
      message: "Login success!"
    }, status: :ok
 end

 def respond_to_on_destroy
    render json: {
      message: "Logout success!"
    }, status: :ok
 end
end
