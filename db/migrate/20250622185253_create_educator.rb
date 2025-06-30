class CreateEducator < ActiveRecord::Migration[7.0]
  def change
    create_table :educators do |t|
      t.string :name, null: false
      t.string :identifier
      t.string :institution
      t.string :document_type
      t.string :document_number

      t.datetime :discarded_at
      t.timestamps
    end
  end
end
