class Api::V1::VideosController < ApplicationController

  def show
    user = User.where(required_params).first if required_params
    render json: user.as_json(only: [:_id]).merge('video_list' => {}), status: :accepted if user
    render json: User.create!.as_json(only: [:_id]).merge('video_list' => {}), status: :created if !user
  end

  def upload

  end

  def refresh

  end

  private

  def required_params
    token = params.permit(:_id, :authentication_token)
    return if token.to_h.empty?
    token
  end

end
