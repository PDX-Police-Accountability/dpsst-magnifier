require 'rails_helper'

RSpec.describe Transcript, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:officer) }
  end

end
