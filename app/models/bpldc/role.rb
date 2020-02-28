# frozen_string_literal: true

module Bpldc
  class Role < Bpldc::Nomenclature
    belongs_to :authority, inverse_of: :roles, class_name: 'Bpldc::Authority'
  end
end
