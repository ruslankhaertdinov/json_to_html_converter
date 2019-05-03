require 'json'
require 'byebug'

class Converter
  attr_reader :json_path
  private :json_path

  CSS_CLASS_FORMAT = /\.\w+-*\w*/
  CSS_ID_FORMAT = /#\w+-*\w*/
  CSS_TAG_FORMAT = /^\w+/

  def initialize(json_path)
    @json_path = json_path
  end

  def to_html(output_path)
    File.write(output_path, "#{ handle_content(parsed_json) }\n")
  end

  private

  def handle_content(content)
    if content.is_a?(Array)
      "<ul>#{ handle_array(content) }</ul>"
    elsif content.is_a?(Hash)
      handle_hash(content)
    else
      handle_string(content)
    end
  end

  def handle_array(list)
    list.flat_map do |opts|
      "<li>#{ handle_hash(opts) }</li>"
    end.join
  end

  def handle_hash(opts)
    opts.map do |tag, content|
      "<#{ opening_tag(tag) }>#{ handle_content(content) }</#{ extract_tag(tag) }>"
    end.join
  end

  def opening_tag(string)
    [extract_tag(string), extract_id(string), extract_classes(string)].compact.join(' ')
  end

  def extract_tag(string)
    string.scan(CSS_TAG_FORMAT)[0]
  end

  def extract_classes(string)
    list = string.scan(CSS_CLASS_FORMAT).map { |str| str[1..-1] }
    return nil if list.empty?

    "class=\"#{ list.join(' ') }\""
  end

  def extract_id(string)
    id = string.scan(CSS_ID_FORMAT).map { |str| str[1..-1] }[0]
    return nil if id.nil?

    "id=\"#{ id }\""
  end

  def handle_string(content)
    CGI::escapeHTML(content)
  end

  def parsed_json
    @parsed_json ||= JSON.load(File.read(json_path))
  end
end
