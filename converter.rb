require 'json'
require 'byebug'

class Converter
  CSS_CLASS_FORMAT = /\.\w+-*\w*/
  CSS_ID_FORMAT = /#\w+-*\w*/
  CSS_TAG_FORMAT = /^\w+/

  attr_reader :source_path, :output_path
  private :source_path, :output_path

  def initialize(source_path, output_path)
    @source_path = source_path
    @output_path = output_path
  end

  def call
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
    opts.map do |key, value|
      "<#{ opening_tag(key) }>#{ handle_content(value) }</#{ extract_tag(key) }>"
    end.join
  end

  def opening_tag(string)
    [extract_tag(string), extract_id(string), extract_classes(string)].compact.join(' ')
  end

  def extract_tag(string)
    string.scan(CSS_TAG_FORMAT)[0]
  end

  def extract_id(string)
    id = string.scan(CSS_ID_FORMAT).map { |str| str[1..-1] }[0]
    return nil if id.nil?

    %[id="#{ id }"]
  end

  def extract_classes(string)
    list = string.scan(CSS_CLASS_FORMAT).map { |str| str[1..-1] }
    return nil if list.empty?

    %[class="#{ list.join(' ') }"]
  end

  def handle_string(content)
    CGI::escapeHTML(content)
  end

  def parsed_json
    @parsed_json ||= JSON.load(File.read(source_path))
  end
end
