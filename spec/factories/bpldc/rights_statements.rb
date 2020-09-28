# frozen_string_literal: true

FactoryBot.define do
  factory :bpldc_rights_statement, class: 'Bpldc::RightsStatement' do
    label { Faker::Lorem.sentence }
    uri { Faker::Internet.url }
  end
end
