class Video
  include Mongoid::Document
  field :name, type: String
  field :source, type: String

  validates :name, presence: true
  validates :source, presence: true

  belongs_to :user
end
