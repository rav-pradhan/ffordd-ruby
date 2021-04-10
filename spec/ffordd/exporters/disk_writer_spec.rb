require 'spec_helper'
require 'fileutils'

TEST_EXPORTS_DIRECTORY = './spec/ffordd/exporters/test_exports'

RSpec.configure do |config|
  config.before(:suite) { purge_test_export_directory }
end

describe 'DiskWriter' do

  describe '.export' do
    let(:file_name) { 'test_sass_tokens' }
    let(:file_format) { 'scss' }
    let(:exporter) { DiskWriter.new(file_name, file_format) }

    context 'given an invocation with a valid path and translation content' do
      it 'writes the translation content to disk with the given file name' do
        translation =
          "$colours: ( \n\t'$dark': #121111,\n \t'$light': #fff\n);\n"
        exporter.export('./spec/ffordd/exporters/test_exports', translation)
        expect(File).to exist(
          TEST_EXPORTS_DIRECTORY + '/test_sass_tokens.scss'
        )
      end
    end
  end
end

def purge_test_export_directory
  FileUtils.rm_rf(TEST_EXPORTS_DIRECTORY)
end
