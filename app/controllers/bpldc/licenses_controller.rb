# frozen_string_literal: true

module Bpldc
  class LicensesController < ApplicationController
    # GET /bpldc/licenses
    def index
      @objects = Bpldc::License.public_attributes
      render json: Oj.dump(@objects)
    end
  end
end
