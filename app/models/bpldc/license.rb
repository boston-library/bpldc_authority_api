# frozen_string_literal: true

class Bpldc::License < ApplicationRecord
  validates :label, presence: true

  def self.all_for_api
    all.map { |rec| rec.as_json.slice('label', 'uri').compact }
  end
end
