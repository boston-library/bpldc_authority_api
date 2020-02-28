# frozen_string_literal: true

FactoryBot.define do
  factory :bpldc_basic_genre, class: 'Bpldc::BasicGenre' do
    label { Faker::Book.genre }
    sequence(:id_from_auth) { |n| "tgm00123#{n}" }
    association :authority, factory: :bpldc_authority
    type { 'Bpldc::BasicGenre' }
  end
end
