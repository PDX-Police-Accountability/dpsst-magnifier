# README

## dpsst-magnifier

The dpsst-magnifier is a Ruby on Rails project that transforms HTML pulled from Oregon's [Criminal Justice Information Records Inquiry System (CJ IRIS)](https://www.bpl-orsnapshot.net/PublicInquiry_CJ/EmployeeSearch.aspx) into multiple formats for ease of use by the general public.

All the data processed by the dpsst-magnifier is publicly accessible via the State of Oregon's [Department of Public Safety Standards & Training (DPSST)](https://www.oregon.gov/dpsst/pages/default.aspx) web site.

## Developer notes

### Getting started

TODO...

### Usage

Runs daily via cron as the last piece of the scraping and magnifying process.
<pre>
3 0 * * * BASH_ENV=~/.bashrc bash -l -c "cd /home/marc/work/dpsst-scraper && bundle exec ruby -r './dpsst_scraper.rb' -e 'scrape_dpsst'"
3 1 * * * BASH_ENV=~/.bashrc bash -l -c "cd /home/marc/work/dpsst-magnifier && ./scripts/processor.sh `date +\%F`"
</pre>
