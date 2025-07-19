class CreateQuestionAlternatives < ActiveRecord::Migration[7.0]
  def change
    create_table :question_alternatives do |t|
      t.text :sentence, null: false
      t.boolean :is_correct, default: false, null: false
      t.references :question, null: false, foreign_key: true
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :question_alternatives, :discarded_at
  end
end
