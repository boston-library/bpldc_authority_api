# frozen_string_literal: true

module Bpldc
  class AuthoritiesController < ApplicationController
    # GET /bpldc/authorities
    def index
      @objects = Bpldc::Authority.public_attributes.all
      render json: Oj.dump(@objects)
    end

    # GET /bpldc/authorities/subjects
    def subjects
      @objects = Bpldc::Authority.public_attributes.subjects
      render json: Oj.dump(@objects)
    end

    # GET /bpldc/authorities/subjects
    def genres
      @objects = Bpldc::Authority.public_attributes.genres
      render json: Oj.dump(@objects)
    end

    # GET /bpldc/authorities/subjects
    def names
      @objects = Bpldc::Authority.public_attributes.names
      render json: Oj.dump(@objects)
    end

    # GET /bpldc/authorities/subjects
    def geographics
      @objects = Bpldc::Authority.public_attributes.geographics
      render json: Oj.dump(@objects)
    end
  end
end
