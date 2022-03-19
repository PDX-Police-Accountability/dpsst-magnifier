class DpsstServices::TranscriptMarkdowner
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
    md = header_markdown
    md << employment_markdown
    md << certification_markdown
    md << attribute_markdown
    md << education_markdown
    md << training_markdown

    md
  end

  def table_header(columns)
    first_row = '| ' + columns.join(' | ') + ' |'
    second_row = first_row.gsub(/[\w]/, '-')

    first_row + "\n" + second_row + "\n"
  end

  def table_row(cells)
    '| ' + cells.join(' | ') + ' |' + "\n"
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

  def array_to_table_markdown(title, cols, a)
    t = "## #{title}" + "\n"
    th = table_header(cols.map(&:to_s))

    a.each_with_object(t + th) do |h, md|
      md << table_row(h.slice(*cols).values)
    end
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
