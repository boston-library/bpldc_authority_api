# frozen_string_literal: true

module Bpldc
  class Language < Bpldc::Nomenclature
    include CacheClearable

    belongs_to :authority, inverse_of: :languages, class_name: 'Bpldc::Authority', touch: true
  end
end
