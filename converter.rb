require 'json'
require 'byebug'

class Converter
  attr_reader :json_path
  private :json_path

  def initialize(json_path)
    @json_path = json_path
  end

  def to_html(output_path)
    File.write(output_path, "#{ handle_content(parsed_json) }\n")
  end

  private

  def handle_content(content)
    if content.is_a?(Array)
      "<ul>#{ ul(content) }</ul>"
    else
      content
    end
  end

  def ul(content)
    content.flat_map do |opts|
      "<li>#{ li(opts) }</li>"
    end.join
  end

  def li(opts)
    opts.map do |tag, content|
      "<#{ tag }>#{ handle_content(content) }</#{ tag }>"
    end.join
  end

  def parsed_json
    @parsed_json ||= JSON.load(File.read(json_path))
  end
end
