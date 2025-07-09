class CreateAssessmentByStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :assessment_by_students do |t|
      t.references :student, null: false, foreign_key: true
      t.references :assessment_to_class_group, null: false, foreign_key: true
      t.float :score
      t.string :status, default: 'not_started', null: false
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :assessment_by_students, [:student_id, :assessment_to_class_group_id], unique: true, name: 'idx_on_student_and_assessment_to_class_group'
    add_index :assessment_by_students, :discarded_at
  end
end
