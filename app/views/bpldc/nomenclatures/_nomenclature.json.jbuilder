# frozen_string_literal: true

json.cache! [nomenclature], expires_in: 24.hours do
  json.(nomenclature, :label, :id_from_auth, :authority_code)
end
