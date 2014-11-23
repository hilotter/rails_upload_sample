class UserController < ApplicationController
  include CarrierwaveBase64Uploader

  def update
    raise ArgumentError, 'invalid params' if params[:name].blank? || params[:profile].blank?
    user_update
    update_response
  end

  def update_base64
    raise ArgumentError, 'invalid params' if params[:name].blank? || params[:profile_base64].blank?
    user_update
    update_response
  end

  private

  def user_update
    @user = User.find_or_create_by(name: params[:name])
    @user.profile_image = params[:profile] ? params[:profile] : base64_conversion(params[:profile_base64])
    @user.save!
  end

  def update_response
    render json: {
      name: @user.name,
      profile_url: @user.profile_image.url
    }
  end
end
