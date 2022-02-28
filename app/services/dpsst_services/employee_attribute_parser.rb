class DpsstServices::EmployeeAttributeParser
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def process
    records = []

    table_selector = 'table#ContentPlaceHolder1_ctlEmployeeAttributes_gvwGrid'
    rows = doc.css("#{table_selector} tr")
    rows.each do |row|
      cells = row.css('td')

      if cells.count == 4
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
        record[:topic] = text
      when 1
        record[:value] = text
      when 2
        record[:effective_date] = text
      when 3
        record[:expiration_date] = text
      else
        Rails.logger.error("Wrong number of cells processed in #{self.class}. index: #{index}. data: #{text}")
      end
    end

    record
  end

end
