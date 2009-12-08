# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091205211204) do

  create_table "email_addresses", :force => true do |t|
    t.string   "label"
    t.string   "address"
    t.integer  "engineer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engineers", :force => true do |t|
    t.integer  "years_of_experience"
    t.integer  "skill_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "engineers", ["years_of_experience"], :name => "index_engineers_on_years_of_experience"

  create_table "names", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.integer  "engineer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "names", ["fname"], :name => "index_names_on_fname"
  add_index "names", ["lname"], :name => "index_names_on_lname"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_numbers", :force => true do |t|
    t.string   "label"
    t.string   "number"
    t.integer  "engineer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_assignments", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "engineer_id"
    t.integer  "project_id"
    t.integer  "project_scope_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_scopes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["name"], :name => "index_projects_on_name"

  create_table "resources", :force => true do |t|
    t.integer  "engineer_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "similarity_scores", :force => true do |t|
    t.integer  "engineer_id_1"
    t.integer  "engineer_id_2"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skill_levels", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
