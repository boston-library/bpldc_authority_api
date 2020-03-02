# frozen_string_literal: true

class CreateBpldcNomenclatures < ActiveRecord::Migration[5.1]
  def change
    create_table :bpldc_nomenclatures do |t|
      t.string :label, null: false
      t.string :id_from_auth, null: false
      t.string :type, index: { using: :btree }, null: false
      t.belongs_to :authority, index: { using: :btree },
                   foreign_key: { to_table: :bpldc_authorities, on_delete: :nullify }

      t.timestamps null: false
    end
  end
end
