# frozen_string_literal: true

require 'socket'

# Offers the functionality to receive tcp requests
# and calls a lambda which should handle them.
# Can be called blocking(listen) and non-blocking(listen_async)
class WebServer
  def initialize(addr, port)
    @addr = addr
    @port = port
    @running = false
  end

  def listen(&callback)
    @listener = TCPServer.new(@addr, @port)
    @running = true
    run(&callback)
  end

  def listen_async(&callback)
    @thread = Thread.new { listen(&callback) }
  end

  def stop
    return unless @thread.nil?

    @running = false
    @thread.kill
    @thread.join
  end

  private

  def run
    while @running
      session = @listener.accept
      Thread.new do
        yield(session) if block_given?
      end
    end
  end
end
