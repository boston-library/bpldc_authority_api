# frozen_string_literal: true

module Bpldc
  class NomenclaturesController < ApplicationController
    # GET /bpldc/resource_types
    def resource_types
      @objects = Bpldc::ResourceType.all_for_api
      render json: @objects
    end

    # GET /bpldc/roles
    def roles
      @objects = Bpldc::Role.all_for_api
      render json: @objects
    end

    # GET /bpldc/languages
    def languages
      @objects = Bpldc::Language.all_for_api
      render json: @objects
    end

    # GET /bpldc/basic_genres
    def basic_genres
      @objects = Bpldc::BasicGenre.all_for_api
      render json: @objects
    end
  end
end
