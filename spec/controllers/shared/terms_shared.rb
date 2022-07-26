# frozen_string_literal: true

RSpec.shared_examples 'terms_fetch' do
  it 'fetches data for a term uri' do
    get :fetch, params: { uri: term_uri, vocab: vocab_name, subauthority: vocab_subauth }
    binding.pry
    expect(response).to have_http_status(:ok)
    response_body = JSON.parse(response.body)
    expect(response_body['label']).not_to be_blank
    expect(response_body['id'].delete(' ')).to eq term_id
  end
end

RSpec.shared_examples 'terms_search' do
  it 'returns a list of results for the query' do
    get :search, params: { q: query, vocab: vocab_name, subauthority: vocab_subauth }
    expect(response).to have_http_status(:ok)
    response_body = JSON.parse(response.body)
    expect(response_body.first['label']).not_to be_blank
    expect(response_body.first['id']).not_to be_blank
  end
end

RSpec.shared_examples 'terms_find' do
  it 'returns data for a term_id' do
    get :show, params: { id: term_id, vocab: vocab_name, subauthority: vocab_subauth }
    expect(response).to have_http_status(:ok)
    response_body = JSON.parse(response.body)
    expect(response_body['label']).not_to be_blank
    expect(response_body['id']).not_to be_blank
  end
end

RSpec.shared_examples 'terms_geonames_fetch' do
  it 'fetches data for a term id' do
    get :fetch, params: { uri: term_uri, vocab: vocab_name }
    response_body = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
    expect(response_body['label'].first).to eq 'Walla Walla'
    expect(response_body['id']).to eq term_uri
  end
end
