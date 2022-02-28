class DpsstServices::EmploymentParser
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def process
    records = []

    table_selector = 'table#ContentPlaceHolder1_ctlEmploymentHistory_gvwGrid'
    rows = doc.css("#{table_selector} tr")
    rows.each do |row|
      cells = row.css('td')

      if cells.count == 6
        records << process_row(cells)
      end
    end

    records
  end

  def process_row(cells)
    record = {}

    cleaned_cells = cells.map { |cell| cell.text.strip_whitespace }

    cleaned_cells.each_with_index do |text, index|
      case index
      when 0
        record[:date] = text
      when 1
        record[:agency] = text
      when 2
        record[:action] = text
      when 3
        record[:rank] = text
      when 4
        record[:classification] = text
      when 5
        record[:assignment] = text
      else
        log_error("Wrong number of cells in employment history. index: #{index}. data: #{text}")
      end
    end

    record
  end

end
