class Api::V1::UsersController < ApplicationController
  def signin
    user = User.where(authentication_token: params[:key] ).first
    render json: user.as_json(only:[:authentication_token]), status: :accepted if user
    render json: User.create!.as_json(only:[:authentication_token]), status: :created if !user
  end
end
