require_relative '../converter.rb'

describe Converter do
  let(:converter) { described_class.new(json_path) }
  let(:html_result_path) { 'tmp/index.html' }
  let(:dirname) { File.dirname(html_result_path) }
  let(:json_path) { "spec/fixtures/source#{ task_number }.json" }
  let(:expected_html) { "spec/fixtures/index#{ task_number }.html" }

  before { FileUtils.mkdir_p(dirname) }
  after { FileUtils.rm_rf(dirname) }

  shared_examples 'parsable_json' do
    it 'создаст html файл' do
      expect(File.exist?(html_result_path)).to be(false)

      converter.to_html(html_result_path)

      expect(File.exist?(html_result_path)).to be(true)

      files_identical = FileUtils.compare_file(html_result_path, expected_html)
      expect(files_identical).to be(true)
    end
  end

  describe '#to_html' do
    xcontext 'задание 1' do
      let(:task_number) { 1 }

      it_behaves_like 'parsable_json'
    end

    xcontext 'задание 2' do
      let(:task_number) { 2 }

      it_behaves_like 'parsable_json'
    end

    context 'задание 3' do
      let(:task_number) { 3 }

      it_behaves_like 'parsable_json'
    end

    context 'задание 4' do
      let(:task_number) { 4 }

      it_behaves_like 'parsable_json'
    end

    context 'задание 5' do
      let(:task_number) { 5 }

      it_behaves_like 'parsable_json'
    end
  end
end
