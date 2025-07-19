class CreateStudentInClassGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :student_in_class_groups do |t|
      t.references :student, null: false, foreign_key: true
      t.references :class_group, null: false, foreign_key: true

      t.timestamps
    end
    add_index :student_in_class_groups, [:student_id, :class_group_id], unique: true
  end
end
