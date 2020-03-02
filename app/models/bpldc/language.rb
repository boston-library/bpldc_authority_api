# frozen_string_literal: true

module Bpldc
  class Language < Bpldc::Nomenclature
    belongs_to :authority, inverse_of: :languages, class_name: 'Bpldc::Authority'
  end
end
