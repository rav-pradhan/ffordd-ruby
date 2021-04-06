require 'spec_helper'
require 'ffordd/mocks/MockPresenter'

describe 'DiskWriter' do
  before(:each) { @mock_presenter = MockPresenter.new }

  describe '.export' do
    context 'given an invocation with empty path' do
      it 'returns a message that the path cannot be an empty string' do
        exporter = DiskWriter.new(@mock_presenter)
        translation = [{ '$colours' => ["\t'$dark': #121111,\n);\n"] }]
        exporter.export('', translation)
        expect(@mock_presenter.display_errors_called).to eq(true)
        expect(@mock_presenter.recorded_errors).to eq(['Path cannot be empty'])
      end
    end
  end
end
