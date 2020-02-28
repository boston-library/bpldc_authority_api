# frozen_string_literal: true

RSpec.describe Bpldc::License do
  subject { create(:bpldc_license) }

  describe 'database' do
    it { is_expected.to have_db_column(:label).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:uri).of_type(:string) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:label) }
  end

  describe '#all_for_api' do
    let(:all_for_api_records) { described_class.all_for_api }

    it 'returns a list of objects' do
      expect(all_for_api_records.length).to eq described_class.all.count
    end

    let(:all_for_api_record) { all_for_api_records.sample }
    it 'returns objects with the desired attributes' do
      expect(all_for_api_record['label']).to_not be_blank
      expect(all_for_api_record['id']).to be_blank
      expect(all_for_api_record['created_at']).to be_blank
    end
  end
end
