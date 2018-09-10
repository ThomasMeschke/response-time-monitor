# frozen_string_literal: true

require_relative 'stop_watch'

# Offers the functionality to get a 'tick'
# after every <interval_ms> milliseconds.
# 'start' takes a lambda as callback
class ClockWork
  def initialize(interval_ms)
    @interval_ms = interval_ms
    @running = false
  end

  def start(&callback)
    @running = true
    @thread = Thread.new do
      run(&callback)
    end
  end

  def stop
    @running = false
    @thread.kill
    @thread.join
  end

  private

  def run
    @sw ||= StopWatch.new
    while @running
      execution_time_ms = @sw.measure do
        yield if block_given?
      end
      sleep_time_ms = @interval_ms - execution_time_ms
      sleep(sleep_time_ms / 1000)
    end
  end
end
