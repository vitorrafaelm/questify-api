class CreateQuestionsInAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :questions_in_assessments do |t|
      t.references :question, null: false, foreign_key: true
      t.references :assessment, null: false, foreign_key: true

      t.timestamps
    end
    add_index :questions_in_assessments, [:question_id, :assessment_id], unique: true
  end
end
