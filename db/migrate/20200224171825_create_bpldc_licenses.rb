# frozen_string_literal: true

class CreateBpldcLicenses < ActiveRecord::Migration[5.1]
  def change
    create_table :bpldc_licenses do |t|
      t.string :label, null: false
      t.string :uri

      t.timestamps null: false
    end
  end
end
