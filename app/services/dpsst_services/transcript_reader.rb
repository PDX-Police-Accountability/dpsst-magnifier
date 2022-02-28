class DpsstServices::TranscriptReader
  attr_reader :doc
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def load_file
    @doc = File.open(filename) { |f| Nokogiri::XML(f) }    
  end

  def process
    process_header.
      merge(process_employment_history)
  end

  def process_employment_history
    attributes = {
      employment_placeholder: 'Coming Soon'
    }

    attributes
  end

  def process_header
    attributes = process_left_header
    attributes.merge(process_right_header)
  end

  def process_left_header
    cells = cells_from_table('table#ContentPlaceHolder1_ctlEmployeeHeader_tblHeaderLeft')
    log_message("#{cells.count} cells in the left employeeheader table - expecting 4") if cells.count != 4

    name_and_id = cells[0].split('ID:')
    name = name_and_id[0].strip_whitespace
    dpsst_identifier = name_and_id[1].strip_whitespace
    agency = cells[1]
    employment_status = parse_employment_status(cells[2])

    {
      name: name,
      dpsst_identifier: dpsst_identifier,
      agency: agency,
      employment_status: employment_status
    }
  end

  def process_right_header
    cells = cells_from_table('table#ContentPlaceHolder1_ctlEmployeeHeader_tblHeaderRight')
    log_message("#{cells.count} cells in the right employeeheader table - expecting 8") if cells.count != 8

    rank = cells[1].strip_whitespace if /rank/i.match(cells[0])
    level = cells[3].strip_whitespace if /level/i.match(cells[2])
    classification = cells[5].strip_whitespace if /class/i.match(cells[4])
    assignment = cells[7].strip_whitespace if /assign/i.match(cells[6])

    {
      rank: rank,
      level: level,
      classification: classification,
      assignment: assignment
    }
  end

  def cells_from_table(table_selector)
    cells = doc.css("#{table_selector} tr td")
    cells.map { |cell| cell.text.strip_whitespace }
  end

  def log_message(message)
    puts "===> #{message}"
  end

  def log_error(error)
    puts "err> #{error}"
  end

  def parse_employment_status(s)
    s.split(':')[1].to_s.strip_whitespace
  end

end
