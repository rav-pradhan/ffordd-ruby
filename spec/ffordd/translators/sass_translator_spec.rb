require "spec_helper"
require "json"

describe "SassTranslator" do

    describe ".translate" do

        context "when an empty input is provided" do
            let(:empty_input) { JSON.parse('{}')}
            let(:output) { SassTranslator.new(empty_input).translate() }

            it "throws an empty input error" do
                result = StandardError.new "No input provided for translation"
                expect(output).to eq(result)
            end
        end

        context "when invoked with a token category that has one token" do
            let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111"}}') }
            let(:output) { SassTranslator.new(mock_input).translate() }

            it "correctly translates it into a hash map with one Sass list" do
                result = [{"$colours"=>["\t\'$dark\': #121111"]}]
                expect(output).to eq(result)
            end
        end

        context "when invoked with a token category that has multiple tokens" do
            let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111", "light": "#fff"}}')}
            let(:output) { SassTranslator.new(mock_input).translate() }

            it "correctly translates into a hash map with two elements" do
                result = [{"$colours"=>["\t\'$dark\': #121111", "\t'$light': #fff"]}]
                expect(output).to eq(result)
            end
        end

        context "when invoked with two token categories that has one token each" do
            let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111"}, "fonts": {"content": "Times New Roman"}}') }
            let(:output) { SassTranslator.new(mock_input).translate() }

            it "correctly translates them into a hash map with two Sass lists" do
                result = [{"$colours"=>["\t\'$dark\': #121111"]}, {"$fonts"=>["\t\'$content\': Times New Roman"]}]
                expect(output).to eq(result)
            end
        end
    end

end