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

ActiveRecord::Schema[7.1].define(version: 2024_08_23_210354) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administradores", force: :cascade do |t|
    t.string "ra", null: false
    t.string "senha", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "compras", force: :cascade do |t|
    t.string "usuarios_ra", null: false
    t.bigint "produtos_id"
    t.datetime "data_compra"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produtos_id"], name: "index_compras_on_produtos_id"
  end

  create_table "produtos", force: :cascade do |t|
    t.string "nome", null: false
    t.decimal "preco", precision: 10, scale: 2, null: false
    t.integer "qtde"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "ra", null: false
    t.string "senha", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "saldo", precision: 10, scale: 2, null: false
    t.index ["ra"], name: "index_usuarios_on_ra", unique: true
  end

  add_foreign_key "compras", "produtos", column: "produtos_id"
  add_foreign_key "compras", "usuarios", column: "usuarios_ra", primary_key: "ra"
end
