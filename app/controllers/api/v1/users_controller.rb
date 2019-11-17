class Api::V1::UsersController < ApplicationController
  def signin
    user = User.where(name: params[:name], key: params[:key] ).first
    render json: user.as_json(only:[:name, :key]), status: :accepted if user
    render json: User.create!(name: params[:name], key: params[:key]).as_json(only:[:name, :key]), status: :created if !user
  end
end
