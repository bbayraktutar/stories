class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # userful debugging code, insert the following to see the response from oauth
  # provider:
  # render :text => "<pre>" + env["omniauth.auth"].to_yaml and return


  # def facebook
  #   @user = User.find_or_create_from_facebook_omniauth(auth_hash)
  #
  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   else
  #     session["devise.user_attributes"] = @user.attributes
  #     redirect_to new_user_registration_url
  #   end
  # end
  #
  # def twitter
  #   @user = User.find_or_create_from_twitter_omniauth(auth_hash)
  #
  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication
  #     set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
  #   else
  #     session["devise.user_attributes"] = @user.attributes
  #     redirect_to new_user_registration_url
  #   end
  # end
  #
  # def google_oauth2
  #   @user = User.find_or_create_from_google_omniauth(auth_hash)
  #
  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication
  #     set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
  #   else
  #     session["devise.user_attributes"] = @user.attributes
  #     redirect_to new_user_registration_url
  #   end
  # end
  #
  # def failure
  #   redirect_to root_path
  # end

  def all
    omniauth = request.env['omniauth.auth']
    provider_name = OmniauthProviders.provider_data_for(omniauth['provider'])[:name]
    if current_user
      auth_args = {provider: omniauth['provider'], uid: omniauth['uid'].to_s}
      auth = current_user.authentications.create(auth_args)

      if auth.persisted?
        return redirect_to edit_user_registration_path, notice: "#{provider_name} authentication added."
      else
        existing_auth = Authentication.find_by(auth_args)
        return redirect_to edit_user_registration_path, alert: "That #{provider_name} authentication is already in use by #{existing_auth.user.email}!."
      end
    end

    user = User.from_omniauth(omniauth)
    binding.pry
    store_location_for(user, request.env['omniauth.origin']) if request.env['omniauth.origin']
    if user.persisted?
      flash[:notice] = "#{provider_name} login successful."
      sign_in_and_redirect user
    else
      session['devise.omniauth'] = omniauth.except('extra')
      redirect_to new_user_registration_path
    end
  end

  [:facebook, :twitter, :google_oauth2].each do |provider|
    alias_method provider, :all
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
