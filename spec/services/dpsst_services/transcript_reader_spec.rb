require 'rails_helper'

RSpec.describe DpsstServices::TranscriptReader do
  context 'existing transcript file' do
    let(:filename) { '56260-transcript.html' }
    let(:file) { file_fixture(filename) }
    let(:reader) { described_class.new(file) }

    describe '#load_file' do
      it 'succeeds' do
        expect{ reader.load_file }.to_not raise_error
        expect(reader.filename.to_s).to include(filename)
      end
    end
  end

  context 'missing transcript file' do
    let(:missing_file) { './missing-file.txt' }
    let(:reader) { described_class.new(missing_file) }

    describe '#load_file' do
      it 'raises error' do
        expect{ reader.load_file }.to raise_error(Errno::ENOENT)
      end
    end
  end
end 
