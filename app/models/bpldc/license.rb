# frozen_string_literal: true

class Bpldc::License < ApplicationRecord
  validates :label, presence: true

  scope :public_attributes, -> { select(:label, :uri, :updated_at).order(updated_at: :desc) } # NOTE: updated_at is required for caching but using jbuilder we don't have to display it.
end
