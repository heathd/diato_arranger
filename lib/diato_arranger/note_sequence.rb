module DiatoArranger
  class NoteSequence
    def initialize(notes = nil)
      @notes = notes || []
    end
  
    def at(required_beat)
      @notes.reverse.find do |note|
        note.beat_number <= required_beat
      end
    end
  end
end