# frozen_string_literal: true

json.cache! [rights_statement], expires_in: 1.day do
  json.(rights_statement, :label, :uri)
end
