# frozen_string_literal: true

module Bpldc
  class LicensesController < ApplicationController
    # GET /bpldc/licenses
    def index
      @objects = Bpldc::License.public_attributes
      fresh_when strong_etag: @objects, last_modified: @objects.maximum(:updated_at), public: true
    end
  end
end
