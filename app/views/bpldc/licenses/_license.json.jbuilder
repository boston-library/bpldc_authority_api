# frozen_string_literal: true

json.cache! [license], expires_in: 24.hours do
  json.(license, :label, :uri)
end
