class User
  include Mongoid::Document
  acts_as_token_authenticatable

  field :authentication_token

  has_many :videos, dependent: :destroy

  def user_json
    { id: _id.to_str, authentication_token: authentication_token }
  end
end
