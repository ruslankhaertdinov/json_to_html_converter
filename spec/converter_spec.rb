require_relative '../converter.rb'

RSpec.describe Converter do
  let(:converter) { described_class.new(json_path) }
  let(:html_result_path) { 'tmp/index.html' }
  let(:dirname) { File.dirname(html_result_path) }

  before { FileUtils.mkdir_p(dirname) }
  after { FileUtils.rm_rf(dirname) }

  describe '#to_html' do
    subject(:create_html) { converter.to_html(html_result_path) }

    context 'первое задание' do
      let(:json_path) { 'spec/fixtures/source1.json' }
      let(:expected_html) { 'spec/fixtures/index1.html' }

      it 'создаст html файл' do
        expect(File.exist?(html_result_path)).to eq(false)

        create_html

        expect(File.exist?(html_result_path)).to eq(true)

        files_identical = FileUtils.compare_file(html_result_path, expected_html)
        expect(files_identical).to eq(true)
      end
    end
  end
end
