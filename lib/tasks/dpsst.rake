namespace :dpsst do
  desc "Parse a single DPSST transcript"

  task :parse_one, [:filename] => [:environment] do |t, args|
    filename = args[:filename]
    result = read_transcript_file(filename)
    pp result
  end

  task :persist_one, [:filename, :scraped_on] => [:environment] do |t, args|
    filename = args[:filename]
    scraped_on = Date.parse(args[:scraped_on])
    read_and_persist_transcript_file(filename, scraped_on)
  end

  task :yamlize_one, [:filename, :scraped_on, :output_filename] => [:environment] do |t, args|
    filename = args[:filename]
    output_filename = args[:output_filename]
    scraped_on = Date.parse(args[:scraped_on])
    read_and_yamlize_transcript_file(filename, scraped_on, output_filename)
  end

  task :process_directory, [:directoryname, :scraped_on] => [:environment] do |t, args|
    directoryname = args[:directoryname]
    scraped_on = Date.parse(args[:scraped_on])
    process_directory(directoryname, scraped_on)
  end

  def read_transcript_file(filename)
    puts "==> Begin read_transcript_file: #{filename}"

    reader = DpsstServices::TranscriptReader.new(filename)
    reader.load_file
    result = reader.process

    puts "==> End read_transcript_file: #{filename}"

    result
  end

  def read_and_persist_transcript_file(filename, scraped_on)
    result = read_transcript_file(filename)
    persister = DpsstServices::TranscriptPersister.new(result, scraped_on)
    persister.persist
  end

  def read_and_yamlize_transcript_file(filename, scraped_on, output_filename)
    result = read_transcript_file(filename)
    yamlizer = DpsstServices::Transcriptyamlizer.new(result, scraped_on, output_filename)
    yamlizer.execute
  end

  def process_directory(directoryname, scraped_on)
    Dir.glob("#{directoryname}/*-transcript.html").each do |filename|
      read_and_persist_transcript_file(filename, scraped_on)
    end
  end

end
