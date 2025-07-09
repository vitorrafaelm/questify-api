class CreateJoinTableQuestionsThemes < ActiveRecord::Migration[7.0]
  def change
    create_join_table :questions, :themes do |t|
      t.index [:question_id, :theme_id]
      t.index [:theme_id, :question_id]
    end
  end
end