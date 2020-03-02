# frozen_string_literal: true

class Bpldc::Authority < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  scope :public_attributes, -> { select(:name, :code, :base_url) }
  scope :subjects, -> { where(subjects: true) }
  scope :names, -> { where(names: true) }
  scope :genres, -> { where(genres: true) }
  scope :geographics, -> { where(geographics: true) }

  with_options inverse_of: :authority, dependent: :destroy, foreign_key: :authority_id do
    has_many :resource_types, class_name: 'Bpldc::ResourceType'
    has_many :roles, class_name: 'Bpldc::Role'
    has_many :languages, class_name: 'Bpldc::Language'
    has_many :basic_genres, class_name: 'Bpldc::BasicGenre'
  end
end
