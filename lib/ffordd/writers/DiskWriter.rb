class DiskWriter
  def initialize(file_name, file_format, presenter)
    @file_name = file_name
    @file_format = file_format
    @presenter = presenter
  end

  def export(path, translation_content)
    @export_errors = []
    @presenter.display_errors(['Path cannot be empty']) if path == ''
    File.open(@file_name+"."+@file_format, "w") { |f| f.write(translation_content)}
  end
end
