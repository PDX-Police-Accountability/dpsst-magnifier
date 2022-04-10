require 'rails_helper'

RSpec.describe DpsstServices::TrainingSummarizer do
  context 'valid transcript' do
    let(:scraped_on_date) { Date.parse('2022-07-11') }
    let(:filename) { '56260-transcript.html' }
    let(:file) { file_fixture(filename) }
    let(:reader) { DpsstServices::TranscriptReader.new(file) }

    before do
      reader.load_file
    end

    describe '#persist' do
      let(:hash) { reader.process }
      let(:persister) { described_class.new(reader.process, scraped_on_date) }

      it 'persists Transcript and SourceTranscript' do
        expect{ persister.persist }.to change{ Transcript.count }.by(1).
          and change{ SourceTranscript.count }.by(1)
      end

      it 'sets scraped_on date' do
        transcript = persister.persist
        expect(transcript.scraped_on).to eq(Date.parse('2022/07/11'))
      end
    end
  end
end 
