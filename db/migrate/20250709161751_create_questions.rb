class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :is_public, default: false, null: false
      t.string :question_type, null: false
      t.references :educator, null: false, foreign_key: true
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :questions, :discarded_at
  end
end
