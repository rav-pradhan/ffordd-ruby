class SassTranslator
  @translation = []

  def initialize(input)
    @input = input
  end

  def translate
    @translation_errors = []
    check_input_state
    translate_to_valid_syntax
    translate_result_payload
  end

  def export_to(path)
    @export_errors = []

    check_output_state
    export_result_payload
  end

  private

  def check_input_state
    @translation_errors << 'No input provided for translation' if @input.empty?
  end

  def check_output_state
    if @translation.nil?
      @export_errors << 'Please run translate on a file first before exporting'
    end
  end

  def translate_to_valid_syntax
    @translation =
      @input.map do |category, category_value|
        category_tokens = tokenise_category_values(category_value)
        { '$' + category => category_tokens }
      end
  end

  def tokenise_category_values(category_value)
    category_value.map.with_index do |(property, value), index|
      ("\t'$#{property}': #{value}")
    end
  end

  def translate_result_payload
    return { errors: @translation_errors } unless @translation_errors.empty?
    @translation
  end

  def export_result_payload
    return { errors: @export_errors } unless @export_errors.empty?
  end
end
