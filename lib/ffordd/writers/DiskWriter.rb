class DiskWriter
  def initialize(presenter)
    @presenter = presenter
  end

  def export(path, translation_content)
    @export_errors = []
    @presenter.display_errors(['Path cannot be empty']) if path == ''
  end
end
