class DpsstServices::TranscriptSummarizer
  include DpsstServices::MarkdownTable

  attr_reader :scraped_on
  attr_reader :yaml_dir
  attr_reader :markdown_dir
  attr_reader :summary_dir
  attr_reader :columns
  attr_reader :ignored_columns

  def initialize(scraped_on, yaml_dir, markdown_dir, summary_dir)
    @scraped_on = scraped_on
    @yaml_dir = yaml_dir
    @markdown_dir = markdown_dir
    @summary_dir = summary_dir
    @columns = [:name, :dpsst_identifier, :agency, :employment_status, :rank]
    @ignored_columns = [:level, :classification, :assignment]
  end

  def execute
    records = ingest_transcripts

    columns.each do |col|
      puts "--> Doing #{col} with #{records.count} records..."
      write_summary_file(columns, records, col)
    end
  end

  def write_summary_file(columns, records, sort_column)
    title = "Transcripts (sorted by #{sort_column.to_s.humanize.downcase})"
    md = array_to_table_markdown(title, columns, records.sort_by { |h| h[sort_column] }, :column_header_transform )
    File.write(output_filename_for_sort_column(sort_column), md)
  end

  def ingest_transcripts
    Dir.glob("#{yaml_dir}/*-transcript.yml").sort.map do |filename|
      dpsst_id = extract_dpsst_id(filename)
      yaml = YAML.load_file(filename)

      record = if yaml[:missing_transcript]
                 missing_transcript_record(dpsst_id)
               else
                 yaml[:header_record].reject { |key, _val| ignored_columns.include?(key) }
               end

      record[:dpsst_identifier] = link_to_markdown(record[:dpsst_identifier])
      record
    end
  end

  def missing_transcript_record(dpsst_id)
    {
      name: '* MISSING TRANSCRIPT',
      dpsst_identifier: dpsst_id,
      agency: '',
      employment_status: '',
      rank: ''
    }
  end

  def extract_dpsst_id(filename)
    m = /\/(\d*)-transcript.yml/.match(filename)
    m.captures.first
  end

  def link_to_markdown(dpsst_identifier)
    "[#{dpsst_identifier}](../markdown/#{dpsst_identifier}-transcript.md)"
  end

  def link_to_yaml(dpsst_identifier)
    "[#{dpsst_identifier}](../yaml/#{dpsst_identifier}-transcript.yml)"
  end

  def output_filename_for_sort_column(col)
    "#{summary_dir}/officer-transcripts-by-#{col.to_s.dasherize}.md"
  end

  def column_header_transform(col)
    "[#{col.to_s.humanize.downcase}](./officer-transcripts-by-#{col.to_s.dasherize}.md)"
  end

end
