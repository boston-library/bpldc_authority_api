# frozen_string_literal: true

RSpec.shared_examples 'cache_clearable', type: :model do
  describe 'class methods' do
    describe '.class_cache_key' do
      let!(:expected_result) { "bpldc/nomenclatures/#{described_class.name.demodulize.underscore.pluralize}" }

      it 'is expected to respond to the method' do
        expect(described_class).to respond_to(:class_cache_key)
        expect(subject.class).to respond_to(:class_cache_key)
      end

      it 'is expected to equal the :expected_result' do
        expect(described_class.class_cache_key).to eq(expected_result)
        expect(subject.class.class_cache_key).to eq(expected_result)
      end
    end

    describe 'callbacks' do
      describe '#nomenclature_clear_cache' do
        it 'is expected to receive it after_commit' do
          # rubocop:disable RSpec/MessageExpectation
          expect(subject).to receive(:nomenclature_clear_cache)
          subject.run_callbacks(:commit)
          # rubocop:enable RSpec/MessageExpectation
        end
      end
    end
  end
end
