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

ActiveRecord::Schema.define(version: 2022_01_15_175515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dns", force: :cascade do |t|
    t.binary "ip", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dns_hosts", force: :cascade do |t|
    t.bigint "dns_id", null: false
    t.bigint "hostname_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dns_id"], name: "index_dns_hosts_on_dns_id"
    t.index ["hostname_id"], name: "index_dns_hosts_on_hostname_id"
  end

  create_table "hostnames", force: :cascade do |t|
    t.string "domain", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "dns_hosts", "dns", column: "dns_id"
  add_foreign_key "dns_hosts", "hostnames"
end
