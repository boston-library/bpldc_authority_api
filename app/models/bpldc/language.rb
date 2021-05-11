# frozen_string_literal: true

module Bpldc
  class Language < Bpldc::Nomenclature
    belongs_to :authority, inverse_of: :languages, class_name: 'Bpldc::Authority', touch: true

    after_commit :clear_cache

    private

    def clear_cache
      Rails.cache.delete('bpldc/nomenclatures/languages')
    end
  end
end
