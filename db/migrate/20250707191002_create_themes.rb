class CreateThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :themes do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :themes, :title, unique: true
    add_index :themes, :discarded_at
  end
end