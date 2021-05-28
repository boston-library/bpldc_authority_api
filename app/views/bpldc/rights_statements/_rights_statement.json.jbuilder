# frozen_string_literal: true

json.cache! [rights_statement], expires_in: 24.hours do
  json.(rights_statement, :label, :uri)
end
