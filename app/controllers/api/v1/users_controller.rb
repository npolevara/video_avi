class Api::V1::UsersController < ApplicationController

  def signin
    if signed_user
      render json: signed_user, status: :accepted
    else
      render json: User.create!, status: :created
    end
  end

end
