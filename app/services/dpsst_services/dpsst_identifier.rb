module DpsstServices::DpsstIdentifier

  def extract_id_from_filename(filename)
    m = /\/(\d*)-transcript.yml/.match(filename)
    m.captures.first
  end

end
