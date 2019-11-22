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
    puts `ffmpeg -i #{get_file_path} -ss #{cut_from} -t #{cut_length} #{cropped_name}`
  end

  def set_length
    self.length = capture(:stdout) { puts `ffmpeg -i #{get_file_path} 2>&1 | grep Duration | awk '{print $2}' | tr -d ,` }
       .strip
  end

  def set_file_path
    self.file_path = get_file_path
  end

  def cropped_name
    get_file_path.gsub(/(\..{3}$)/,'_cropped\1')
  end

  def status!(status)
    self.status = status
    save!
  end

  def update_file_and_status!(status)
    set_length
    set_file_path
    status!(status)
  end

  private

  def get_file_path
    source.file.file
  end
end
