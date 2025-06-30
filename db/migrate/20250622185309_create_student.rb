class CreateStudent < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :identifier
      t.string :username
      t.string :institution
      t.string :document_type
      t.string :document_number
      t.string :grande

      t.datetime :discarded_at
      t.timestamps
    end
  end
end
