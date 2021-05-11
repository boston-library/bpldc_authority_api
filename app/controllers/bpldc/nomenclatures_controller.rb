# frozen_string_literal: true

module Bpldc
  class NomenclaturesController < ApplicationController
    # GET /bpldc/resource_types
    def resource_types
      @objects = Rails.cache.fetch('bpldc/nomenclatures/resource_types') do
        Bpldc::ResourceType.all_for_api
      end

      render_json_index
    end

    # GET /bpldc/roles
    def roles
      @objects = Rails.cache.fetch('bpldc/nomenclatures/roles') do
        Bpldc::Role.all_for_api
      end

      render_json_index
    end

    # GET /bpldc/languages
    def languages
      @objects = Rails.cache.fetch('bpldc/nomenclatures/languages') do
        Bpldc::Language.all_for_api
      end

      render_json_index
    end

    # GET /bpldc/basic_genres
    def basic_genres
      @objects = Rails.cache.fetch('bpldc/nomenclatures/basic_genres') do
        Bpldc::BasicGenre.all_for_api
      end

      render_json_index
    end

    private

    def render_json_index
      render 'bpldc/nomenclatures/index.json.jbuilder' if stale?(strong_etag: @objects, last_modified: @objects.maximum(:updated_at))
    end
  end
end
