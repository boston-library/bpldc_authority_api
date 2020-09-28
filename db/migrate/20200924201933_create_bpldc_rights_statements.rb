# frozen_string_literal: true

class CreateBpldcRightsStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :bpldc_rights_statements do |t|
      t.string :label, null: false
      t.string :uri

      t.timestamps null: false
    end
  end
end
