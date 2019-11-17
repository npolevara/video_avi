class User
  include Mongoid::Document
  acts_as_token_authenticatable

  field :authentication_token

  has_many :videos, dependent: :destroy
end
