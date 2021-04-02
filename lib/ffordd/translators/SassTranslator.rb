class SassTranslator
    def initialize(input) 
        @input = input
    end

    def translate()
        output = []
        @input.each do |category, category_value|
            category_tokens = []
            category_value.each do |property, value|
                category_tokens.push("\t'$#{property}': #{value}\n")
            end
            result = {
                '$' + category => category_tokens
            }
            output.push(result)
        end
        return output
    end
end