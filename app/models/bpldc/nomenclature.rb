# frozen_string_literal: true

class Bpldc::Nomenclature < ApplicationRecord
  validates :id_from_auth, presence: true
  validates :label, presence: true
  validates :type, presence: true

  scope :with_authority, -> { includes(:authority) }

  def self.all_for_api
    all_records = with_authority
    all_records.map do |rec|
      auth_code = rec.authority.code
      rec = rec.as_json
      rec['authority_code'] = auth_code
      rec.slice('label', 'id_from_auth', 'authority_code')
    end
  end
end
