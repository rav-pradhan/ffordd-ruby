class SassTranslator
    def initialize(input) 
        @input = input
    end

    def translate()
        output = []
        @input.each do |category, category_value|
            category_tokens = tokenise_category_values(category_value)
            result = {'$' + category => category_tokens}
            output.push(result)
        end
        return output
    end

    def tokenise_category_values(category_value)
        tokens = []
        category_value.each do |property, value|
            tokens.push("\t'$#{property}': #{value}\n")
        end
        return tokens
    end
end