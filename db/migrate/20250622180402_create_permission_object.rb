class CreatePermissionObject < ActiveRecord::Migration[7.0]
  def change
    create_table :permission_objects do |t|
      t.string :name, null: false
      t.string :identifier, null: false
      t.string :object_type, null: false

      t.datetime :discarded_at
      t.timestamps
    end
  end
end
