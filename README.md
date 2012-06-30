Diato Arranger
==============

This program will take an ABC music file as input and output an arrangment of that tune for G/C diatonic accordeon (melodeon).

Installation/usage
------------------

The arranger pays attention to the chord accompaniment annotations in the ABC file. These are written in double quotes at the start of each bar or phrase, e.g.

    "C"cdeg | "D"^f2ed

See a fuller example in `test/fixtures/nue_pnues.abc`

So first you need an abc file with these annotations (most don't have them).

Second, you might want to download and install the quivra font, which is a free font containing musical symbols. Get it here:

  http://www.quivira-font.com/

Once you have a suitable ABC file, there are two ways to use it:- commandline, and simple web app.

Command line:

    bundle exec ./bin/arrange <somefile.abc>

it will send html to standard output.

The web app is just a rack app, so run it with:

    bundle exec rackup
    
At present it's hardcoded to render the `nue_pnues.abc` file from the fixtures directory.

Todo list
---------

1. ~~Pay attention to key signature~~
2. ~~Output module, generate a readable basic HTML output initially.~~
3. ~~Command line tool~~
4. Simple web app:
  - accept abc copy+pasted into form
  - on submission, generate random hash code ala piratepad, bitly etc to allow reference/editing
  - ~~show generated output (html)~~
5. If a tune can't be played in its written key, analyse and suggest a transposition which would be playable.
6. Improve the arranger with more heuristics, such as to preserve the playing direction if possible

