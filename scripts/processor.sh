#!/bin/bash

process_directory() {
  date_string=$1
  data_project_dir="../dpsst-data"
  input_dir="../dpsst-scraper/scraped-data/$date_string"
  yaml_dir="$data_project_dir/officers/yaml"
  markdown_dir="$data_project_dir/officers/markdown"
  summary_dir="$data_project_dir/officers/summary"
  jekyll_api_data_dir="$data_project_dir/docs/api-data"
  jekyll_yaml_dir="$data_project_dir/docs/_data/officers"
  jekyll_officer_collection_dir="$data_project_dir/docs/_officers"

  bin/rake dpsst:yamlize_directory[$input_dir,$date_string,$yaml_dir]
  bin/rake dpsst:markdown_directory[$input_dir,$date_string,$markdown_dir]
  bin/rake dpsst:summarize_directories[$date_string,$yaml_dir,$summary_dir]
  bin/rake dpsst:summarize_training[$date_string,$yaml_dir,$summary_dir]
  bin/rake dpsst:jekyllize_roster[$yaml_dir,$jekyll_yaml_dir,$jekyll_officer_collection_dir]

  cp -p $summary_dir/*.json $jekyll_api_data_dir

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
