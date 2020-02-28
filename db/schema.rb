# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 2020_02_24_171825) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'bpldc_authorities', force: :cascade do |t|
    t.string 'name'
    t.string 'code', null: false
    t.string 'base_url'
    t.boolean 'subjects', default: false
    t.boolean 'genres', default: false
    t.boolean 'names', default: false
    t.boolean 'geographics', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['genres'], name: 'index_bpldc_authorities_on_genres'
    t.index ['geographics'], name: 'index_bpldc_authorities_on_geographics'
    t.index ['names'], name: 'index_bpldc_authorities_on_names'
    t.index ['subjects'], name: 'index_bpldc_authorities_on_subjects'
  end

  create_table 'bpldc_licenses', force: :cascade do |t|
    t.string 'label', null: false
    t.string 'uri'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'bpldc_nomenclatures', force: :cascade do |t|
    t.string 'label', null: false
    t.string 'id_from_auth', null: false
    t.string 'type', null: false
    t.bigint 'authority_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['authority_id'], name: 'index_bpldc_nomenclatures_on_authority_id'
    t.index ['type'], name: 'index_bpldc_nomenclatures_on_type'
  end

  add_foreign_key 'bpldc_nomenclatures', 'bpldc_authorities', column: 'authority_id', on_delete: :nullify
end
