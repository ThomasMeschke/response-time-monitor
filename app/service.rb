# frozen_string_literal: true

require 'net/http'
require_relative 'response_time'
require_relative 'stop_watch'

# Wrapping a specific service, offering the functionality to query it and measure its response time
class Service

    attr_reader :name, :url, :path, :port, :last_response_time, :response_time_classification

    def initialize(name, url, path = nil, port = nil, good_below_ms = nil, bad_above_ms = nil)
        @name = name
        @url = url
        @path = path || '/'
        @port = port || 80
        @good_below_ms = good_below_ms || 200
        @bad_above_ms = bad_above_ms || 500
        @last_response_time = ResponseTime.new(nil)
    end

    def determine_response_time_async(&callback)
        Thread.new {
            determine_response_time
            callback.call(self)
        }
    end

    def determine_response_time
        @sw ||= StopWatch.new
        @sw.start
        result = query
        @sw.stop

        if !result.nil? 
            result = @sw.diff
        end
        @last_response_time = ResponseTime.new(result)
    end

    def query
        begin
            http = Net::HTTP.new(@url, @port)
            http.read_timeout = 2
            http.open_timeout = 2

            result = http.start() { |http| 
                http.get(@path)
            }
        rescue StandardError => err
            result = nil
        end
        result
    end

    def response_time_classification
        if @last_response_time.nil? || (@last_response_time.to_i > @bad_above_ms)
            :bad
        elsif (@last_response_time.to_i < @good_below_ms)
            :good
        else
            :medium
        end
    end

    private :query
end
