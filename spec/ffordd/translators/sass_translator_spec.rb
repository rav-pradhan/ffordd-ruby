require "spec_helper"
require "json"

describe "SassTranslator" do

    describe ".translate" do

        context "when translate is invoked with a parsed, one-line, JSON object as its input" do
            mock_input = JSON.parse('{"colours": {"dark": "#121111"}}')
            let(:output) { SassTranslator.new(mock_input).translate() }
            
            it "translates the JSON's key/value properties into a Sass list of variables" do
                result = [{"$colours"=>["\t\'$dark\': #121111\n"]}]
                expect(output).to eq(result)
            end
        end
    end

end