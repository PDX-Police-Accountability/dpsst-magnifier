require 'rails_helper'

RSpec.describe DpsstServices::TrainingSummarizer do
  context 'valid transcript' do
		let(:scraped_on) { Date.parse('2022-07-11') }
		let(:yaml_dir) { './yaml_dir' }
		let(:summary_dir) { './summary_dir' }

    describe '#execute' do
      let(:summarizer) { described_class.new(scraped_on, yaml_dir, summary_dir) }

      it 'calls the methods that do the actual work' do
        allow(summarizer).to receive(:ingest_training_records)
        allow(summarizer).to receive(:write_training_tsv)

        summarizer.execute
      end

      xit 'writes the summary tsv file' do
      end

    end
  end
end 
