import { Factory } from 'vexflow';

// Initialize the renderer
function initRenderer() {
  const factory = new Factory.Renderer(400, 400);
  const context = factory.getContext();
  const stave = new Factory.Stave(10, 0, 380);

  // Add a treble clef
  stave.addClef("treble");
  stave.setContext(context).draw();

  return { factory, context, stave };
}

// Parse music data into VexFlow notes
function parseMusic(musicData) {
  return musicData.split(" ").map(note => {
    const [key, duration] = note.split(":");
    return new Factory.StaveNote({ 
      keys: [key], 
      duration: duration 
    });
  });
}

// Render the music
function renderMusic(musicData) {
  const { context, stave } = initRenderer();
  const notes = parseMusic(musicData);
  Factory.Formatter.FormatAndDraw(context, stave, notes);
}

// Initial render
const musicData = "f/5:8d f/5:8d e/5:4d e/5:4d e/5:4d e/5:4d e/5:4d";
renderMusic(musicData);

// Hot Module Replacement (HMR) - Remove this in production
if (import.meta.hot) {
  import.meta.hot.accept((newModule) => {
    // Clear the canvas
    const canvas = document.querySelector('#music');
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // Re-render
    renderMusic(musicData);
  });
} 