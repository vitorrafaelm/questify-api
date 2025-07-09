class CreateAssessmentAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :assessment_answers do |t|
      t.references :assessment_by_student, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :question_alternative, null: true, foreign_key: true
      t.text :answer_text
      t.boolean :is_correct

      t.timestamps
    end
    add_index :assessment_answers, [:assessment_by_student_id, :question_id], unique: true, name: 'idx_on_assessment_by_student_and_question'
  end
end
