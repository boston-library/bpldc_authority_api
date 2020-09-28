# frozen_string_literal: true

class Bpldc::RightsStatement < ApplicationRecord
  validates :label, presence: true

  scope :public_attributes, -> { select(:label, :uri, :updated_at) } # NOTE: updated_at is required for caching but using jbuilder we don't have to display it.
end
