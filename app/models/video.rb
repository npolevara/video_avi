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

  validates :name, presence: true
  validates :source, presence: true

  belongs_to :user

  def crop!
    puts `ffmpeg -i #{file_path} -ss #{cut_from} -t #{cut_length} #{croped_name}`
  end

  def get_length
    self.length = capture(:stdout) { puts `ffmpeg -i #{file_path} 2>&1 | grep Duration | awk '{print $2}' | tr -d ,` }
       .strip
  end

  def status(status)
    self.status = status
    save!
  end

  private

  def file_path
    source.file.file
  end

  def croped_name
    file_path.gsub(/(\..{3}$)/,'_cropped\1')
  end

end
