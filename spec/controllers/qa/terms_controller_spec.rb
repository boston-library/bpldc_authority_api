# frozen_string_literal: true

# this controller is actually defined in QA, but we add some specs
# don't use VCR, so we can be sure source authority is returning expected data
require_relative '../shared/terms_shared'

RSpec.describe Qa::TermsController do
  routes { Qa::Engine.routes }

  describe 'authorities/terms configs' do
    describe 'getty_aat' do
      let(:vocab_name) { 'getty' }
      let(:vocab_subauth) { 'aat' }
      let(:term_id) { '300261803' }
      let(:term_uri) { "http://vocab.getty.edu/aat/#{term_id}" }
      let(:query) { 'landscape' }
      it_behaves_like 'terms_search'
    end

    describe 'getty_ulan' do
      let(:vocab_name) { 'getty' }
      let(:vocab_subauth) { 'ulan' }
      let(:term_id) { '500019204' }
      let(:term_uri) { "http://vocab.getty.edu/ulan/#{term_id}" }
      let(:query) { 'McKim' }
      it_behaves_like 'terms_search'
    end
  end
end
