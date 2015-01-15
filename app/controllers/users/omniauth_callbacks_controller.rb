class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook

    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      login(@user)
      redirect_to welcome_facebook_acc_path, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      url = "https://www.facebook.com/"
      redirect_to url
    end
  end
end