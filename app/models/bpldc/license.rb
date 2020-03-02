# frozen_string_literal: true

class Bpldc::License < ApplicationRecord
  validates :label, presence: true

  def self.all_for_api
    select('label', 'uri').map { |rec| rec.as_json.compact }
  end
end
