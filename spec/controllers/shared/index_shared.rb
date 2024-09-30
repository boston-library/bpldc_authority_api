# frozen_string_literal: true

RSpec.shared_examples 'bpldc_index_shared' do
  describe 'index_actions' do
    let!(:expected_cache_response_headers) { ['etag', 'last-modified', 'cache-control'] }

    it 'assigns @objects' do
      expect(assigns(:objects)).to_not be_falsey
    end

    it 'renders the response' do
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).length).to be > 1
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'has headers for cache' do
      expect(response.headers.keys).to include(*expected_cache_response_headers)
    end
  end
end
