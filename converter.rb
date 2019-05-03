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
    if parsed_json.size > 1
      multiple_elements_string
    else
      single_element_string
    end
  end

  def multiple_elements_string
    li_list = elements_list.map { |el| "<li>#{ el }</li>" }.join
    "<ul>#{ li_list }</ul>"
  end

  def single_element_string
    elements_list.join
  end

  def elements_list
    parsed_json.map do |opts|
      opts.map { |tag, content| "<#{ tag }>#{ content }</#{ tag }>" }.join
    end
  end

  def parsed_json
    @parsed_json ||= JSON.load(File.read(json_path))
  end
end
