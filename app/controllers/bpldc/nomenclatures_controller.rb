# frozen_string_literal: true

module Bpldc
  class NomenclaturesController < ApplicationController
    # GET /bpldc/resource_types
    def resource_types
      @objects = Bpldc::ResourceType.all_for_api
      render_json_index
    end

    # GET /bpldc/roles
    def roles
      @objects = Bpldc::Role.all_for_api
      render_json_index
    end

    # GET /bpldc/languages
    def languages
      @objects = Bpldc::Language.all_for_api
      render_json_index
    end

    # GET /bpldc/basic_genres
    def basic_genres
      @objects = Bpldc::BasicGenre.all_for_api
      render_json_index
    end

    private

    def render_json_index
      render 'bpldc/nomenclatures/index.json.jbuilder'
    end
  end
end
