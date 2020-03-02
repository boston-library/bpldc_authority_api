# frozen_string_literal: true

FactoryBot.define do
  factory :bpldc_language, class: 'Bpldc::Language' do
    label { Faker::ProgrammingLanguage.name }
    sequence(:id_from_auth) { |n| "iso639-2#{n}" }
    association :authority, factory: :bpldc_authority
    type { 'Bpldc::Language' }
  end
end
