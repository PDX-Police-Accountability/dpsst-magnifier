module DpsstServices::MarkdownTable

  def table_header(columns)
    first_row = '| ' + columns.join(' | ') + ' |'
    second_row = first_row.gsub(/[\w]/, '-')

    first_row + "\n" + second_row + "\n"
  end

  def table_row(cells)
    '| ' + cells.join(' | ') + ' |' + "\n"
  end

  def array_to_table_markdown(title, cols, a)
    t = "## #{title}" + "\n"
    th = table_header(cols.map(&:to_s))

    a.each_with_object(t + th) do |h, md|
      md << table_row(h.slice(*cols).values)
    end
  end

end
