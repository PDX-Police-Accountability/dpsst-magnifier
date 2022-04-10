class DpsstServices::TrainingSummarizer
  include DpsstServices::DpsstIdentifier

  attr_reader :scraped_on
  attr_reader :yaml_dir
  attr_reader :summary_dir
  attr_reader :output_filename
  attr_reader :columns

  def initialize(scraped_on, yaml_dir, summary_dir)
    @scraped_on = scraped_on
    @yaml_dir = yaml_dir
    @summary_dir = summary_dir
    @output_filename = "#{summary_dir}/officer-training-records.tsv"
    @columns = [:dpsst_identifier, :date, :course, :title, :status, :score, :hours]
  end

  def execute
    records = ingest_training_records
    write_training_tsv(columns, records)
    nil
  end

  def write_training_tsv(cols, records)
    headers = cols.map(&:to_s)

    CSV.open(output_filename, "w", col_sep: "\t") do |tsv|
      tsv << headers
      records.each do |row|
        tsv << row
      end
    end
  end

  def ingest_training_records
    Dir.glob("#{yaml_dir}/*-transcript.yml").sort.each_with_object([]) do |filename, records|
      dpsst_id = extract_id_from_filename(filename)
      yaml = YAML.load_file(filename)

      next if yaml[:training_records].blank?

      yaml[:training_records].each do |record|
        records << [dpsst_id].concat(record.values)
      end

      records
    end
  end

end
