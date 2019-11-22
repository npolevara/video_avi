class CropVideoJob < ApplicationJob
  queue_as do
    current_video
    :cropping
  end

  after_perform do
    current_video.status('done')
  end

  after_enqueue do
    current_video.get_length
    current_video.status('scheduled')
  end

  def perform(video_id)
    current_video.status('processing')
    current_video.crop!
  end

  private

  def current_video
    @video ||= Video.find_by!(_id: self.arguments.first)
  end
end
