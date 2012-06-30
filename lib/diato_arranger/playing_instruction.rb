module DiatoArranger
  class PlayingInstruction
    attr_accessor :note
    attr_accessor :duration
    attr_accessor :accompaniment

    def initialize(note = nil)
      @note = note
      @duration = nil
      @accompaniment = nil
    end

    def with_duration(duration)
      new_pi = self.clone
      new_pi.duration = duration
      new_pi
    end

    def with_accompaniment(accompaniment)
      new_pi = self.clone
      new_pi.accompaniment = accompaniment
      new_pi
    end
  end

  class PlayableNote < PlayingInstruction
    ATTRIBUTES = [:row, :direction, :button_number]
    attr_accessor *ATTRIBUTES

    def initialize(row, direction, button_number, note = nil)
      @row = row
      @direction = direction
      @button_number = button_number
      super(note)
    end

    def eql?(other)
      self.class == other.class &&
        ATTRIBUTES.all? do |attr|
          self.send(attr) == other.send(attr)
        end
    end
  
    alias == eql?
  
    def to_s
      "#{direction}(#{row}:#{button_number})=#{note}"
    end
  end

  class UnplayableNote < PlayingInstruction
    def initialize(*args)
      super
    end
  
    def eql?(other)
      self.class == other.class && self.note == other.note
    end
  
    alias == eql?
  
    def to_s
      "Unplayable: #{note}"
    end
  end
end