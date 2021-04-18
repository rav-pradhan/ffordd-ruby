class JSONReader
  def read_file(path, presenter)
    file_for_translation = File.read(path)
    @reader_errors = []
    parse_as_json(file_for_translation)
    if @reader_errors.empty?
      presenter.display_success(
        'Successfully read file. Now ready for translation'
      )
    else
      presenter.display_errors(@reader_errors)
    end
  end

  private

  def parse_as_json(file)
    begin
      JSON.parse(file)
    rescue => exception
      @reader_errors <<
        'Error occurred when trying to parse JSON file: ' + exception.to_s
    end
  end
end
