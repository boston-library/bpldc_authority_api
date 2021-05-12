# frozen_string_literal: true

module Bpldc
  class BasicGenre < Bpldc::Nomenclature
    include CacheClearable

    belongs_to :authority, inverse_of: :basic_genres, class_name: 'Bpldc::Authority', touch: true
  end
end
