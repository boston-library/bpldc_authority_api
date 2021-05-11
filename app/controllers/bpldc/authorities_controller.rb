# frozen_string_literal: true

module Bpldc
  class AuthoritiesController < ApplicationController
    # GET /bpldc/authorities
    def index
      @objects = Rails.cache.fetch('bpldc/authorities/all') do
        Bpldc::Authority.public_attributes.all
      end

      fresh_when strong_etag: @objects, last_modified: @objects.maximum(:updated_at), public: true
    end

    # GET /bpldc/authorities/subjects
    def subjects
      @objects = Rails.cache.fetch('bpldc/authorities/subjects') do
        Bpldc::Authority.public_attributes.subjects
      end

      render_json_index
    end

    # GET /bpldc/authorities/subjects
    def genres
      @objects = Rails.cache.fetch('bpldc/authorities/genres') do
        Bpldc::Authority.public_attributes.genres
      end

      render_json_index
    end

    # GET /bpldc/authorities/subjects
    def names
      @objects = Rails.cache.fetch('bpldc/authorities/names') do
        Bpldc::Authority.public_attributes.names
      end

      render_json_index
    end

    # GET /bpldc/authorities/geographics
    def geographics
      @objects = Rails.cache.fetch('bpldc/authorities/geographics') do
        Bpldc::Authority.public_attributes.geographics
      end

      render_json_index
    end

    private

    def render_json_index
      render :index if stale?(strong_etag: @objects, last_modified: @objects.maximum(:updated_at))
    end
  end
end
