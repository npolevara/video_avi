class Api::V1::VideosController < ApplicationController

  def show
    if signed_user
      render json: @user.as_json(only: [:_id]).merge('video_list' => {}), status: :accepted
    else
      render json: User.create!.as_json(only: [:_id]).merge('video_list' => {}), status: :created
    end
  end

  def upload

  end

  def refresh

  end

end
