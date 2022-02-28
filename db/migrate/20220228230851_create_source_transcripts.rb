class CreateSourceTranscripts < ActiveRecord::Migration[6.1]
  def change
    create_table :source_transcripts do |t|
      t.belongs_to :transcript, null: false, foreign_key: true
      t.text :data_hash

      t.timestamps
    end
  end
end
