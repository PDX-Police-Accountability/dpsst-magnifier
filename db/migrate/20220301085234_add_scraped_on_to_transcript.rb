class AddScrapedOnToTranscript < ActiveRecord::Migration[6.1]
  def change
    add_column :transcripts, :scraped_on, :date, null: false
    add_index :transcripts, :scraped_on
  end
end
