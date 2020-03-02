# frozen_string_literal: true

require_relative './shared/nomenclatures'
RSpec.describe Bpldc::BasicGenre do
  subject { create(:bpldc_basic_genre) }

  it_behaves_like 'nomenclature'

  describe 'associations' do
    it { is_expected.to belong_to(:authority).
        inverse_of(:basic_genres).
        class_name('Bpldc::Authority').
        required }
  end
end
