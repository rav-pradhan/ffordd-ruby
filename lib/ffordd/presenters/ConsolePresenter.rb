require 'colorize'

class ConsolePresenter
  def display_success(message)
    puts message.green
  end

  def display_error(message)
    puts message.red
  end
end
