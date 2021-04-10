require 'spec_helper'
require 'json'
require 'ffordd/mocks/MockPresenter'
require 'ffordd/mocks/MockWriter'

describe 'SassTranslator' do
  before(:each) do
    @mock_writer = MockWriter.new
    @mock_presenter = MockPresenter.new
  end

  describe '.translate' do
    context 'given an empty input' do
      let(:empty_input) { JSON.parse('{}') }

      it 'calls the presenter object\'s display_errors method' do
        SassTranslator.new(empty_input, @mock_writer).translate(@mock_presenter)
        expect(@mock_presenter.display_errors_called?).to be_truthy
      end
    end

    context 'when invoked with a token category that has one token' do
      let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111"}}') }
      let(:translator) { SassTranslator.new(mock_input, @mock_writer) }

      it 'correctly translates the token category and properties into a Sass list with valid syntax' do
        result = "$colours: (\n \t'$dark': #121111\n);\n"
        translator.translate(@mock_presenter)
        expect(translator.translation).to eq(result)
        expect(@mock_presenter.display_success).to be_truthy
      end
    end

    context 'when invoked with a token category that has multiple tokens' do
      let(:mock_input) do
        JSON.parse('{"colours": {"dark": "#121111", "light": "#fff"}}')
      end
      let(:translator) { SassTranslator.new(mock_input, @mock_writer) }

      it 'correctly translates the token category and its properties into a Sass list with valid syntax' do
        result = "$colours: (\n \t'$dark': #121111,\n \t'$light': #fff\n);\n"
        translator.translate(@mock_presenter)
        expect(translator.translation).to eq(result)
      end
    end

    context 'when invoked with two token categories that has one token each' do
      let(:mock_input) do
        JSON.parse(
          '{"colours": {"dark": "#121111"}, "fonts": {"content": "Times New Roman"}}'
        )
      end
      let(:translator) { SassTranslator.new(mock_input, @mock_writer) }

      it 'correctly translates the token categories and their properties into a Sass list with valid syntax' do
        result =
          "$colours: (\n \t'$dark': #121111\n);\n  \t'$content': Times New Roman\n);\n $colours: (\n \t'$dark': #121111\n);\n  \t'$content': Times New Roman\n);\n"
        translator.translate(@mock_presenter)
        expect(translator.translation).to eq(result)
      end
    end
  end

  describe '.export_to_file' do
    context 'when invoked before a successful translate' do
      let(:result) do
        SassTranslator
          .new(JSON.parse('{}'), @mock_writer)
          .export_to('./mock_directory')
      end

      it 'returns a message saying there is nothing to be written' do
        expect(result).to eq(
          ['Please run translate on a file first before exporting']
        )
      end
    end

    context 'when invoked with an empty path' do
      let(:mock_input) do
        JSON.parse(
          '{"colours": {"dark": "#121111"}, "fonts": {"content": "Times New Roman"}}'
        )
      end
      let(:translator) { SassTranslator.new(mock_input, @mock_writer) }

      it 'returns a message saying the export path cannot be empty' do
        translator.translate(@mock_presenter)
        expect(translator.export_to('')).to eq(['Export path cannot be empty'])
      end
    end

    context 'when invoked after a successful translate' do
      let(:mock_input) do
        JSON.parse(
          '{"colours": {"dark": "#121111"}, "fonts": {"content": "Times New Roman"}}'
        )
      end
      let(:translator) { SassTranslator.new(mock_input, @mock_writer) }

      it 'calls export from the writer dependency' do
        translator.translate(@mock_presenter)
        export_result = translator.export_to('./path')
        expect(@mock_writer.export_called).to be_truthy
        expect(export_result[:path]).to eq('./path')
      end
    end
  end
end
