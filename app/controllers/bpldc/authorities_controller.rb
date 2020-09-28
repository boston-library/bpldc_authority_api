# frozen_string_literal: true

module Bpldc
  class AuthoritiesController < ApplicationController
    # GET /bpldc/authorities
    def index
      @objects = Bpldc::Authority.public_attributes.all
    end

    # GET /bpldc/authorities/subjects
    def subjects
      @objects = Bpldc::Authority.public_attributes.subjects
      render_json_index
    end

    # GET /bpldc/authorities/subjects
    def genres
      @objects = Bpldc::Authority.public_attributes.genres
      render_json_index
    end

    # GET /bpldc/authorities/subjects
    def names
      @objects = Bpldc::Authority.public_attributes.names
      render_json_index
    end

    # GET /bpldc/authorities/geographics
    def geographics
      @objects = Bpldc::Authority.public_attributes.geographics
      render_json_index
    end

    private

    def render_json_index
      render :index
    end
  end
end
