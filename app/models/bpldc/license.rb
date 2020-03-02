# frozen_string_literal: true

class Bpldc::License < ApplicationRecord
  validates :label, presence: true

  scope :public_attributes, -> { select(:label, :uri) }
end
