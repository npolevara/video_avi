class Video
  include Mongoid::Document
  mount_uploader :source, VideoUploader

  field :name, type: String

  validates :name, presence: true
  validates :source, presence: true

  belongs_to :user
end
