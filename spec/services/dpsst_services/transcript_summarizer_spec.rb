require 'rails_helper'

RSpec.describe DpsstServices::TranscriptSummarizer do
  describe '#execute' do
    let(:scraped_on) { Date.parse('2022-07-11') }
    let(:yaml_dir) { './yaml_dir' }
    let(:summary_dir) { './summary_dir' }
    let(:summarizer) { described_class.new(scraped_on, yaml_dir, summary_dir) }

    it 'builds multiple summaries' do
      allow(summarizer).to receive(:write_summary_markdown_file)
      allow(summarizer).to receive(:write_summary_json_data_array)
      allow(summarizer).to receive(:write_summary_tsv_all)
      allow(summarizer).to receive(:write_summary_tsv_active)
      allow(summarizer).to receive(:write_summary_tsv_inactive)

      summarizer.execute

      expect(summarizer).to have_received(:write_summary_markdown_file).
        with(anything, anything, 'name').
        with(anything, anything, 'dpsst_identifier').
        with(anything, anything, 'agency').
        with(anything, anything, 'employment_status').
        with(anything, anything, 'rank').
        with(anything, anything, 'last_action').
        with(anything, anything, 'last_action_date')

      expect(summarizer).to have_received(:write_summary_tsv_all).with(['name', 'dpsst_identifier', 'agency', 'employment_status', 'rank', 'last_action', 'last_action_date'], anything)
      expect(summarizer).to have_received(:write_summary_tsv_active).with(['name', 'dpsst_identifier', 'agency', 'employment_status', 'rank', 'last_action', 'last_action_date'], anything)
      expect(summarizer).to have_received(:write_summary_tsv_inactive).with(['name', 'dpsst_identifier', 'agency', 'employment_status', 'rank', 'last_action', 'last_action_date'], anything)
    end

    xit 'includes all officers in the summary' do

    end

    xit 'includes only active officers in the active officer summary' do

    end

    xit 'includes only inactive officers in the inactive officer summary' do

    end

  end

  describe '#ingest_transcript' do

    context 'existing transcript' do
      let(:dpsst_id) { '21286' }
      let(:scraped_on) { Date.parse('2022-07-11') }
      let(:yaml_dir) { './yaml_dir' }
      let(:summary_dir) { './summary_dir' }
      let(:summarizer) { described_class.new(scraped_on, yaml_dir, summary_dir) }
      let(:filename) { 'yaml/21286-transcript.yml' }
      let(:file) { file_fixture(filename) }

      it 'has data' do
        yaml = YAML.load_file(file)
        record = summarizer.summarize_transcript(dpsst_id, yaml)
				expect(record).to have_key('name')
				expect(record).to have_key('dpsst_identifier')
        expect(record).to have_key('agency')
				expect(record).to have_key('employment_status')
				expect(record).to have_key('rank')
				expect(record).to have_key('last_action')
				expect(record).to have_key('last_action_date')
				expect(record).to have_key('links')
      end
    end

  end
end 
