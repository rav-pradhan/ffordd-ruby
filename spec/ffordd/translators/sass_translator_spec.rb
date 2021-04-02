require "spec_helper"
require "json"

describe "SassTranslator" do

    describe ".translate" do
        context "when translate is invoked with a design token category that has token" do
            let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111"}}') }
            let(:output) { SassTranslator.new(mock_input).translate() }

            it "correctly translates it into a Sass list" do
                result = [{"$colours"=>["\t\'$dark\': #121111\n"]}]
                expect(output).to eq(result)
            end
        end

        context "when translate is invoked with two token categories that has one token each" do
            let(:mock_input) { JSON.parse('{"colours": {"dark": "#121111"}, "fonts": {"content": "Times New Roman"}}') }
            let(:output) { SassTranslator.new(mock_input).translate() }

            it "correctly translates them into two Sass lists" do
                result = [{"$colours"=>["\t\'$dark\': #121111\n"]}, {"$fonts"=>["\t\'$content\': Times New Roman\n"]}]
                expect(output).to eq(result)
            end
        end
    end

end