require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:videos).with_dependent(:destroy) }
end
