# frozen_string_literal: true

module Bpldc
  class AuthoritiesController < ApplicationController
    # GET /bpldc/authorities
    def index
      @objects = Bpldc::Authority.public_attributes.all
      render json: results_for_api
    end

    # GET /bpldc/authorities/subjects
    def subjects
      @objects = Bpldc::Authority.public_attributes.subjects
      render json: results_for_api
    end

    # GET /bpldc/authorities/subjects
    def genres
      @objects = Bpldc::Authority.public_attributes.genres
      render json: results_for_api
    end

    # GET /bpldc/authorities/subjects
    def names
      @objects = Bpldc::Authority.public_attributes.names
      render json: results_for_api
    end

    # GET /bpldc/authorities/subjects
    def geographics
      @objects = Bpldc::Authority.public_attributes.geographics
      render json: results_for_api
    end

    private

    def results_for_api
      @objects.map { |rec| rec.as_json.compact }
    end
  end
end
