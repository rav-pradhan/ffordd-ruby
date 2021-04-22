require 'spec_helper'
require 'ffordd/mocks/MockPresenter'
require 'json'

describe 'JSON Reader' do
  before(:each) { @mock_presenter = MockPresenter.new }
  describe '.read_file' do
    context 'given a valid JSON file' do
      let(:mock_valid_json_path) do
        './spec/ffordd/readers/test_imports/valid.json'
      end
      it 'provides a parsed JSON output ready for translation' do
        reader = JSONReader.new
        parsed_file = reader.read_file(mock_valid_json_path, @mock_presenter)
        expected_result =
          JSON.parse('{"colours": {"dark": "#121111", "light": "#fff"}}')
        expect(@mock_presenter.display_success_called?).to be_truthy
      end
    end

    context 'given an invalid JSON file' do
      let(:mock_invalid_json_path) do
        './spec/ffordd/readers/test_imports/invalid.json'
      end
      it 'informs the user that the file is not valid JSON' do
        reader = JSONReader.new
        parsed_file = reader.read_file(mock_invalid_json_path, @mock_presenter)
        expect(@mock_presenter.display_errors_called?).to be_truthy
      end
    end
  end
end
