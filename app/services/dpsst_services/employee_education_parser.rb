class DpsstServices::EmployeeEducationParser
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def process
    records = []

    table_selector = 'table#ContentPlaceHolder1_ctlEmployeeEducation_gvwGrid'
    rows = doc.css("#{table_selector} tr")
    rows.each do |row|
      cells = row.css('td')

      if cells.count == 5
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
        record[:degree] = text
      when 2
        record[:school] = text
      when 3
        record[:major] = text
      when 4
        record[:hours] = text
      else
        Rails.logger.error("Wrong number of cells processed in #{self.class}. index: #{index}. data: #{text}")
      end
    end

    record
  end

end
