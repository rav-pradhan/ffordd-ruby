require 'spec_helper'
require 'json'

describe 'SassTranslator' do
  describe '.translate' do
    context 'given an empty input' do
      let(:empty_input) { JSON.parse('{}') }
      let(:translation) { SassTranslator.new(empty_input).translate }

      it 'returns a message saying no input has been provided' do
        expect(translation[:errors]).to eq(
          ['No input provided for translation']
        )
      end
    end

    context 'when invoked with a token category that has one token' do
      let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111"}}') }
      let(:translation) { SassTranslator.new(mock_input).translate }

      it 'correctly translates the token category and properties into a Sass list with valid syntax' do
        result = [{ '$colours' => ["\t\'$dark\': #121111"] }]
        expect(translation).to eq(result)
      end
    end

    context 'when invoked with a token category that has multiple tokens' do
      let(:mock_input) do
        JSON.parse('{"colours": {"dark": "#121111", "light": "#fff"}}')
      end
      let(:translation) { SassTranslator.new(mock_input).translate }

      it 'correctly translates the token category and its properties into a Sass list with valid syntax' do
        result = [
          {
            '$colours: (' => [
              "\t\'$dark\': #121111,\n",
              "\t'$light': #fff\n",
              ")\n"
            ]
          }
        ]
        expect(translation).to eq(result)
      end
    end

    context 'when invoked with two token categories that has one token each' do
      let(:mock_input) do
        JSON.parse(
          '{"colours": {"dark": "#121111"}, "fonts": {"content": "Times New Roman"}}'
        )
      end
      let(:translation) { SassTranslator.new(mock_input).translate }

      it 'correctly translates the token categories and their properties into a Sass list with valid syntax' do
        result = [
          { '$colours' => ["\t\'$dark\': #121111"] },
          { '$fonts' => ["\t\'$content\': Times New Roman"] }
        ]
        expect(translation).to eq(result)
      end
    end
  end

  describe '.export_to_file' do
    context 'when invoked before a successful translate' do
      let(:result) do
        SassTranslator.new(JSON.parse('{}')).export_to('./mock_directory')
      end

      it 'returns a message saying there is nothing to be written' do
        expect(result[:errors]).to eq(
          ['Please run translate on a file first before exporting']
        )
      end
    end
  end
end
