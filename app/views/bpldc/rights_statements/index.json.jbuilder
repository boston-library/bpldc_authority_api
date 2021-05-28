# frozen_string_literal: true

json.partial! partial: 'bpldc/rights_statements/rights_statement', collection: @objects, as: :rights_statement, cached: true
