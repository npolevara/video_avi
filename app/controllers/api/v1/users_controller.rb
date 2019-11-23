class Api::V1::UsersController < ApplicationController

  def signin
    render json: signed_user, status: :accepted
  end

  private

  def check_signed_user
    render json: User.create!, status: :created unless signed_user
  end

end
