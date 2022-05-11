class DpsstServices::TranscriptSummarizer
  include DpsstServices::MarkdownTable
  include DpsstServices::DpsstIdentifier

  attr_reader :scraped_on
  attr_reader :yaml_dir
  attr_reader :summary_dir
  attr_reader :columns
  attr_reader :ignored_columns

  def initialize(scraped_on, yaml_dir, summary_dir)
    @scraped_on = scraped_on
    @yaml_dir = yaml_dir
    @summary_dir = summary_dir
    @columns = [:name, :dpsst_identifier, :agency, :employment_status, :rank]
    @ignored_columns = [:level, :classification, :assignment]
  end

  def execute
    records = ingest_transcripts

    columns.each do |col|
      puts "--> Doing #{col} with #{records.count} records..."
      write_summary_markdown_file(columns, records, col)
    end

    write_summary_json_data_array(columns, records)
    write_summary_tsv_all(columns, records)
    write_summary_tsv_active(columns, records)
    write_summary_tsv_inactive(columns, records)
    nil
  end

  def write_summary_json_data_array(cols, records)
    filename = "#{summary_dir}/officer-transcripts.json"

    a = records.map do |row|
      row.values[0..-2] # Leave off the :links column
    end

    File.open(filename, "w") do |f|
      f.write({ data: a }.to_json)
    end
  end

  def write_tsv(filename, cols, records)
    headers = cols.map(&:to_s)

    CSV.open(filename, "w", col_sep: "\t") do |tsv|
      tsv << headers
      records.each do |row|
        tsv << row.values[0..-2] # Leave off the :links column
      end
    end
  end

  def write_summary_tsv_all(cols, records)
    write_tsv("#{summary_dir}/officer-transcripts.tsv", cols, records)
  end

  def write_summary_tsv_active(cols, records)
    write_tsv("#{summary_dir}/officer-transcripts-active.tsv", cols, records.select { |row| row[:employment_status].casecmp('active') == 0 })
  end

  def write_summary_tsv_inactive(cols, records)
    write_tsv("#{summary_dir}/officer-transcripts-inactive.tsv", cols, records.select { |row| row[:employment_status].casecmp('inactive') == 0 })
  end

  def write_summary_markdown_file(cols, records, sort_column)
    table_columns = cols + [:links]

    title = "Transcripts (sorted by #{sort_column.to_s.humanize.downcase})"
    md = array_to_table_markdown(title, table_columns, records.sort_by { |h| h[sort_column] }, :column_header_transform )
    File.write(output_filename_for_sort_column(sort_column), md)
  end

  def ingest_transcripts
    Dir.glob("#{yaml_dir}/*-transcript.yml").sort.map do |filename|
      dpsst_id = extract_id_from_filename(filename)
      yaml = YAML.load_file(filename)

      record = if yaml[:missing_transcript]
                 missing_transcript_record(dpsst_id)
               else
                 yaml[:header_record].reject { |key, _val| ignored_columns.include?(key) }
               end

      record[:links] = file_links(record[:dpsst_identifier])
      record
    end
  end

  def missing_transcript_record(dpsst_id)
    {
      name: '* MISSING',
      dpsst_identifier: dpsst_id,
      agency: '',
      employment_status: '',
      rank: ''
    }
  end

  def link_to_markdown(dpsst_identifier)
    "[md](../markdown/#{dpsst_identifier}-transcript.md)"
  end

  def link_to_yaml(dpsst_identifier)
    "[yaml](../yaml/#{dpsst_identifier}-transcript.yml)"
  end

  def file_links(dpsst_identifier)
    [
      link_to_markdown(dpsst_identifier),
      link_to_yaml(dpsst_identifier)
    ].join(' - ')
  end

  def output_filename_for_sort_column(col)
    "#{summary_dir}/officer-transcripts-by-#{col.to_s.dasherize}.md"
  end

  def column_header_transform(col)
    column_text = col.to_s.humanize.downcase

    if columns.include?(col)
      "[#{column_text}](./officer-transcripts-by-#{col.to_s.dasherize}.md)"
    else
      column_text
    end
  end

end
