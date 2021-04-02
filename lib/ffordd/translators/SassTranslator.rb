class SassTranslator
    def initialize(input) 
        @input = input
    end

    def translate
        @input.map do |category, category_value|
            category_tokens = tokenise_category_values(category_value)
            {'$' + category => category_tokens}
        end
    end

    def tokenise_category_values(category_value)
        category_value.map { |property, value|
            ("\t'$#{property}': #{value}\n")
        }
    end
end