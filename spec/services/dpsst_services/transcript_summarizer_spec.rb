require 'rails_helper'

RSpec.describe DpsstServices::TranscriptSummarizer do
  describe '#execute' do
    let(:scraped_on) { Date.parse('2022-07-11') }
    let(:yaml_dir) { './yaml_dir' }
    let(:markdown_dir) { './markdown_dir' }
    let(:summary_dir) { './summary_dir' }
    let(:summarizer) { described_class.new(scraped_on, yaml_dir, markdown_dir, summary_dir) }

    it 'builds multiple summaries' do
      allow(summarizer).to receive(:write_summary_markdown_file)
      allow(summarizer).to receive(:write_summary_tsv)

      summarizer.execute

      expect(summarizer).to have_received(:write_summary_markdown_file).
        with(anything, anything, :name).
        with(anything, anything, :dpsst_identifier).
        with(anything, anything, :agency).
        with(anything, anything, :employment_status).
        with(anything, anything, :rank)

      expect(summarizer).to have_received(:write_summary_tsv).with([:name, :dpsst_identifier, :agency, :employment_status, :rank], anything)
    end

  end
end 
