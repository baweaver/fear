RSpec.describe Fear::Option do
  include Fear::Option::Mixin

  describe 'Option()' do
    it 'returns Some if value is not nil' do
      option = Option(double)

      expect(option).to be_kind_of(Fear::Some)
    end

    it 'returns None if value is nil' do
      option = Option(nil)

      expect(option).to be_kind_of(Fear::None)
    end
  end

  let(:some) { Some(42) }
  let(:none) { None() }

  describe '#empty?' do
    context 'Some' do
      subject { some.empty? }
      it { is_expected.to eq(false) }
    end

    context 'None' do
      subject { none.empty? }
      it { is_expected.to eq(true) }
    end
  end
end