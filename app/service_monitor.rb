# frozen_string_literal: true

require_relative 'clock_work'
require_relative 'service'

# Wraps the functionality to repeatedly gather the response times
# for a given set of services
class ServiceMonitor
  def initialize(service_collection)
    @services = service_collection
  end

  def on_response_time_updated
    lambda { |service|
      puts "<< #{service.name} --> #{service.last_response_time} "\
           "(#{service.response_time_classification})"
    }
  end

  def on_clock_tick
    lambda {
      @services.each do |service|
        puts ">> #{service.name}"
        service.determine_response_time_async(&on_response_time_updated)
      end
    }
  end

  def watch(interval_seconds = nil)
    interval_seconds ||= 10
    @clock ||= ClockWork.new(interval_seconds * 1000)
    @clock.start(&on_clock_tick)
  end
end
