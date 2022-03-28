#!/bin/bash

process_directory() {
  date_string=$1
  data_project_dir="../dpsst-data"
  input_dir="../dpsst-scraper/scraped-data/$date_string"
  yaml_output_dir="$data_project_dir/officers/yaml"
  markdown_output_dir="$data_project_dir/officers/markdown"

  bin/rake dpsst:yamlize_directory[$input_dir,$date_string,$yaml_output_dir]
  bin/rake dpsst:markdown_directory[$input_dir,$date_string,$markdown_output_dir]

  pushd $data_project_dir
  git add .
  git commit -m "Processed on $date_string."
  git tag "processed-$date_string"
  git push
  git push --tags
  popd
}

if [ $# -ne 1 ]; then
  echo "Usage: $0 date-string"
else
  echo "Processing: $1"
  process_directory $1
fi
