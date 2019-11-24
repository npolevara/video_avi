require 'active_support/testing/stream'
class Video
  include Mongoid::Document
  include ActiveSupport::Testing::Stream

  mount_uploader :source, VideoUploader

  field :name, type: String
  field :length, type: String
  field :cut_from, type: Integer
  field :cut_length, type: Integer
  field :status, type: String
  field :file_path, type: String

  validates :name, presence: true
  validates :source, presence: true

  belongs_to :user

  def crop
    puts `ffmpeg -i #{show_file_path} -ss #{cut_from} -t #{cut_length} #{cropped_name}`
  end

  def set_length
    time = capture(:stdout) { puts `ffmpeg -i #{show_file_path} 2>&1 | grep Duration | awk '{print $2}' | tr -d ,` }
       .strip
    check_lenght(time) unless cropped?
    self.length = time
  end

  def set_file_path

    link = "#{ENV['ROOT_URL']}/api/v1/download?authentication_token=#{user.authentication_token}"
    link += "&name=#{name}&id=#{_id.to_str}"
    self.file_path = link
  end

  def cropped_name
    show_file_path.gsub(/(\..{3}$)/, '_cropped\1')
  end

  def cropped?
    name =~ /\_cropped\z/
  end

  def update_file_and_status!(status)
    set_length
    set_file_path
    update(status: status)
  end

  def show_file_path
    source.file.file
  end

  private

  def check_lenght(time)
    no_marks = cut_from.nil? || cut_length.nil? || (cut_from.nil? && cut_length.nil?)
    raise StandardError, 'No crop marks given' if no_marks

    full_crop = cut_from + cut_length
    file_time = Time.parse(time).seconds_since_midnight
    raise StandardError, "Crop marks to long, crop length:#{full_crop}, video length#{file_time}" if full_crop > file_time
  end
end
