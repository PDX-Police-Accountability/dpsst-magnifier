class DpsstServices::TranscriptReader
  attr_reader :doc
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def load_file
    @doc = File.open(filename) { |f| Nokogiri::XML(f) }    
    nil
  end

  def process
    process_header
    nil
  end

  def process_header
    process_left_header
    process_right_header
    nil
  end

  def process_left_header
    cells = cells_from_table('table#ContentPlaceHolder1_ctlEmployeeHeader_tblHeaderLeft')
    p cells

    name_and_id = cells[0].split('ID:')
    name = name_and_id[0].strip_whitespace
    dpsst_identifier = name_and_id[1].strip_whitespace
    organization = cells[1]
    status = cells[2]

    puts "name: #{name}"
    puts "dpsst_identifier: #{dpsst_identifier}"
    puts "organization: #{organization}"
    puts "status: #{status}"

    log_message("#{cells.count} cells in the left employeeheader table - expecting 4") if cells.count != 4
    nil
  end

  def process_right_header
    cells = cells_from_table('table#ContentPlaceHolder1_ctlEmployeeHeader_tblHeaderRight')
    p cells

    log_message("#{cells.count} cells in the right employeeheader table - expecting 8") if cells.count != 8
    nil
  end

  def cells_from_table(table_selector)
    cells = doc.css("#{table_selector} tr td")
    cells.map { |cell| cell.text.strip_whitespace }
  end

  def log_message(message)
    puts message
  end

end
