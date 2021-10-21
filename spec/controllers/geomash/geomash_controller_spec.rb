# frozen_string_literal: true

# specs are slow because they call Geomash methods that make HTTP requests using Typhoeus,
# which doesn't seem to play well with VCR (despite `hook_into :typhoeus` in config block)
# so specs are making live requests to GeoNames, Getty, Google Maps API, etc.
require_relative '../shared/geomash_shared'
RSpec.describe Geomash::GeomashController do
  let(:tgn_id) { '7017665' }
  let(:geonames_id) { '5814916' }
  let(:city) { 'Walla Walla' }
  let(:bad_id) { 'foo' }

  describe 'GET tgn' do
    let(:geomash_route) { :tgn }

    describe 'with a valid TGN id' do
      let(:id_from_auth) { tgn_id }
      it_behaves_like 'geomash_get_data_with_valid_id'
    end

    describe 'with an invalid TGN id' do
      let(:request_params) { { id: bad_id } }
      let(:expected_status) { :not_found }
      it_behaves_like 'geomash_error_response'
    end
  end

  describe 'GET geonames' do
    let(:geomash_route) { :geonames }

    describe 'with a valid GeoNames id' do
      let(:id_from_auth) { geonames_id }
      it_behaves_like 'geomash_get_data_with_valid_id'
    end

    describe 'with an invalid GeoNames id' do
      let(:request_params) { { id: bad_id } }
      let(:expected_status) { :bad_request }
      it_behaves_like 'geomash_error_response'
    end
  end

  describe 'GET parse' do
    it 'returns the parsed term as JSON' do
      get :parse, params: { term: "#{city}, WA" }
      response_body = JSON.parse(response.body)
      awesome_print response
      awesome_print response_body
      expect(response).to be_successful
      expect(assigns(:geomash_data)).to_not be_falsey
      expect(response_body['city_part']).to eq city
      expect(response_body['tgn']['id']).to eq tgn_id
      expect(response_body['geonames']['id']).to eq geonames_id
    end
  end

  describe 'GET state_town_lookup' do
    describe 'with valid params' do
      it 'returns the parsed term as JSON' do
        get :state_town_lookup, params: { term: 'Back Bay' }

        expect(response).to be_successful
        expect(assigns(:geomash_data)).to_not be_falsey
        expect(JSON.parse(response.body)['tgn_id']).to eq '1004027'
      end
    end

    describe 'with invalid params' do
      let(:geomash_route) { :state_town_lookup }
      let(:request_params) { { term: city } }
      let(:expected_status) { :not_found }
      it_behaves_like 'geomash_error_response'
    end
  end
end
