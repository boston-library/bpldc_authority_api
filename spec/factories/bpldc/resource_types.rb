# frozen_string_literal: true

FactoryBot.define do
  factory :bpldc_resource_type, class: 'Bpldc::ResourceType' do
    label { Faker::Book.genre }
    sequence(:id_from_auth) { |n| "resourceType#{n}" }
    association :authority, factory: :bpldc_authority
    type { 'Bpldc::ResourceType' }
  end
end
