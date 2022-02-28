class CreateOfficers < ActiveRecord::Migration[6.1]
  def change
    create_table :officers do |t|
      t.string :dpsst_identifier

      t.timestamps
    end
  end
end
