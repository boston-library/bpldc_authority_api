# frozen_string_literal: true

RSpec.shared_examples 'geomash_get_data_with_valid_id' do
  it 'returns a valid response with the expected content' do
    get geomash_route, params: { id: id_from_auth }
    response_body = JSON.parse(response.body)

    expect(response).to be_successful
    expect(assigns(:geomash_data)).to_not be_falsey
    expect(response_body['coords']).not_to be_blank
    expect(response_body['hier_geo'].to_s).to include city
  end
end

RSpec.shared_examples 'geomash_error_response' do
  it 'returns a non-OK response with an error message' do
    get geomash_route, params: request_params
    expect(response).to have_http_status(expected_status)
    expect(assigns(:geomash_data)).to be_falsey
    expect(JSON.parse(response.body)['error']).not_to be_blank
  end
end
