class Api::V1::VideosController < ApplicationController

  def show
    if signed_user
      video_list = @user.videos.inject([]) { |acc, video| acc << video.name }
      render json: @user.as_json(only: [:_id]).merge('video_list' => video_list), status: :accepted
    else
      render json: User.create!.as_json(only: [:_id]).merge('video_list' => {}), status: :created
    end
  end

  def upload
    if signed_user
      video = @user.videos.create(required_params.except(:authentication_token))
      if video.new_record?
        render json: { error: video.errors.full_messages.first }, status: :not_acceptable
      else
        render json: video.as_json(only: :name), status: :ok
      end
    end
  end

  def refresh

  end

end
