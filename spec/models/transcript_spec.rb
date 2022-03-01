require 'rails_helper'

RSpec.describe Transcript, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:officer) }
    it { is_expected.to have_one(:source_transcript) }
    it { is_expected.to accept_nested_attributes_for(:source_transcript) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:scraped_on) }
  end
end
