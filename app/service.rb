# frozen_string_literal: true

require 'net/http'
require_relative 'response_time'
require_relative 'stop_watch'

# Wrapping a specific service, offering the functionality to query it
# and measure its response time
class Service
  attr_reader :name, :url, :path, :port, :last_response_time
  attr_accessor :good_below_ms, :bad_above_ms

  def initialize(name, url, path = nil, port = nil)
    @name = name
    @url = url
    @path = path || '/'
    @port = port || 80
    @good_below_ms = 200
    @bad_above_ms = 500
    @last_response_time = ResponseTime.new(nil)
  end

  def determine_response_time_async
    Thread.new do
      determine_response_time
      yield(self) if block_given?
    end
  end

  def determine_response_time
    @sw ||= StopWatch.new
    @sw.start
    result = query
    @sw.stop

    result = @sw.diff unless result.nil?
    @last_response_time = ResponseTime.new(result)
  end

  def response_time_classification
    if @last_response_time.nil? || (@last_response_time.to_i > @bad_above_ms)
      :bad
    elsif @last_response_time.to_i < @good_below_ms
      :good
    else
      :medium
    end
  end

  private

  def query
    begin
      http = Net::HTTP.new(@url, @port)
      result = http.start { |session| session.get(@path) }
    rescue StandardError => err
      puts err
      result = nil
    end
    result
  end
end
