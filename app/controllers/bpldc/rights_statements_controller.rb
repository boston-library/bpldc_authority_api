# frozen_string_literal: true

module Bpldc
  class RightsStatementsController < ApplicationController
    # GET /bpldc/rights_statements
    def index
      @objects = Bpldc::RightsStatement.public_attributes
      fresh_when strong_etag: @objects, last_modified: @objects.maximum(:updated_at), public: true
    end
  end
end
