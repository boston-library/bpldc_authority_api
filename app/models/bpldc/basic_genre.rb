# frozen_string_literal: true

module Bpldc
  class BasicGenre < Bpldc::Nomenclature
    belongs_to :authority, inverse_of: :basic_genres, class_name: 'Bpldc::Authority', touch: true

    after_commit :clear_cache

    private

    def clear_cache
      Rails.cache.delete('bpldc/nomenclatures/basic_genres')
    end
  end
end
