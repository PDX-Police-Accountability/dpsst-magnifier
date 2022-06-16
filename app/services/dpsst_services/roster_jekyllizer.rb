class DpsstServices::RosterJekyllizer
  include DpsstServices::DpsstIdentifier

  attr_reader :yaml_dir
  attr_reader :jekyll_yaml_dir
  attr_reader :jekyll_officer_collection_dir

  def initialize(yaml_dir, jekyll_yaml_dir, jekyll_officer_collection_dir)
    @yaml_dir = yaml_dir
    @jekyll_yaml_dir = jekyll_yaml_dir
    @jekyll_officer_collection_dir = jekyll_officer_collection_dir
  end

  def execute
    Dir.glob("#{yaml_dir}/*-transcript.yml").sort.each do |filename|
      dpsst_id = extract_id_from_filename(filename)

      FileUtils.cp(filename, "#{jekyll_yaml_dir}/#{dpsst_id}.yml")
      write_jekyll_officer_file(dpsst_id)
    end

    nil
  end

  def write_jekyll_officer_file(dpsst_id)
    filename = "#{jekyll_officer_collection_dir}/#{dpsst_id}.md"

    file_contents = <<~CONTENTS
      ---
      layout: default
      dpsst_identifier: '#{dpsst_id}'
      ---
      {% include officer.md %}
    CONTENTS

    File.write(filename, file_contents)
  end

end
