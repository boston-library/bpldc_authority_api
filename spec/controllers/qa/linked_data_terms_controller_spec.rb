# frozen_string_literal: true

require_relative '../shared/terms_shared'
# this controller is actually defined in QA, but we add some specs

RSpec.describe Qa::LinkedDataTermsController, :vcr do
  routes { Qa::Engine.routes }

  describe 'loc_direct' do
    describe 'genres' do
      let(:vocab_name) { 'loc_direct' }
      let(:vocab_subauth) { 'genre' }
      let(:term_id) { 'gf2011026056' }
      it_behaves_like 'terms_find'
    end

    describe 'names' do
      let(:vocab_name) { 'loc_direct' }
      let(:vocab_subauth) { 'names' }
      let(:term_id) { 'n83017570' }
      it_behaves_like 'terms_find'
    end

    describe 'subjects' do
      let(:vocab_name) { 'loc_direct' }
      let(:vocab_subauth) { 'subjects' }
      let(:term_id) { 'sh85149170' }
      it_behaves_like 'terms_find'
    end
  end

  describe 'geonames configs' do
    let(:query) { 'Allston' }

    describe 'geonames_direct' do
      let(:vocab_name) { 'geonames_direct' }
      let(:vocab_subauth) { nil }
      let(:term_uri) { 'https://sws.geonames.org/5814916/' }
      it_behaves_like 'terms_geonames_fetch'
    end
  end
end
