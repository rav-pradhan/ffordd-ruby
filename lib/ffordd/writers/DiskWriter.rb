require 'fileutils'
class DiskWriter
  def initialize(file_name, file_format)
    @file_name = file_name
    @file_format = file_format
  end

  def export(path, translation_content)
    @export_errors = []
    export_file = create_file_in(path)
    write_translation_to(export_file, translation_content)
  end

  private

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
