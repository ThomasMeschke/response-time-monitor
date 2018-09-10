# frozen_string_literal: true

require 'json'

# Wraps the config file
class Config
  @look_for_file = 'config/config.json'
  @fallback_file = 'config/sample_config.json'

  def self.from_file(filename = nil)
    filename ||= @fallback_file
    json = File.read(filename)
    Config.from_json(json)
  end

  def self.from_json(json)
    @settings = JSON.parse(json)
  end

  def self.[](element)
    if @settings.nil?
      config_file = File.exist?(@look_for_file) ? @look_for_file : nil
      Config.from_file(config_file)
    end
    @settings[element]
  end
end
