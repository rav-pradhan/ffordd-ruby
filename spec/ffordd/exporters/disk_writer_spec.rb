require 'spec_helper'
require 'ffordd/mocks/MockPresenter'

describe 'DiskWriter' do
  before(:each) { @mock_presenter = MockPresenter.new() }

  describe '.export' do
    let(:file_name) { 'tokens' }
    let(:file_format) { 'scss' }

    context 'given an invocation with an empty path' do
      it 'returns a message that the path cannot be an empty string' do
        exporter = DiskWriter.new(file_name, file_format, @mock_presenter)
        translation = "$colours: ( \t'$dark': #121111,\n \t'$light': #fff\n);\n"
        exporter.export('', translation)
        expect(@mock_presenter.display_errors_called).to eq(true)
        expect(@mock_presenter.recorded_errors).to eq(['Path cannot be empty'])
      end
    end

    context 'given an invocation with a valid path and translation content' do
      it 'writes the translation content to disk with the given file name' do
        exporter = DiskWriter.new(file_name, file_format, @mock_presenter)
        translation = "$colours: ( \n\t'$dark': #121111,\n \t'$light': #fff\n);\n"
        payload = exporter.export('.', translation)
        expect(@mock_presenter.display_errors_called).not_to eq(true)
      end
    end
  end
end
