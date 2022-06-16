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
    File.write(output_filename, transcript_hash.deep_stringify_keys.to_yaml)
  end

end
