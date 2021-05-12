# frozen_string_literal: true

class Bpldc::Authority < ApplicationRecord
  CACHE_KEYS = {
    all: 'bpldc/authorities/all',
    subjects: 'bpldc/authorities/subjects',
    genres: 'bpldc/authorities/genres',
    names: 'bpldc/authorities/names',
    geographics: 'bpldc/authorities/geographics',
  }.freeze

  validates :code, presence: true, uniqueness: true

  after_commit :clear_authority_cache

  scope :public_attributes, -> { select(:name, :code, :base_url, :updated_at).order(updated_at: :desc) } # NOTE: updated_at required for cache key but using jbuilder we don't have to display it.
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

  private

  def clear_authority_cache
    CACHE_KEYS.values.each do |cache_key|
      Rails.cache.delete(cache_key)
    end
  end
end
