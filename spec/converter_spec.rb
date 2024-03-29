require_relative '../converter.rb'

describe Converter do
  SKIP_MESSAGE = 'неактуально из-за изменения требований'.freeze

  let(:converter) { described_class.new(source_path, output_path) }
  let(:expected_html) { "spec/fixtures/index#{ task_number }.html" }
  let(:dirname) { File.dirname(output_path) }

  def delete_tmp_files
    FileUtils.rm_rf(Dir.glob("#{ dirname }/*"))
  end

  before do
    FileUtils.mkdir_p(dirname)
    delete_tmp_files
  end

  after do
    delete_tmp_files
  end

  shared_examples 'exportable_json' do
    context 'аргументы валидные' do
      let(:source_path) { "spec/fixtures/source#{ task_number }.json" }
      let(:output_path) { 'tmp/index.html' }

      it 'создаст html файл' do
        expect(File.exist?(output_path)).to be(false)

        converter.call

        expect(File.exist?(output_path)).to be(true)

        files_identical = FileUtils.compare_file(output_path, expected_html)
        expect(files_identical).to be(true)
      end
    end

    context 'невалидные аргументы' do
      context 'источник не существует' do
        let(:source_path) { "spec/fixtures/unexisted_source.json" }
        let(:output_path) { 'tmp/index.html' }

        it 'вызовет ошибку' do
          expect { converter.call }.to raise_error(Errno::ENOENT)
        end
      end

      context 'источник имеет некорректный формат' do
        let(:source_path) { "spec/fixtures/invalid_source.json" }
        let(:output_path) { 'tmp/index.html' }

        it 'вызовет ошибку' do
          expect { converter.call }.to raise_error(JSON::ParserError)
        end
      end
    end
  end

  describe '#call' do
    context 'задание 1', skip: SKIP_MESSAGE do
      let(:task_number) { 1 }

      it_behaves_like 'exportable_json'
    end

    context 'задание 2', skip: SKIP_MESSAGE do
      let(:task_number) { 2 }

      it_behaves_like 'exportable_json'
    end

    context 'задание 3' do
      let(:task_number) { 3 }

      it_behaves_like 'exportable_json'
    end

    context 'задание 4' do
      let(:task_number) { 4 }

      it_behaves_like 'exportable_json'
    end

    context 'задание 5' do
      let(:task_number) { 5 }

      it_behaves_like 'exportable_json'
    end
  end
end
