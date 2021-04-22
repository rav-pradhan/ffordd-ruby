require 'spec_helper'

describe 'ConsolePresenter' do
  describe '.display_success' do
    context 'given a message is passed to the presenter' do
      let(:message) { 'This is a successful message' }

      it 'prints the message with green text onto the console' do
        presenter = ConsolePresenter.new
        expect { presenter.display_success(message) }.to output(
          "\e[0;32;49mThis is a successful message\e[0m\n"
        ).to_stdout
      end
    end
  end

  describe '.display_error' do
    context 'given a message is passed to the presenter' do
      let(:message) { 'This is a fail state message' }
      it 'prints the message with red text onto the console' do
        presenter = ConsolePresenter.new
        expect { presenter.display_error(message) }.to output(
          "\e[0;31;49mThis is a fail state message\e[0m\n"
        ).to_stdout
      end
    end
  end
end
