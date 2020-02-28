# frozen_string_literal: true

class CreateBpldcAuthorities < ActiveRecord::Migration[5.1]
  def change
    create_table :bpldc_authorities do |t|
      t.string :name
      t.string :code, null: false
      t.string :base_url
      t.boolean :subjects, default: false, index: { using: :btree }
      t.boolean :genres, default: false, index: { using: :btree }
      t.boolean :names, default: false, index: { using: :btree }
      t.boolean :geographics, default: false, index: { using: :btree }

      t.timestamps null:false
    end
  end
end
