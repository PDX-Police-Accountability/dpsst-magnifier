class DpsstServices::TranscriptYamlizer
  attr_reader :transcript_hash
  attr_reader :scraped_on
  attr_reader :output_filename

  def initialize(transcript_hash, scraped_on, output_filename)
    @transcript_hash = transcript_hash
    @scraped_on = scraped_on
    @output_filename = output_filename
  end

  def execute
    File.write(output_filename, transcript_hash.to_yaml)
  end

  def dpsst_identifier
    @transcript_hash.dig(:header_record, :dpsst_identifier)
  end

end
