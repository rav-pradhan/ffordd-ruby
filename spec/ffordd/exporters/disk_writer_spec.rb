require 'spec_helper'
require 'ffordd/mocks/MockPresenter'

describe 'DiskWriter' do
  before(:each) { @mock_presenter = MockPresenter.new }

  describe '.export' do
    let(:file_name) { 'test_sass_tokens' }
    let(:file_format) { 'scss' }
    let(:exporter) { DiskWriter.new(file_name, file_format, @mock_presenter) }

    context 'given an invocation with an empty path and empty translation' do
      it 'should display validation failure messages' do
        exporter.export('', '')
        expect(@mock_presenter.display_errors_called).to eq(true)
        expect(@mock_presenter.recorded_errors).to eq(
          [
            'Validation failed: Path cannot be empty',
            'Validation failed: Translation cannot be empty'
          ]
        )
      end
    end

    context 'given an invocation with a valid path and translation content' do
      it 'writes the translation content to disk with the given file name' do
        translation =
          "$colours: ( \n\t'$dark': #121111,\n \t'$light': #fff\n);\n"
        exporter.export('./spec/ffordd/exporters/test_exports', translation)
        expect(File).to exist('./spec/ffordd/exporters/test_exports/test_sass_tokens.scss')
      end
    end
  end
end
