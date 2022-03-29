class DpsstServices::TranscriptMarkdowner
  include DpsstServices::MarkdownTable

  attr_reader :transcript_hash
  attr_reader :scraped_on
  attr_reader :output_filename

  def initialize(transcript_hash, scraped_on, output_filename)
    @transcript_hash = transcript_hash
    @scraped_on = scraped_on
    @output_filename = output_filename
  end

  def execute
    md = hash_to_markdown
    File.write(output_filename, md)
  end

  def dpsst_identifier
    @transcript_hash.dig(:header_record, :dpsst_identifier)
  end

  def hash_to_markdown
    return "## missing_transcript" + "\n" if transcript_hash[:missing_transcript]

    md = header_markdown
    md << employment_markdown
    md << certification_markdown
    md << attribute_markdown
    md << education_markdown
    md << training_markdown

    md
  end

  def header_markdown
    h = transcript_hash[:header_record]

    md = "## Header" + "\n"
    md << table_header(['attribute', 'value'])

    h.to_a.each do |row|
      md << table_row(row)
    end

    md
  end

  def employment_markdown
    title = 'Employment'
    cols = [:date, :agency, :action, :rank, :classification, :assignment]

    array_to_table_markdown(title, cols, transcript_hash[:employment_records])
  end

  def certification_markdown
    title = 'Certification'
    cols = [:status_date, :certificate, :level, :status, :certificate_date, :expiration_date, :probation_date]

    array_to_table_markdown(title, cols, transcript_hash[:certification_records])
  end

  def training_markdown
    title = 'Training'
    cols = [:date, :course, :title, :status, :score, :hours]

    array_to_table_markdown(title, cols, transcript_hash[:training_records])
  end

  def attribute_markdown
    title = 'Attributes'
    cols = [:topic, :value, :effective_date, :expiration_date]

    array_to_table_markdown(title, cols, transcript_hash[:attribute_records])
  end

  def education_markdown
    title = 'Education'
    cols = [:date, :degree, :school, :major, :hours]

    array_to_table_markdown(title, cols, transcript_hash[:education_records])
  end

end
