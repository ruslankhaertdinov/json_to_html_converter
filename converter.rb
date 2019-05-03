require 'json'
require 'byebug'

class Converter
  attr_reader :json_path
  private :json_path

  def initialize(json_path)
    @json_path = json_path
  end

  def to_html(output_path)
    File.write(output_path, "#{ html_string }\n")
  end

  private

  def html_string
    parsed_json.flat_map do |opts|
      opts.map do |tag, content|
        "<#{ tag }>#{ content }</#{ tag }>"
      end
    end.join
  end

  def parsed_json
    @parsed_json ||= JSON.load(File.read(json_path))
  end
end
