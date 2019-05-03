require 'json'

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
    parsed_json.map { |h| "<h1>#{ h['title'] }</h1><p>#{ h['body'] }</p>" }.join
  end

  def parsed_json
    @parsed_json ||= JSON.load(File.read(json_path))
  end
end
