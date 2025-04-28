jQuery(function() {
  var $canvas = $(".music");
  var canvas = $canvas[0];
  var renderer = new Vex.Flow.Renderer(canvas,
    Vex.Flow.Renderer.Backends.RAPHAEL);

  var ctx = renderer.getContext();
  var stave = new Vex.Flow.Stave(10, 0, 500);

  // Add a treble clef
  stave.addClef("treble");
  stave.setContext(ctx).draw();

  function parseMusic(musicData) {
    return $.map(musicData.split(" "),function (note) {
      console.log(note);
      var parts = note.split(":");
      return new Vex.Flow.StaveNote({ keys: [parts[0]], duration: parts[1] });
    });
  };
  var music = $canvas.attr('data-music');
  all_notes = parseMusic(music);
  // var notes = [
  //   new Vex.Flow.StaveNote({ keys: ["f/1"], duration: "8d" }).addDotToAll(),
  //   new Vex.Flow.StaveNote({ keys: ["b/4"], duration: "16" }).
  //     addAccidental(0, new Vex.Flow.Accidental("b"))
  // ];

  // var notes2 = [
  //   new Vex.Flow.StaveNote({ keys: ["c/4"], duration: "8" }),
  //   new Vex.Flow.StaveNote({ keys: ["d/4"], duration: "16" }),
  //   new Vex.Flow.StaveNote({ keys: ["e/4"], duration: "16" }).
  //     addAccidental(0, new Vex.Flow.Accidental("b"))
  // ];

  // var notes3 = [
  //   new Vex.Flow.StaveNote({ keys: ["d/4"], duration: "16" }),
  //   new Vex.Flow.StaveNote({ keys: ["e/4"], duration: "16" }).
  //     addAccidental(0, new Vex.Flow.Accidental("#")),
  //   new Vex.Flow.StaveNote({ keys: ["g/4"], duration: "32" }),
  //   new Vex.Flow.StaveNote({ keys: ["a/4"], duration: "32" }),
  //   new Vex.Flow.StaveNote({ keys: ["g/4"], duration: "16" })
  // ];

  // var notes4 = [ new Vex.Flow.StaveNote({ keys: ["d/4"], duration: "q" }) ];

  // Create the beams
  // var beam = new Vex.Flow.Beam(notes);
  // var beam2 = new Vex.Flow.Beam(notes2);
  // var beam3 = new Vex.Flow.Beam(notes3);

  // var all_notes = notes.concat(notes2).concat(notes3).concat(notes4);

  // Helper function to justify and draw a 4/4 voice
  Vex.Flow.Formatter.FormatAndDraw(ctx, stave, all_notes);

  // Render beams
  // beam.setContext(ctx).draw();
  // beam2.setContext(ctx).draw();
  // beam3.setContext(ctx).draw();
        
  ctx.setFont("Arial", 10, "").setBackgroundFillStyle("#fff");

  // Create and draw the tablature stave
  var tabstave = new Vex.Flow.TabStave(10, 100, 500, {num_lines: 4});
  tabstave.addTabGlyph();
  tabstave.setContext(ctx).draw();

  // Create some notes
  var notes = [
    // A single note
    new Vex.Flow.TabNote({
      positions: [{str: 1, fret: 7}],
      duration: "q"}),

    // A chord with the note on the 3rd string bent
    new Vex.Flow.TabNote({
      positions: [{str: 2, fret: 10},
                  {str: 3, fret: 9}],
      duration: "q"}),

    // A single note with a harsh vibrato
    new Vex.Flow.TabNote({
      positions: [{str: 2, fret: 5}],
      duration: "h"})
  ];

  Vex.Flow.Formatter.FormatAndDraw(ctx, tabstave, notes);
});