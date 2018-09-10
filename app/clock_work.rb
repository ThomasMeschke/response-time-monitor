# frozen_string_literal: true

require_relative 'stop_watch'

# Offers the functionality to get a 'tick' after every <interval_ms> milliseconds. 
# 'start' takes a lambda as callback
class ClockWork
    def initialize(interval_ms)
        @interval_ms = interval_ms
        @running = false
    end

    def start(&callback)
        @running = true
        @thread = Thread.new {run(&callback)}
    end

    def run(&callback)
        @sw ||= StopWatch.new
        while @running do
            execution_time_ms = @sw.measure {
                callback.call
            }
            sleep_time_ms = @interval_ms - execution_time_ms
            sleep(sleep_time_ms / 1000)
        end
    end

    def stop
        @running = false
        @thread.kill
        @thread.join
    end

    private :run
end