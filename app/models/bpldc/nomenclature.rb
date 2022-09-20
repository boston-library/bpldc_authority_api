# frozen_string_literal: true

class Bpldc::Nomenclature < ApplicationRecord
  validates :id_from_auth, presence: true
  validates :label, presence: true
  validates :type, presence: true

  scope :with_authority, -> { joins(:authority).preload(:authority) }

  scope :all_for_api, -> { with_authority.select(:label, :id_from_auth, :authority_id, :updated_at, :type, 'bpldc_authorities.code AS authority_code').order(updated_at: :desc) } # NOTE: changed to work better with jbuilder/ caching.

  # def self.all_for_api
  #   with_authority.map do |rec|
  #     auth_code = rec.authority.code
  #     rec = rec.as_json
  #     rec['authority_code'] = auth_code
  #     rec.slice('label', 'id_from_auth', 'authority_code')
  #   end
  # end
end
