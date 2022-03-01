require 'rails_helper'

RSpec.describe Officer, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:transcripts) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:dpsst_identifier) }
    it { is_expected.to validate_uniqueness_of(:dpsst_identifier) }
  end
end
