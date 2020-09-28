# frozen_string_literal: true

module Bpldc
  class LicensesController < ApplicationController
    # GET /bpldc/licenses
    def index
      @objects = Bpldc::License.public_attributes
    end
  end
end
