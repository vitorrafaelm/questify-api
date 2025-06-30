class CreateUserAuthorization < ActiveRecord::Migration[7.0]
  def change
    create_table :user_authorizations do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :identifier

      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.string :state
      t.string :previous_state

      t.datetime :discarded_at
      t.timestamps

      t.references :user_authorizable, polymorphic: true
    end
  end
end
