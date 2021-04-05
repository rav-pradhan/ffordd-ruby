require 'spec_helper'
require 'json'

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
        expect(@mock_presenter.display_errors_called).to be_truthy
      end
    end

    context 'when invoked with a token category that has one token' do
      let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111"}}') }
      let(:translator) { SassTranslator.new(mock_input, @mock_writer) }

      it 'correctly translates the token category and properties into a Sass list with valid syntax' do
        result = [{ '$colours' => ["\t'$dark': #121111\n);\n"] }]
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
        result = [
          { '$colours' => ["\t'$dark': #121111,\n", "\t'$light': #fff\n);\n"] }
        ]
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
        result = [
          { '$colours' => ["\t'$dark': #121111\n);\n"] },
          { '$fonts' => ["\t'$content': Times New Roman\n);\n"] }
        ]
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

class MockWriter
  attr_reader :export_called

  @export_called = false

  def export(path, translated_file)
    @export_called = true
    { path: path, file_content: translated_file }
  end
end

class MockPresenter
  attr_reader :display_errors_called, :display_success_called

  @display_errors_called = false
  @display_success_called = false

  def display_errors(errors)
    @display_errors_called = true
    errors
  end

  def display_success
    @display_success_called = true
  end
end
