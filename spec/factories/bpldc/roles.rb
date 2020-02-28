# frozen_string_literal: true

FactoryBot.define do
  factory :bpldc_role, class: 'Bpldc::Role' do
    label { Faker::Job.title }
    sequence(:id_from_auth) { |n| "marcrelators#{n}" }
    association :authority, factory: :bpldc_authority
    type { 'Bpldc::Role' }
  end
end
