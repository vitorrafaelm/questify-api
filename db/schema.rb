# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_07_09_174447) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessment_answers", force: :cascade do |t|
    t.bigint "assessment_by_student_id", null: false
    t.bigint "question_id", null: false
    t.bigint "question_alternative_id"
    t.text "answer_text"
    t.boolean "is_correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_by_student_id", "question_id"], name: "idx_on_assessment_by_student_and_question", unique: true
    t.index ["assessment_by_student_id"], name: "index_assessment_answers_on_assessment_by_student_id"
    t.index ["question_alternative_id"], name: "index_assessment_answers_on_question_alternative_id"
    t.index ["question_id"], name: "index_assessment_answers_on_question_id"
  end

  create_table "assessment_by_students", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "assessment_to_class_group_id", null: false
    t.float "score"
    t.string "status", default: "not_started", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_to_class_group_id"], name: "index_assessment_by_students_on_assessment_to_class_group_id"
    t.index ["discarded_at"], name: "index_assessment_by_students_on_discarded_at"
    t.index ["student_id", "assessment_to_class_group_id"], name: "idx_on_student_and_assessment_to_class_group", unique: true
    t.index ["student_id"], name: "index_assessment_by_students_on_student_id"
  end

  create_table "assessment_to_class_groups", force: :cascade do |t|
    t.bigint "assessment_id", null: false
    t.bigint "class_group_id", null: false
    t.datetime "due_date", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id", "class_group_id"], name: "idx_on_assessment_and_class_group", unique: true
    t.index ["assessment_id"], name: "index_assessment_to_class_groups_on_assessment_id"
    t.index ["class_group_id"], name: "index_assessment_to_class_groups_on_class_group_id"
    t.index ["discarded_at"], name: "index_assessment_to_class_groups_on_discarded_at"
  end

  create_table "assessments", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "educator_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_assessments_on_discarded_at"
    t.index ["educator_id"], name: "index_assessments_on_educator_id"
  end

  create_table "class_groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "class_identifier", null: false
    t.string "period", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_identifier", "period"], name: "index_class_groups_on_class_identifier_and_period", unique: true
    t.index ["discarded_at"], name: "index_class_groups_on_discarded_at"
  end

  create_table "educators", force: :cascade do |t|
    t.string "name", null: false
    t.string "identifier"
    t.string "institution"
    t.string "document_type"
    t.string "document_number"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permission_objects", force: :cascade do |t|
    t.string "name", null: false
    t.string "identifier", null: false
    t.string "object_type", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_alternatives", force: :cascade do |t|
    t.text "sentence", null: false
    t.boolean "is_correct", default: false, null: false
    t.bigint "question_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_question_alternatives_on_discarded_at"
    t.index ["question_id"], name: "index_question_alternatives_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.boolean "is_public", default: false, null: false
    t.string "question_type", null: false
    t.bigint "educator_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_questions_on_discarded_at"
    t.index ["educator_id"], name: "index_questions_on_educator_id"
  end

  create_table "questions_in_assessments", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "assessment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_questions_in_assessments_on_assessment_id"
    t.index ["question_id", "assessment_id"], name: "index_questions_in_assessments_on_question_id_and_assessment_id", unique: true
    t.index ["question_id"], name: "index_questions_in_assessments_on_question_id"
  end

  create_table "questions_themes", id: false, force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "theme_id", null: false
    t.index ["question_id", "theme_id"], name: "index_questions_themes_on_question_id_and_theme_id"
    t.index ["theme_id", "question_id"], name: "index_questions_themes_on_theme_id_and_question_id"
  end

  create_table "student_in_class_groups", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "class_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_group_id"], name: "index_student_in_class_groups_on_class_group_id"
    t.index ["student_id", "class_group_id"], name: "index_student_in_class_groups_on_student_id_and_class_group_id", unique: true
    t.index ["student_id"], name: "index_student_in_class_groups_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.string "username"
    t.string "institution"
    t.string "document_type"
    t.string "document_number"
    t.string "grade"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "themes", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_themes_on_discarded_at"
    t.index ["title"], name: "index_themes_on_title", unique: true
  end

  create_table "user_authorizations", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "identifier"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "state"
    t.string "previous_state"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_authorizable_type"
    t.bigint "user_authorizable_id"
    t.index ["user_authorizable_type", "user_authorizable_id"], name: "index_user_authorizations_on_user_authorizable"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.boolean "is_active", default: false, null: false
    t.bigint "user_authorization_id", null: false
    t.bigint "permission_object_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_object_id"], name: "index_user_permissions_on_permission_object_id"
    t.index ["user_authorization_id"], name: "index_user_permissions_on_user_authorization_id"
  end

  add_foreign_key "assessment_answers", "assessment_by_students"
  add_foreign_key "assessment_answers", "question_alternatives"
  add_foreign_key "assessment_answers", "questions"
  add_foreign_key "assessment_by_students", "assessment_to_class_groups"
  add_foreign_key "assessment_by_students", "students"
  add_foreign_key "assessment_to_class_groups", "assessments"
  add_foreign_key "assessment_to_class_groups", "class_groups"
  add_foreign_key "assessments", "educators"
  add_foreign_key "question_alternatives", "questions"
  add_foreign_key "questions", "educators"
  add_foreign_key "questions_in_assessments", "assessments"
  add_foreign_key "questions_in_assessments", "questions"
  add_foreign_key "student_in_class_groups", "class_groups"
  add_foreign_key "student_in_class_groups", "students"
  add_foreign_key "user_permissions", "permission_objects"
  add_foreign_key "user_permissions", "user_authorizations"
end
