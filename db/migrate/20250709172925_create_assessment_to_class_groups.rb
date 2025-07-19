class CreateAssessmentToClassGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :assessment_to_class_groups do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :class_group, null: false, foreign_key: true
      t.datetime :due_date, null: false
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :assessment_to_class_groups, [:assessment_id, :class_group_id], unique: true, name: 'idx_on_assessment_and_class_group'
    add_index :assessment_to_class_groups, :discarded_at
  end
end
