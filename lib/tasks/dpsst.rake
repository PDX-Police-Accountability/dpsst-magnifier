namespace :dpsst do
  desc "Parse a single DPSST transcript"

  task :parse_one, [:filename] => [:environment] do |t, args|
    filename = args[:filename]


    puts "==> Parsing #{filename}"
  end

end
