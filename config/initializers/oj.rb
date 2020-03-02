# frozen_string_literal: true

Oj.optimize_rails
Oj.default_options = {
  mode: :rails,
  time_format: :ruby,
  hash_class: ActiveSupport::HashWithIndifferentAccess,
  omit_nil: true
}
