# frozen_string_literal: true

# Wrapping a given service response time
class ResponseTime
    def initialize(time)
        @time = time
    end

    def to_s
        if @time.nil?
            "N/A"
        else
            "#{@time}ms"
        end
    end

    def to_i
        if @time.nil?
            Float::INFINITY
        else
            @time
        end
    end
end