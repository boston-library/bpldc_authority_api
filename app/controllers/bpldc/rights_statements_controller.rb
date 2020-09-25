# frozen_string_literal: true

module Bpldc
  class RightsStatementsController < ApplicationController
    # GET /bpldc/rights_statements
    def index
      @objects = Bpldc::RightsStatement.public_attributes
    end
  end
end
