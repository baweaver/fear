include Functional

RSpec.describe ActiveRecord::Persistence do
  context '#save!' do
    it 'returns Success if valid' do
      model = TestModel.new(value: 123)

      validation = model.save!

      expect(validation).to eq Success(true)
    end

    it 'returns Failure if invalid' do
      model = TestModel.new

      validation = model.save!

      expect(validation).to be_kind_of(Failure)
      expect(validation.exception).to be_kind_of(ActiveRecord::RecordInvalid)
    end
  end

  context '#touch' do
    it 'returns Success if model persisted' do
      model = TestModel.create(value: 123)

      result = model.touch

      expect(result).to eq Success(true)
    end

    it 'returns Failure if model is not persisted' do
      model = TestModel.new(value: 123)

      result = model.touch

      expect(result).to be_kind_of(Failure)
      expect(result.exception).to be_kind_of(::ActiveRecord::ActiveRecordError)
    end
  end

  context '#update_columns' do
    it 'returns Success if model persisted' do
      model = TestModel.create(value: 123)

      updated = model.update_columns(value: 321)

      expect(updated).to eq Success(true)
    end

    it 'returns Failure if model is not persisted' do
      model = TestModel.new(value: 123)

      updated = model.update_columns(value: 321)

      expect(updated).to be_kind_of(Failure)
      expect(updated.exception).to be_kind_of(::ActiveRecord::ActiveRecordError)
    end
  end
end
