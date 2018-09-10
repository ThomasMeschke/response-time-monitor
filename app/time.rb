# frozen_string_literal: true

# This class extends the ruby std lib Time class
class Time
  def to_ms
    (to_f * 1000.0).to_i
  end
end
