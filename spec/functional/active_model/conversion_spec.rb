include Functional

RSpec.describe ActiveModel::Conversion do
  context '#to_key' do
    it 'returns Some if has id' do
      model = TestModel.new
      model.id = 2

      expect(model.to_key).to eq Some([2])
    end

    it 'returns None if has no id' do
      model = TestModel.new

      expect(model.to_key).to eq None()
    end
  end
end
