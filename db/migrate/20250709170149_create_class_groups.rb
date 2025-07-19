class CreateClassGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :class_groups do |t|
      t.string :name, null: false
      t.text :description
      t.string :class_identifier, null: false
      t.string :period, null: false
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :class_groups, [:class_identifier, :period], unique: true
    add_index :class_groups, :discarded_at
  end
end
