class MockPresenter
  attr_accessor :display_errors_called,
                :display_success_called,
                :recorded_errors

  @display_errors_called = false
  @display_success_called = false
  @recorded_errors = []

  def display_errors(errors)
    @display_errors_called = true
    self.recorded_errors = errors
  end

  def display_success
    @display_success_called = true
  end
end
