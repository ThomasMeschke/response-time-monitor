# frozen_string_literal: true

require 'socket'

# Offers the functionality to receive tcp requests and calls a lambda which should handle them. 
# Cann be called blocking(listen) and non-blocking(listen_async)
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
        @thread = Thread.new {listen(&callback)}
    end

    def run(&callback)
        while @running do
            session = @listener.accept
            Thread.new {
                callback.call(session)
            }
        end
    end

    def stop
        if !@thread.nil?
            @running = false
            @thread.kill
            @thread.join
        end
    end

    private :run
end