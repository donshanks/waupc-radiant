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

ActiveRecord::Schema.define(:version => 20100912194722) do

  create_table "calendars", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "category"
    t.string   "slug"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version"
    t.integer  "site_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "page_id"
    t.string   "author"
    t.string   "author_url"
    t.string   "author_email"
    t.string   "author_ip"
    t.text     "content"
    t.text     "content_html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filter_id",    :limit => 25
    t.string   "user_agent"
    t.string   "referrer"
    t.datetime "approved_at"
    t.integer  "approved_by"
    t.string   "mollom_id"
  end

  create_table "config", :force => true do |t|
    t.string "key",   :limit => 40, :default => "", :null => false
    t.string "value",               :default => ""
  end

  add_index "config", ["key"], :name => "key", :unique => true

  create_table "event_recurrence_rules", :force => true do |t|
    t.integer  "event_id"
    t.boolean  "active",         :default => false
    t.string   "period"
    t.string   "basis"
    t.integer  "interval",       :default => 1
    t.datetime "limiting_date"
    t.integer  "limiting_count"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version"
    t.integer  "site_id"
  end

  add_index "event_recurrence_rules", ["event_id"], :name => "index_event_recurrence_rules_on_event_id"

  create_table "event_venues", :force => true do |t|
    t.string   "title"
    t.string   "address"
    t.string   "url"
    t.text     "description"
    t.string   "postcode"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version"
  end

  create_table "events", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.integer  "calendar_id"
    t.string   "url"
    t.integer  "site_id"
    t.integer  "status_id",      :default => 1, :null => false
    t.string   "uuid"
    t.boolean  "all_day"
    t.string   "priority"
    t.string   "keywords"
    t.string   "contact"
    t.string   "postcode"
    t.integer  "lock_version"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.integer  "updated_by_id"
    t.datetime "updated_at"
    t.integer  "event_venue_id"
    t.integer  "master_id"
  end

  add_index "events", ["event_venue_id"], :name => "index_events_on_event_venue_id"

  create_table "extension_meta", :force => true do |t|
    t.string  "name"
    t.integer "schema_version", :default => 0
    t.boolean "enabled",        :default => true
  end

  create_table "icals", :force => true do |t|
    t.integer  "calendar_id"
    t.string   "url"
    t.integer  "last_refresh_count"
    t.datetime "last_refresh_date"
    t.string   "username"
    t.string   "password"
    t.boolean  "use_https"
    t.integer  "refresh_interval"
    t.integer  "site_id"
  end

  create_table "layouts", :force => true do |t|
    t.string   "name",          :limit => 100
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "content_type",  :limit => 40
    t.integer  "lock_version",                 :default => 0
  end

  create_table "page_parts", :force => true do |t|
    t.string  "name",      :limit => 100
    t.string  "filter_id", :limit => 25
    t.text    "content"
    t.integer "page_id"
  end

  add_index "page_parts", ["page_id", "name"], :name => "parts_by_page"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",             :limit => 100
    t.string   "breadcrumb",       :limit => 160
    t.string   "class_name",       :limit => 25
    t.integer  "status_id",                       :default => 1,     :null => false
    t.integer  "parent_id"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "virtual",                         :default => false, :null => false
    t.integer  "lock_version",                    :default => 0
    t.string   "description"
    t.string   "keywords"
    t.boolean  "sitemap"
    t.string   "change_frequency"
    t.string   "priority"
    t.integer  "position"
    t.boolean  "enable_comments",                 :default => false
    t.integer  "comments_count",                  :default => 0
  end

  add_index "pages", ["class_name"], :name => "pages_class_name"
  add_index "pages", ["parent_id"], :name => "pages_parent_id"
  add_index "pages", ["slug", "parent_id"], :name => "pages_child_slug"
  add_index "pages", ["virtual", "status_id"], :name => "pages_published"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "snippets", :force => true do |t|
    t.string   "name",          :limit => 100, :default => "", :null => false
    t.string   "filter_id",     :limit => 25
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "lock_version",                 :default => 0
  end

  add_index "snippets", ["name"], :name => "name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",          :limit => 100
    t.string   "email"
    t.string   "login",         :limit => 40,  :default => "",    :null => false
    t.string   "password",      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "admin",                        :default => false, :null => false
    t.boolean  "developer",                    :default => false, :null => false
    t.text     "notes"
    t.integer  "lock_version",                 :default => 0
    t.string   "salt"
    t.string   "session_token"
    t.integer  "page_id"
  end

  add_index "users", ["login"], :name => "login", :unique => true

  create_table "webservices", :force => true do |t|
    t.string   "base_url",    :null => false
    t.string   "title",       :null => false
    t.string   "description"
    t.text     "rule_scheme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
