class NoteSequence
  def initialize(notes = nil)
    @notes = notes || []
    @timings = calculate_timings(@notes)
  end
  
  def calculate_timings(notes)
    timings = {}
    current_beat = Rational(0)
    notes.map do |note|
      timings[current_beat] = note
      current_beat += note.duration
    end
    timings
  end
  
  def at(required_beat)
    beat, note = @timings.find {|beat, note| beat <= required_beat}
    note
  end
end