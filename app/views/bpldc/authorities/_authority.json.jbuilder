# frozen_string_literal: true

json.cache! [authority], expires_in: 1.day do
  json.(authority, :name, :code, :base_url)
end
