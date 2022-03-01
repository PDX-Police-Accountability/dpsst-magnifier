require 'rails_helper'

RSpec.describe SourceTranscript, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:transcript) }
  end

  it { is_expected.to serialize(:data_hash).as(Hash) }
end
