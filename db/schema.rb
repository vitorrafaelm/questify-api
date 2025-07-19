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

ActiveRecord::Schema[7.0].define(version: 2025_07_04_072643) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_foreign_key "user_permissions", "permission_objects"
  add_foreign_key "user_permissions", "user_authorizations"
end
