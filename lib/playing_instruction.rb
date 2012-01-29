class PlayingInstruction
  ATTRIBUTES = [:row, :direction, :button_number]
  attr_accessor *ATTRIBUTES
  
  def initialize(row, direction, button_number)
    @row = row
    @direction = direction
    @button_number = button_number
  end
  
  def eql?(other)
    self.class == other.class &&
      ATTRIBUTES.all? do |attr|
        self.send(attr) == other.send(attr)
      end
  end
  
  alias == eql?
  
  def hash
    ATTRIBUTES.map do |attr|
      [attr, self.send(attr)]
    end.hash
  end
  
  def to_s
    "#{direction}(#{row}:#{button_number})"
  end
end