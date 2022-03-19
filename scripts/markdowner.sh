#!/bin/bash

markdown_directory() {
  date_string=$1
  data_project_dir="../dpsst-data"
  output_dir="$data_project_dir/officers/markdown"
  input_dir="../dpsst-scraper/scraped-data/$date_string"

  bin/rake dpsst:markdown_directory[$input_dir,$date_string,$output_dir]

  pushd $data_project_dir
  git add .
  git commit -m "Marked down on $date_string."
  git tag "markdown-$date_string"
  popd
}

if [ $# -ne 1 ]; then
  echo "Usage: $0 date-string"
else
  echo "Marking down: $1"
  markdown_directory $1
fi
