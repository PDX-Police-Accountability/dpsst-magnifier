#!/bin/bash

yamlize_directory() {
  date_string=$1
  data_project_dir="../dpsst-data"
  output_dir="$data_project_dir/officers/yaml"
  input_dir="../dpsst-scraper/scraped-data/$date_string"

  bin/rake dpsst:yamlize_directory[$input_dir,$date_string,$output_dir]

  pushd $data_project_dir
  git add .
  git commit -m "Yamlized on $date_string."
  git tag "yamlized-$date_string"
  popd
}


do_yamlize() {
  date_string=$1
  dpsst_id=$2
  data_project_dir="../dpsst-data"
  output_dir="$data_project_dir/officers/yaml"

  bundle exec rails dpsst:yamlize_one[../dpsst-scraper/scraped-data/$date_string/$dpsst_id-transcript.html,$date_string,$output_dir/outieout-$dpsst_id.yml]

  pushd $data_project_dir
  git add .
  git commit -m "Scraped on $date_string."
  popd
}

if [ $# -ne 1 ]; then
  echo "Usage: $0 date-string"
else
  echo "Yamlizing: $1"
  yamlize_directory $1
fi
