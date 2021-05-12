# frozen_string_literal: true

module Bpldc
  module CacheClearable
    extend ActiveSupport::Concern

    class_methods do
      def class_cache_key
        class_name_key = name.demodulize.underscore.pluralize
        "bpldc/nomenclatures/#{class_name_key}"
      end
    end

    included do
      include InstanceMethods

      after_commit :nomenclature_clear_cache
    end

    module InstanceMethods
      private

      def nomenclature_clear_cache
        Rails.cache.delete(self.class.class_cache_key)
      end
    end
  end
end
