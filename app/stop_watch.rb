# frozen_string_literal: true

require_relative 'time'

# Offers the functionality to measure timings of certain actions, 
# either by hand using 'start' and 'stop' or by specifying a block to 'measure'
class StopWatch
    def start
        @start_time = Time::now
        @end_time = nil
    end

    def stop
        @end_time = Time::now
    end

    def diff
        if !@start_time || !@end_time
            raise 'StopWatch has not been started or not been stopped!'
        else
            @end_time.to_ms() - @start_time.to_ms()
        end
    end

    def measure(&block)
        start
        block.call
        stop
        diff
    end
end