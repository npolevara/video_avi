class Api::V1::UsersController < ApplicationController

  def signin
    user = User.where(required_params).first if required_params
    render json: user, status: :accepted if user
    render json: User.create!, status: :created if !user
  end

  private

  def required_params
    token = params.permit(:_id, :authentication_token)
    return if token.to_h.empty?
    token
  end

end
