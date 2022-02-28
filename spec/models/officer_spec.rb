require 'rails_helper'

RSpec.describe Officer, type: :model do
  it { is_expected.to have_many(:transcripts) }
end
