class CreateUserPermission < ActiveRecord::Migration[7.0]
  def change
    create_table :user_permissions do |t|
      t.boolean :is_active, null: false, default: false

      t.references :user_authorization, null: false, foreign_key: true
      t.references :permission_object, null: false, foreign_key: true

      t.datetime :discarded_at
      t.timestamps
    end
  end
end
