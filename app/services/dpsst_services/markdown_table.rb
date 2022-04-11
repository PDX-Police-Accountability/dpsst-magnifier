module DpsstServices::MarkdownTable

  def table_header(columns, column_header_transformation = nil)
    cols = columns.map do |col|
      if column_header_transformation
        self.send(column_header_transformation, col)
      else
        col.to_s
      end
    end

    dashes = columns.map do |col|
      ''.ljust(col.length, '-')
    end

    first_row = '| ' + cols.join(' | ') + ' |'
    second_row = '| ' + dashes.join(' | ') + ' |'

    first_row + "\n" + second_row + "\n"
  end

  def table_row(cells)
    '| ' + cells.join(' | ') + ' |' + "\n"
  end

  def array_to_table_markdown(title, cols, a, column_header_transformation = nil)
    t = "## #{title}" + "\n"
    th = table_header(cols, column_header_transformation)

    a.each_with_object(t + th) do |h, md|
      md << table_row(h.slice(*cols).values)
    end
  end

end
