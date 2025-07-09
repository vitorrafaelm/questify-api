class CreateAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :assessments do |t|
      t.string :title, null: false
      t.text :description
      t.references :educator, null: false, foreign_key: true
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :assessments, :discarded_at
  end
end
