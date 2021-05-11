# frozen_string_literal: true

module Bpldc
  class ResourceType < Bpldc::Nomenclature
    belongs_to :authority, inverse_of: :resource_types, class_name: 'Bpldc::Authority', touch: true

    after_commit :clear_cache

    private

    def clear_cache
      Rails.cache.delete('bpldc/nomenclatures/resource_types')
    end
  end
end
