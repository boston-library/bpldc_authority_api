# frozen_string_literal: true

RSpec.shared_examples 'nomenclature', type: :model do
  it { is_expected.to be_a_kind_of(Bpldc::Nomenclature) }

  describe 'database' do
    it { is_expected.to have_db_column(:label).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:id_from_auth).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:type).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:authority_id).of_type(:integer) }

    it { is_expected.to have_db_index(:authority_id) }
    it { is_expected.to have_db_index(:type) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_presence_of(:id_from_auth) }
    it { is_expected.to validate_presence_of(:type) }
  end

  describe '#all_for_api' do
    let(:all_for_api_records) { described_class.all_for_api }

    it 'returns a list of objects' do
      expect(all_for_api_records.length).to eq described_class.all.count
    end

    let(:all_for_api_record) { all_for_api_records.sample }
    it 'returns objects with the desired attributes' do
      expect(all_for_api_record.id_from_auth).to_not be_blank
      expect(all_for_api_record.label).to_not be_blank
      expect(all_for_api_record.authority_code).to_not be_blank
      expect(all_for_api_record.updated_at).to_not be_blank
    end
  end
end
