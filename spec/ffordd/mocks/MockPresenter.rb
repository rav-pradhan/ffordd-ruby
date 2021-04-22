class MockPresenter
  attr_accessor :recorded_errors

  @display_errors_called = false
  @display_success_called = false
  @display_logs_called = false
  @recorded_errors = []

  def display_errors(errors)
    @display_errors_called = true
    self.recorded_errors = errors
  end

<<<<<<< HEAD
  def display_success(success_message)
    puts success_message
=======
  def display_success(message)
>>>>>>> feature/disk_writer
    @display_success_called = true
  end

  def display_log(log)
    @display_logs_called = true
    puts log
  end

  def display_errors_called?
    @display_errors_called
  end

  def display_success_called?
    @display_success_called
  end
end
