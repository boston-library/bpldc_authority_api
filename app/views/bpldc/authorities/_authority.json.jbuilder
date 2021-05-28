# frozen_string_literal: true

json.cache! [authority], expires_in: 24.hours do
  json.(authority, :name, :code, :base_url)
end
