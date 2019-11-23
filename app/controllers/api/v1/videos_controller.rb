class Api::V1::VideosController < ApplicationController

  def show
      video_list = @user.videos.pluck(:name, :length, :status, :file_path)
      render json: @user.as_json(only: [:_id]).merge('video_list' => video_list), status: :accepted
  end

  def upload
      video = @user.videos.create(required_params.except(:authentication_token))
      if video.new_record?
        render json: { error: video.errors.full_messages.first }, status: :not_acceptable
      else
        CropVideoJob.perform_later(video._id.to_s)
        render json: video.as_json(only: :name), status: :ok
      end
  end

  def restart
    video = @user.videos.where(name: required_params[:name], status: /\Afails:.+/ )[0]
    if video
      CropVideoJob.perform_later(video._id.to_s)
      render json: video.reload.as_json(only: [:name, :status]), status: :ok
    else
      render json: 'file not found', status: :not_found
    end
  end
end
