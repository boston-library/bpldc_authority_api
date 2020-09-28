# frozen_string_literal: true

json.cache! [nomenclature], expires_in: 1.day do
  json.(nomenclature, :label, :id_from_auth, :authority_code)
end
