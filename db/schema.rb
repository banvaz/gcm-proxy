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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140710150626) do

  create_table "applications", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auth_keys", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "application_id"
    t.string "name"
    t.string "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["application_id"], name: "index_auth_keys_on_application_id"
  end

  create_table "devices", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "application_id"
    t.string "token"
    t.integer "usage", default: 0
    t.datetime "last_sent_notification_at"
    t.datetime "unsubscribed_at"
    t.datetime "created_at"
    t.datetime "last_registered_at"
    t.string "label"
    t.index ["application_id"], name: "index_devices_on_auth_key_id"
  end

  create_table "notifications", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "auth_key_id"
    t.integer "device_id"
    t.datetime "pushed_at"
    t.datetime "created_at"
    t.text "data"
    t.text "error"
    t.boolean "locked", default: false
    t.index ["auth_key_id"], name: "index_notifications_on_auth_key_id"
    t.index ["device_id"], name: "index_notifications_on_device_id"
    t.index ["pushed_at"], name: "index_notifications_on_pushed_at"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "username"
    t.string "password_digest"
    t.string "name"
    t.string "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
