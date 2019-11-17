require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :key }
  it { should have_many(:videos).with_dependent(:destroy) }
end
