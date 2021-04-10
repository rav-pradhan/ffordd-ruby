class MockWriter
  attr_reader :export_called

  @export_called = false

  def export(path, translated_file)
    @export_called = true
    { path: path, file_content: translated_file }
  end
end
