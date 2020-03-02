# frozen_string_literal: true

FactoryBot.define do
  factory :bpldc_license, class: 'Bpldc::License' do
    label { Faker::Lorem.sentence }
    uri { Faker::Internet.url }
  end
end
