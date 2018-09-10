# frozen_string_literal: true

require 'erb'

# Simple wrapper around ERB
class TemplateEngine
  def initialize(template_file)
    @template = File.read(template_file)
    @erb = ERB.new(@template)
  end

  def render(binding)
    @erb.result(binding)
  end
end
