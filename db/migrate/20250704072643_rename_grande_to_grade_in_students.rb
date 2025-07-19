class RenameGrandeToGradeInStudents < ActiveRecord::Migration[7.0]
  def change
    rename_column :students, :grande, :grade
  end
end
