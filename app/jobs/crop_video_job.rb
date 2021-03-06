class CropVideoJob < ApplicationJob
  queue_as do
    current_video
    :cropping
  end

  after_perform do
    current_video.update(status: 'done')
    new_name = current_video.name + '_cropped'
    source = Pathname.new(current_video.cropped_name).open
    new_video = current_video.user.videos.create!(name: new_name, source: source)
    File.delete(current_video.cropped_name)
    new_video.update_file_and_status!('cropped')
  end

  after_enqueue do
    current_video.update_file_and_status!('scheduled')
  end

  def perform(*args)
    current_video.update(status: 'processing')
    current_video.crop
  end

  rescue_from(StandardError) do |exception|
    error = 'fails' + ': ' + exception.to_s
    current_video.update(status: error)
  end

  private

  def current_video
    @video ||= Video.find_by!(_id: arguments.first)
  end
end
