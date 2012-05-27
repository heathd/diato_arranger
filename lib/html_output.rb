class HtmlOutput
  def initialize(arrangement)
    @arrangement = arrangement
  end
  
  def to_s
    %Q{
<!DOCTYPE html>
<html>
<head>
<title>Arrangement</title>
<style>
div.row {
  border-bottom: 1px solid black;
  float: left;
  clear: left;
  margin-top: 1em;
}
.playing_instructions div.note {
  float: left;
  position: relative;
  width: 2em;
  height: 8em;
}
.playing_instructions div.note.duration_2 {
  width: 4em;
}
.playing_instructions div.note.duration_3 {
  width: 6em;
}
.playing_instructions div.note.duration_4 {
  width: 8em;
}
.playing_instructions .barline {
  float: left;
  height: 8em;
  width: 1px;
  margin-right: 0.5em;
  background-color: black;
}
div.note span.duration {
  position: absolute;
  top: 0;
  font-face: quivra;
  font-size: 2em;
}
div.note span.instruction.c_row {
  position: absolute;
  top: 2em;
}
div.note span.instruction.g_row {
  position: absolute;
  top: 4em;
}
div.note span.letter {
  position: absolute;
  top: 6em;
}
.pull {
  text-decoration: underline
}
</style>
</head>

<body>
<h1>Music arrangement</h1>

<div class="playing_instructions">

#{music_instructions}
</div>
</body>
</html>
}
  end

  def duration_class(duration)
    duration_multiple = (duration / shortest_note_duration).to_i
    "duration_#{duration_multiple}"
  end

  def duration_symbol(duration)
    duration_multiple = (duration / shortest_note_duration).to_i
    augmentation_dot = '&#x1D16D;'
    quaver = '&#x1D160;'
    crotchet = '&#x1D15F;'
    minim = '&#x1D15E;'
    semibreve = '&#x1D15D;'
    notes_by_duration = {
      1 => quaver,
      2 => crotchet,
      3 => crotchet + augmentation_dot,
      4 => minim
    }
    notes_by_duration[duration_multiple] or raise "No symbol for duration #{duration_multiple}"
  end

  def shortest_note_duration
    @shortest_note_duration ||= @arrangement.map(&:duration).min
  end

  def music_instructions
    bars = []
    bar = []
    current_bar_length = Rational(0)
    @arrangement.map do |playing_instruction| 
      bar << case playing_instruction
      when PlayableNote then
        "<div class='note #{duration_class(playing_instruction.duration)}'>" +
          "<span class='duration #{playing_instruction.direction}'>#{duration_symbol(playing_instruction.duration)}</span>" +
          "<span class='instruction #{playing_instruction.direction} #{playing_instruction.row}'>#{playing_instruction.button_number}</span>" +
          "<span class='letter #{playing_instruction.direction}'>#{playing_instruction.note.to_s(false)}</span>" +
        "</div>\n"
      when UnplayableNote then
        "<div class='note unplayable #{duration_class(playing_instruction.duration)}'>" + 
          "<span class='duration'>#{duration_symbol(playing_instruction.duration)}</span>" +
          "<span class='instruction'>?</span>" +
          "<span class='letter'>#{playing_instruction.note.to_s(false)}</span>" +
        "</div>\n"
      end
      current_bar_length += playing_instruction.duration
      if current_bar_length >= Rational(4,1)
        bars << bar.join
        bar = []
        current_bar_length = Rational(0)
      end
    end

    bars << bar.join

    rows = []
    bars.each_slice(8) do |slice|
      rows << slice.join("<div class='barline'></div>\n")
    end
    rows.map do |row|
      "<div class='row'>#{row}</div>\n"
    end.join
  end
end
