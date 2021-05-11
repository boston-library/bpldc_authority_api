# frozen_string_literal: true

module Bpldc
  class Role < Bpldc::Nomenclature
    belongs_to :authority, inverse_of: :roles, class_name: 'Bpldc::Authority', touch: true

    after_commit :clear_cache

    private

    def clear_cache
      Rails.cache.delete('bpldc/nomenclatures/roles')
    end
  end
end
