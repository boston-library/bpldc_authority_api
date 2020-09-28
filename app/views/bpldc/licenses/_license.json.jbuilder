# frozen_string_literal: true

json.cache! [license], expires_in: 1.day do
  json.(license, :label, :uri)
end
