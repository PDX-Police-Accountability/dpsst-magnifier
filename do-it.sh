#!/bin/bash

do_yamlize() {
  echo "Argument 1 is $1"
  echo "Argument 2 is $2"

  date_string=$1
  dpsst_id=$2

	bundle exec rails dpsst:yamlize_one[../dpsst-scraper/scraped-data/$date_string/$dpsst_id-transcript.html,$date_string,../dpsst-data/officers/yaml/outieout-$dpsst_id.yml]
	git add .
	git commit -m "Scraped on $date_string."
}

do_yamlize 2022-02-09 53862
do_yamlize 2022-02-11 53862
do_yamlize 2022-02-15 53862
do_yamlize 2022-02-16 53862
do_yamlize 2022-02-17 53862
do_yamlize 2022-02-18 53862
do_yamlize 2022-02-19 53862
do_yamlize 2022-02-26 53862
do_yamlize 2022-02-27 53862
do_yamlize 2022-03-01 53862
do_yamlize 2022-03-02 53862
do_yamlize 2022-03-09 53862
do_yamlize 2022-03-13 53862


do_yamlize 2022-02-09 60144
do_yamlize 2022-02-11 60144
do_yamlize 2022-02-15 60144
do_yamlize 2022-02-16 60144
do_yamlize 2022-02-17 60144
do_yamlize 2022-02-18 60144
do_yamlize 2022-02-19 60144
do_yamlize 2022-02-26 60144
do_yamlize 2022-02-27 60144
do_yamlize 2022-03-01 60144
do_yamlize 2022-03-02 60144
do_yamlize 2022-03-09 60144
do_yamlize 2022-03-13 60144
