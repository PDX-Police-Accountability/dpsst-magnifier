namespace :dpsst do
  desc "Parse a single DPSST transcript"

  task :parse_one, [:filename] => [:environment] do |t, args|
    filename = args[:filename]
    puts "==> Begin parsing #{filename}"

    reader = DpsstServices::TranscriptReader.new(filename)
    reader.load_file
    results = reader.process
    pp results

    puts "==> End parsing #{filename}"
  end

end
