class CreateTranscripts < ActiveRecord::Migration[6.1]
  def change
    create_table :transcripts do |t|
      t.belongs_to :officer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
