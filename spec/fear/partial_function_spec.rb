RSpec.describe Fear::PartialFunction do
  include Fear::PartialFunction::Mixin

  describe '#defined?' do
    let(:partial_function) { PartialFunction(->(v) { v == 42 }) {} }

    it 'defined at' do
      expect(partial_function.defined_at?(42)).to eq(true)
    end

    it 'not defined at' do
      expect(partial_function.defined_at?(24)).to eq(false)
    end
  end

  describe '#call' do
    let(:partial_function) { PartialFunction(->(v) { v != 0 }) { |x| 4 / x } }

    context 'defined' do
      subject { partial_function.call(2) }

      it { is_expected.to eq(2) }
    end

    context 'not defined' do
      subject { -> { partial_function.call(0) } }

      it { is_expected.to raise_error(Fear::MatchError, 'partial function not defined at: 0') }
    end
  end

  describe '#to_proc', '#call' do
    let(:partial_function) { PartialFunction(->(v) { v != 0 }) { |x| 4 / x }.to_proc }

    context 'defined' do
      subject { partial_function.call(2) }

      it { is_expected.to eq(2) }
    end

    context 'not defined' do
      subject { -> { partial_function.call(0) } }

      it { is_expected.to raise_error(Fear::MatchError, 'partial function not defined at: 0') }
    end
  end

  describe '#call_or_else' do
    let(:default) { ->(x) { "division by #{x} impossible" } }
    let(:partial_function) { PartialFunction(->(x) { x != 0 }) { |x| 4 / x } }

    context 'defined' do
      subject { partial_function.call_or_else(2, &default) }

      it { is_expected.to eq(2) }
    end

    context 'not defined' do
      subject { partial_function.call_or_else(0, &default) }

      it { is_expected.to eq('division by 0 impossible') }
    end
  end

  describe '#and_then' do
    let(:partial_function) { PartialFunction(->(v) { v == 42 }) {} }
    let(:and_then) { ->(x) { x } }

    context 'block given, arguments not given' do
      subject { -> { partial_function.and_then(&and_then) } }

      it { is_expected.not_to raise_error }
    end

    context 'block given, argument given' do
      subject { -> { partial_function.and_then(and_then, &and_then) } }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'block given, arguments given' do
      subject { -> { partial_function.and_then(and_then, 42, &and_then) } }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'block not given, arguments not given' do
      subject { -> { partial_function.and_then } }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'block net given, arguments given' do
      subject { -> { partial_function.and_then(and_then) } }

      it { is_expected.not_to raise_error }
    end
  end
end