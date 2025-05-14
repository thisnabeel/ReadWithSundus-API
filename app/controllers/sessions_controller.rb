class SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      render json: user, status: :ok
    else
      render json: { error: 'Invalid login credentials' }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end