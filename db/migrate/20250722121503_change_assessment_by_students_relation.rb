class ChangeAssessmentByStudentsRelation < ActiveRecord::Migration[7.0]
  def up
    # Add the new assessment_id column
    add_reference :assessment_by_students, :assessment, null: false, foreign_key: true

    # Remove the old foreign key and column (this will also remove associated indexes)
    remove_foreign_key :assessment_by_students, :assessment_to_class_groups
    remove_column :assessment_by_students, :assessment_to_class_group_id

    # Add the new unique index
    add_index :assessment_by_students, [:student_id, :assessment_id], unique: true, name: "idx_on_student_and_assessment"
  end

  def down
    # Add back the assessment_to_class_group_id column
    add_reference :assessment_by_students, :assessment_to_class_group, null: false, foreign_key: true

    # This is a destructive rollback - we can't perfectly restore the original relationship
    # You would need to manually populate assessment_to_class_group_id if you need to rollback

    # Remove the new assessment relationship
    remove_foreign_key :assessment_by_students, :assessments
    remove_column :assessment_by_students, :assessment_id

    # Restore the old unique index
    remove_index :assessment_by_students, name: "idx_on_student_and_assessment"
    add_index :assessment_by_students, [:student_id, :assessment_to_class_group_id], unique: true, name: "idx_on_student_and_assessment_to_class_group"
  end
end
