# frozen_string_literal: true

RSpec.describe Bpldc::LcVocabUtilities::LcVocabFetcher do
  let(:id_from_auth) { 'tgm002707' }
  describe '#seed_lc_data' do
    it 'fetches the vocab data and adds it to the database' do
      VCR.use_cassette('lc_vocab_fetcher') do
        expect do
          described_class.seed_lc_data(bpldc_class: 'Bpldc::BasicGenre',
                                       lc_url: "http://id.loc.gov/vocabulary/graphicMaterials/#{id_from_auth}.madsrdf.json",
                                       auth_code: 'lctgm')
        end.to change(Bpldc::BasicGenre, :count).by(1)
      end
      expect(Bpldc::BasicGenre.find_by(id_from_auth: id_from_auth)).not_to be_blank
    end
  end
end
