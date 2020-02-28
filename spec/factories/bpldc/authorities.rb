# frozen_string_literal: true

FactoryBot.define do
  factory :bpldc_authority, class: 'Bpldc::Authority' do
    sequence(:code) { |n| "loc-test-authority-#{n}" }
    name { Faker::Lorem.sentence }
    sequence(:base_url) { |n| "http://id.loc.gov/vocabulary/loc-test-authority-#{n}" }
    subjects { [true, false].sample }
    genres { [true, false].sample }
    names { [true, false].sample }
    geographics { [true, false].sample }
  end
end
