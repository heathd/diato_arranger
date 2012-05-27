class PlayingInstruction
  attr_accessor :note
  attr_accessor :duration

  def initialize(note = nil)
    @note = note
    @duration = nil
  end

  def with_duration(duration)
    new_playing_instruction = self.clone
    new_playing_instruction.duration = duration
    new_playing_instruction
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