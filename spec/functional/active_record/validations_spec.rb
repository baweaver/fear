include Functional

RSpec.describe ActiveRecord::Validations do
  context '#validate!' do
    it 'returns Success if valid' do
      model = TestModel.new(value: 123)

      validation = model.validate!

      expect(validation).to eq Success(true)
    end

    it 'returns Failure if invalid' do
      model = TestModel.new

      validation = model.validate!

      expect(validation).to be_kind_of(Failure)
      expect(validation.exception).to be_kind_of(ActiveRecord::RecordInvalid)
    end
  end
end
