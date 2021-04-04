require 'spec_helper'
require 'json'

describe 'SassTranslator' do
  before(:each) { @mock_writer = MockWriter.new }

  describe '.translate' do
    context 'given an empty input' do
      let(:empty_input) { JSON.parse('{}') }
      let(:translation) do
        SassTranslator.new(empty_input, @mock_writer).translate
      end

      it 'returns a message saying no input has been provided' do
        expect(translation[:errors]).to eq(
          ['No input provided for translation']
        )
      end
    end

    context 'when invoked with a token category that has one token' do
      let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111"}}') }
      let(:translation) do
        SassTranslator.new(mock_input, @mock_writer).translate
      end

      it 'correctly translates the token category and properties into a Sass list with valid syntax' do
        result = [{ '$colours' => ["\t'$dark': #121111\n);\n"] }]
        expect(translation[:result]).to eq(result)
      end
    end

    context 'when invoked with a token category that has multiple tokens' do
      let(:mock_input) do
        JSON.parse('{"colours": {"dark": "#121111", "light": "#fff"}}')
      end
      let(:translation) do
        SassTranslator.new(mock_input, @mock_writer).translate
      end

      it 'correctly translates the token category and its properties into a Sass list with valid syntax' do
        result = [
          { '$colours' => ["\t'$dark': #121111,\n", "\t'$light': #fff\n);\n"] }
        ]
        expect(translation[:result]).to eq(result)
      end
    end

    context 'when invoked with two token categories that has one token each' do
      let(:mock_input) do
        JSON.parse(
          '{"colours": {"dark": "#121111"}, "fonts": {"content": "Times New Roman"}}'
        )
      end
      let(:translation) do
        SassTranslator.new(mock_input, @mock_writer).translate
      end

      it 'correctly translates the token categories and their properties into a Sass list with valid syntax' do
        result = [
          { '$colours' => ["\t'$dark': #121111\n);\n"] },
          { '$fonts' => ["\t'$content': Times New Roman\n);\n"] }
        ]
        expect(translation[:result]).to eq(result)
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
        translation_result = translator.translate
        export_result = translator.export_to('./path')
        expect(@mock_writer.has_been_called).to be_truthy
      end
    end
  end
end

class MockWriter
  @export_called = nil
  def export(path, translation)
    @export_called = true
  end

  def has_been_called
    @export_called
  end
end
