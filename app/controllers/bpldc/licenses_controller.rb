# frozen_string_literal: true

module Bpldc
  class LicensesController < ApplicationController
    # GET /bpldc/licenses
    def index
      @objects = Bpldc::License.all_for_api
      render json: @objects
    end
  end
end
