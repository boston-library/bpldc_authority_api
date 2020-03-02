# frozen_string_literal: true

RSpec.shared_examples 'bpldc_index_shared' do
  describe 'index_actions' do
    it 'assigns @objects' do
      expect(assigns(:objects)).to_not be_falsey
    end

    it 'renders the response' do
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).length).to be > 1
      expect(response.content_type).to eq('application/json')
    end
  end
end
