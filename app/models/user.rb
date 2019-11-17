class User
  include Mongoid::Document

  field :name, type: String
  field :key, type: String

  validates :name, presence: true
  validates :key, presence: true

  has_many :videos, dependent: :destroy
end
