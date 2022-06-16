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

  task :markdown_one, [:filename, :scraped_on, :output_filename] => [:environment] do |t, args|
    filename = args[:filename]
    output_filename = args[:output_filename]
    scraped_on = Date.parse(args[:scraped_on])
    read_and_markdown_transcript_file(filename, scraped_on, output_filename)
  end

  task :persist_directory, [:directoryname, :scraped_on] => [:environment] do |t, args|
    directoryname = args[:directoryname]
    scraped_on = Date.parse(args[:scraped_on])
    persist_directory(directoryname, scraped_on)
  end

  task :yamlize_directory, [:directoryname, :scraped_on, :output_directoryname] => [:environment] do |t, args|
    directoryname = args[:directoryname]
    output_directoryname = args[:output_directoryname]
    scraped_on = Date.parse(args[:scraped_on])
    yamlize_directory(directoryname, scraped_on, output_directoryname)
  end

  task :markdown_directory, [:directoryname, :scraped_on, :output_directoryname] => [:environment] do |t, args|
    directoryname = args[:directoryname]
    output_directoryname = args[:output_directoryname]
    scraped_on = Date.parse(args[:scraped_on])
    markdown_directory(directoryname, scraped_on, output_directoryname)
  end

  task :summarize_directories, [:scraped_on, :yaml_dir, :summary_dir] => [:environment] do |t, args|
    scraped_on = Date.parse(args[:scraped_on])
    yaml_dir = args[:yaml_dir]
    summary_dir = args[:summary_dir]
    summarizer = DpsstServices::TranscriptSummarizer.new(scraped_on, yaml_dir, summary_dir)
    summarizer.execute
  end

  task :summarize_training, [:scraped_on, :yaml_dir, :summary_dir] => [:environment] do |t, args|
    scraped_on = Date.parse(args[:scraped_on])
    yaml_dir = args[:yaml_dir]
    summary_dir = args[:summary_dir]
    summarizer = DpsstServices::TrainingSummarizer.new(scraped_on, yaml_dir, summary_dir)
    summarizer.execute
  end

  task :jekyllize_roster, [:yaml_dir, :jekyll_yaml_dir, :jekyll_officer_collection_dir] => [:environment] do |t, args|
    yaml_dir = args[:yaml_dir]
    jekyll_yaml_dir = args[:jekyll_yaml_dir]
    jekyll_officer_collection_dir = args[:jekyll_officer_collection_dir]
    jekyllizer = DpsstServices::RosterJekyllizer.new(yaml_dir, jekyll_yaml_dir, jekyll_officer_collection_dir)
    jekyllizer.execute
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
    yamlizer = DpsstServices::TranscriptYamlizer.new(result, scraped_on, output_filename)
    yamlizer.execute
  end

  def read_and_markdown_transcript_file(filename, scraped_on, output_filename)
    result = read_transcript_file(filename)
    markdowner = DpsstServices::TranscriptMarkdowner.new(result, scraped_on, output_filename)
    markdowner.execute
  end

  def persist_directory(directoryname, scraped_on)
    Dir.glob("#{directoryname}/*-transcript.html").each do |filename|
      read_and_persist_transcript_file(filename, scraped_on)
    end
  end

  def yamlize_directory(directoryname, scraped_on, output_directoryname)
    Dir.glob("#{directoryname}/*-transcript.html").each do |filename|
      output_filename = transform_full_path_to_file(filename, output_directoryname, 'yml')
      read_and_yamlize_transcript_file(filename, scraped_on, output_filename)
    end
  end

  def markdown_directory(directoryname, scraped_on, output_directoryname)
    Dir.glob("#{directoryname}/*-transcript.html").each do |filename|
      output_filename = transform_full_path_to_file(filename, output_directoryname, 'md')
      read_and_markdown_transcript_file(filename, scraped_on, output_filename)
    end
  end

  def transform_full_path_to_file(filename, output_directory, output_extension)
    output_directory + '/' + File.basename(filename, '.*') + '.' + output_extension
  end

end
