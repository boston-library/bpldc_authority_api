# frozen_string_literal: true

module Bpldc
  class ResourceType < Bpldc::Nomenclature
    include CacheClearable

    belongs_to :authority, inverse_of: :resource_types, class_name: 'Bpldc::Authority', touch: true
  end
end
