# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121115162730) do

  create_table "assignments", :force => true do |t|
    t.integer "assignable_id"
    t.integer "role_id"
    t.string  "assignable_type"
  end

  create_table "groups", :force => true do |t|
    t.string "name"
  end

  create_table "memberships", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.integer "organization_id"
  end

  create_table "organizations", :force => true do |t|
    t.string "name"
  end

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.integer "task_definition_id"
    t.integer "organization_id"
  end

  create_table "task_definition_dependencies", :id => false, :force => true do |t|
    t.integer "dependee_id"
    t.integer "depender_id"
  end

  create_table "task_definitions", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.integer  "depends_on_task_definition"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "role_id"
    t.integer  "parent_task_definition_id"
  end

  create_table "task_dependencies", :id => false, :force => true do |t|
    t.integer "dependee_id"
    t.integer "depender_id"
  end

  create_table "tasks", :force => true do |t|
    t.string  "name"
    t.integer "role_id"
    t.integer "owner_id"
    t.integer "depends_on_task_id"
    t.integer "parent_task_id"
    t.boolean "is_prototype"
    t.string  "type"
    t.integer "task_definition_id"
    t.string  "owner_type"
    t.integer "priority"
    t.string  "description"
  end

  create_table "users", :force => true do |t|
    t.string "name"
    t.string "email_address"
    t.string "password_digest"
  end

end
