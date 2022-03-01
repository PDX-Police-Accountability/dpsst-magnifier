class DpsstServices::TranscriptPersister
  attr_reader :transcript_hash
  attr_reader :scraped_on

  def initialize(transcript_hash, scraped_on)
    @transcript_hash = transcript_hash
    @scraped_on = scraped_on
  end

  def persist
    officer = Officer.create_or_find_by(dpsst_identifier: dpsst_identifier)
    officer.transcripts.create(
      scraped_on: scraped_on,
      source_transcript_attributes: {
        data_hash: transcript_hash
      }
    )
  end

  def dpsst_identifier
    @transcript_hash.dig(:header_record, :dpsst_identifier)
  end

end
