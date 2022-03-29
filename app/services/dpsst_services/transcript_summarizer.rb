class DpsstServices::TranscriptSummarizer
  include DpsstServices::MarkdownTable

  attr_reader :scraped_on
  attr_reader :yaml_dir
  attr_reader :markdown_dir
  attr_reader :summary_dir
  attr_reader :output_filename

  def initialize(scraped_on, yaml_dir, markdown_dir, summary_dir)
    @scraped_on = scraped_on
    @yaml_dir = yaml_dir
    @markdown_dir = markdown_dir
    @summary_dir = summary_dir
    @output_filename = "#{summary_dir}/officer-transcripts.md"
  end

  def execute
    title = 'Transcripts'
    cols = [:name, :dpsst_identifier, :agency, :employment_status, :rank]
    ignored_cols = [:level, :classification, :assignment]

    rows = summarize_transcripts(ignored_cols)

    rows.each do |row|
      row[:dpsst_identifier] = link_to_markdown(row[:dpsst_identifier])
    end

    md = array_to_table_markdown(title, cols, rows)
    File.write(output_filename, md)
  end

  def summarize_transcripts(ignored_cols)
    Dir.glob("#{yaml_dir}/*-transcript.yml").sort.map do |filename|
      dpsst_id = extract_dpsst_id(filename)
      yaml = YAML.load_file(filename)

      if yaml[:missing_transcript]
        { name: 'MISSING', dpsst_identifier: dpsst_id }
      else
        yaml[:header_record].reject { |key, _val| ignored_cols.include?(key) }
      end
    end
  end

  def extract_dpsst_id(filename)
    m = /\/(\d*)-transcript.yml/.match(filename)
    m.captures.first
  end

  def link_to_markdown(dpsst_identifier)
    "[#{dpsst_identifier}](../markdown/#{dpsst_identifier}-transcript.md)"
  end

end
