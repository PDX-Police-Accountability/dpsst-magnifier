#!/bin/bash
#
# Example usage
#
# Initial processing:
#
#   processor.sh 2022-07-14
#
# Reprocessing:
#
#   processor.sh 2022-07-14 again
#
# Where the 2022-07-14 represents, not only the date, but also
# the inner level input directory name.
#
# The word "again" (or really any string) as the 2nd argument should
# be used when the data is being re-processed, usually due to some
# number of missing transcripts.

tag_commit_push() {
  data_project_dir=$1
  commit_message=$2
  git_tag=$3

  pushd $data_project_dir
  git add .
  git commit -m "$commit_message"
  git tag "$git_tag"
  git push
  git push --tags
  popd
}

do_processing() {
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
}

process_directory() {
  date_string=$1
  data_project_dir="../dpsst-data"

  do_processing $date_string
  tag_commit_push $data_project_dir "Processed on $date_string." "processed-$date_string"
}

reprocess_directory() {
  date_string=$1
  data_project_dir="../dpsst-data"
  current_time_string=`date '+%F-%H-%M-%S'`

  do_processing $date_string
  tag_commit_push $data_project_dir "Reprocessed $date_string: $current_time_string." "reprocessed-$date_string-on-$current_time_string"
}

if [ $# -eq 1 ]; then
  echo "Processing: $1"
  process_directory $1
elif [ $# -eq 2 ]; then
  echo "Re-processing: $1"
  reprocess_directory $1
else
  echo "Usage: $0 date-string"
fi
