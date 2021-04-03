class SassTranslator
    def initialize(input) 
        @input = input
    end

    def translate
        unless @input.empty?
            tokenise_input
        else
            throw_error(NO_INPUT_PROVIDED)
        end       
    end

    private

    NO_INPUT_PROVIDED = "No input provided for translation"

    def tokenise_input
        @input.map do |category, category_value|
            category_tokens = tokenise_category_values(category_value)
            {'$' + category => category_tokens}
        end
    end

    def tokenise_category_values(category_value)
        category_value.map do |property, value|
            ("\t'$#{property}': #{value}")
        end
    end

    def throw_error(message)
        StandardError.new message
    end

end