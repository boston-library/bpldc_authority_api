# frozen_string_literal: true

# this controller is actually defined in QA, but we add some specs
# to test configs in config/authorities/linked_data
# don't use VCR, so we can be sure source authority is returning expected data
require_relative '../shared/linked_data_terms_shared'
RSpec.describe Qa::LinkedDataTermsController do
  before(:each) { @routes = Qa::Engine.routes }

  describe 'authorities/linked_data configs' do
    describe 'getty_aat_ld4l_cache' do
      let(:vocab_name) { 'getty_aat_ld4l_cache' }
      let(:term_id) { '300261803' }
      let(:term_uri) { "http://vocab.getty.edu/aat/#{term_id}" }
      let(:query) { 'landscape' }
      it_behaves_like 'linked_data_terms_fetch'
      it_behaves_like 'linked_data_terms_search'
    end

    describe 'getty_tgn_ld4l_cache' do
      let(:vocab_name) { 'getty_tgn_ld4l_cache' }
      let(:term_id) { '7017665' }
      let(:term_uri) { "http://vocab.getty.edu/tgn/#{term_id}" }
      let(:query) { 'Avonlea' }
      it_behaves_like 'linked_data_terms_fetch'
      it_behaves_like 'linked_data_terms_search'
    end

    describe 'getty_ulan_ld4l_cache' do
      let(:vocab_name) { 'getty_tgn_ld4l_cache' }
      let(:term_id) { '500019204' }
      let(:term_uri) { "http://vocab.getty.edu/ulan/#{term_id}" }
      let(:query) { 'McKim' }
      it_behaves_like 'linked_data_terms_fetch'
      it_behaves_like 'linked_data_terms_search'
    end

    describe 'locgenres_ld4l_cache' do
      let(:vocab_name) { 'locgenres_ld4l_cache' }
      let(:term_id) { 'gf2011026056' }
      let(:term_uri) { "http://id.loc.gov/authorities/genreForms/#{term_id}" }
      let(:query) { 'chants' }
      it_behaves_like 'linked_data_terms_fetch'
      it_behaves_like 'linked_data_terms_search'
    end

    describe 'locnames_ld4l_cache' do
      let(:vocab_name) { 'locnames_ld4l_cache' }
      let(:term_id) { 'n83017570' }
      let(:term_uri) { "http://id.loc.gov/authorities/names/#{term_id}" }
      let(:query) { 'Houdini' }
      it_behaves_like 'linked_data_terms_fetch'
      it_behaves_like 'linked_data_terms_search'
    end

    describe 'locsubjects_ld4l_cache' do
      let(:vocab_name) { 'locsubjects_ld4l_cache' }
      let(:term_id) { 'sh85149170' }
      let(:term_uri) { "http://id.loc.gov/authorities/subjects/#{term_id}" }
      let(:query) { 'yodeling' }
      it_behaves_like 'linked_data_terms_fetch'
      it_behaves_like 'linked_data_terms_search'
    end

    describe 'geonames configs' do
      let(:query) { 'Allston' }

      describe 'geonames_ld4l_cache' do
        let(:vocab_name) { 'geonames_ld4l_cache' }
        let(:term_uri) { 'http://sws.geonames.org/5814916/' }
        it_behaves_like 'linked_data_terms_geonames_fetch'
        it_behaves_like 'linked_data_terms_search'
      end

      describe 'geonames_direct' do
        let(:vocab_name) { 'geonames_direct' }
        let(:term_uri) { 'https://sws.geonames.org/5814916/' }
        it_behaves_like 'linked_data_terms_geonames_fetch'
        it_behaves_like 'linked_data_terms_search'
      end
    end
  end
end
