class SassTranslator
  attr_reader :translation

  def initialize(input, writer)
    @input = input
    @writer = writer
    @translation = []
  end

  def translate(presenter)
    @translation_errors = []
    check_input_state
    translate_input_to_valid_syntax
    stringify_translation_for_export
    if @translation_errors.empty?
      presenter.display_success
    else
      presenter.display_errors(@translation_errors)
    end
  end

  def export_to(path)
    @export_errors = []
    check_output_state
    @export_errors.empty? ? @writer.export(path, @translation) : @export_errors
  end

  private

  def check_input_state
    @translation_errors << 'No input provided for translation' if @input.empty?
  end

  def check_output_state
    if @translation.empty?
      @export_errors << 'Please run translate on a file first before exporting'
    end
  end

  def translate_input_to_valid_syntax
    @translation =
      @input.map do |category, category_value|
        category_tokens = tokenise_category_values(category_value)
        { '$' + category + ": (\n" => category_tokens }
      end
  end

  def tokenise_category_values(category_value)
    category_value.map.with_index do |(property, value), index|
      if category_value.length - 1 == index
        ("\t'$#{property}': #{value}\n") + (");\n")
      else
        ("\t'$#{property}': #{value},\n")
      end
    end
  end

  def stringify_translation_for_export()
    stringified_output = []
    stringified_output =
      @translation.map.with_index do |(property, value), index|
        stringified_output << property.keys[index]
        property.map do |token_key, token_value|
          stringified_output << token_value
        end
      end
    @translation = stringified_output.join(' ')
  end
end
