# frozen_string_literal: true

require_relative 'time'

# Offers the functionality to measure timings of certain actions,
# either by hand using 'start' and 'stop' or by specifying a block to 'measure'
class StopWatch
  def start
    @start_time = Time.now
    @end_time = nil
  end

  def stop
    @end_time = Time.now
  end

  def diff
    return @end_time.to_ms - @start_time.to_ms unless !@start_time || !@end_time

    raise 'StopWatch has not been started or not been stopped!'
  end

  def measure
    start
    yield if block_given?
    stop
    diff
  end
end
