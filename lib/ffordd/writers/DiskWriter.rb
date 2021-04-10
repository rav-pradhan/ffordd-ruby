require 'fileutils'
class DiskWriter
  def initialize(file_name, file_format)
    @file_name = file_name
    @file_format = file_format
  end

  def export(path, translation_content)
    @export_errors = []
    validate_inputs(path, translation_content)
    return @presenter.display_errors(@export_errors) if !@export_errors.empty?
    export_file = create_file_in(path)
    write_translation_to(export_file, translation_content)
  end

  private

  def validate_inputs(path, translation)
    @export_errors << 'Validation failed: Path cannot be empty' if path.empty?
    if translation.empty?
      @export_errors << 'Validation failed: Translation cannot be empty'
    end
  end

  def create_file_in(path)
    FileUtils.mkdir_p(path) unless File.directory?(path)
    path << '/' + @file_name + ".#{@file_format}"
    File.new(path, 'w')
  end

  def write_translation_to(export_file, translation_content)
    puts export_file.path
    File.write(export_file, translation_content)
  end
end
