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
end
