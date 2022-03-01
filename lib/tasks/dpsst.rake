namespace :dpsst do
  desc "Parse a single DPSST transcript"

  task :parse_one, [:filename] => [:environment] do |t, args|
    filename = args[:filename]
    result = read_transcript_file(filename)
    pp result
  end

  task :persist_one, [:filename] => [:environment] do |t, args|
    filename = args[:filename]
    result = read_transcript_file(filename)
    persister = DpsstServices::TranscriptPersister.new(result)
    persister.persist
  end

  def read_transcript_file(filename)
    puts "==> Begin read_transcript_file: #{filename}"

    reader = DpsstServices::TranscriptReader.new(filename)
    reader.load_file
    result = reader.process

    puts "==> End read_transcript_file: #{filename}"

    result
  end

end
