include Functional

RSpec.describe ActiveRecord::Core do
  let!(:model) { TestModel.create(value: 123) }

  context '#find' do
    it 'returns Failure if not found' do
      found_model = TestModel.find(12345)

      expect(found_model).to be_kind_of(Failure)
      expect(found_model.exception).to be_kind_of(ActiveRecord::RecordNotFound)
    end

    it 'return Success if found' do
      found_model = TestModel.find(model.id)

      expect(found_model).to be_kind_of(Success)
      expect(found_model.get).to eq model
    end
  end

  context '#find_by' do
    it 'returns None if not found' do
      found_model = TestModel.find_by(id: 12345)

      expect(found_model).to be_kind_of(None)
    end

    it 'returns Some if found' do
      found_model = TestModel.find_by(id: model.id)

      expect(found_model).to eq Some(model)
    end
  end

  context '#find_by!' do
    it 'returns Failure if not found' do
      found_model = TestModel.find_by!(id: 12345)

      expect(found_model).to be_kind_of(Failure)
      expect(found_model.exception).to be_kind_of(ActiveRecord::RecordNotFound)
    end

    it 'returns Success if found' do
      found_model = TestModel.find_by!(id: model.id)

      expect(found_model).to eq Success(model)
    end
  end
end
