class SassTranslator
    def initialize(input) 
        @input = input
    end

    def translate()
        @input.map { |category, category_value|
            category_tokens = tokenise_category_values(category_value)
            result = {'$' + category => category_tokens}
        }
    end

    def tokenise_category_values(category_value)
        category_value.map { |property, value|
            result = ("\t'$#{property}': #{value}\n")
        }
    end
end