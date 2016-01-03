Raptor 5: The Random Arpeggiator
================================

The Raptors.pd patch implements an experimental Raptor arpeggiator program
with 3 parts (i.e., 3 Raptor instances running in parallel, each with their
own set of parameters). Open the corresponding subpatch for the GUI controls
of all parameters of each part.

A few sample presets can be found in the presets folder. Use the sample
raptor-preset*.pd patches to switch between presets from the main patch.

The patch accepts MIDI note input, as well as controller and system realtime
messages for the most important controls as detailed below. The controller
assignments should be convenient to use with popular modern MIDI controllers
featuring keys, pads and rotary controllers, such as the Akai MPK mini. (Note,
however, that at present there's no MIDI controller feedback for controllers
taking MIDI input, like the BCF2000.)

## Controller Assignments

(e.g., K1-8 on Akai MPK mini)

- CC1/CC5: Harmonicity/Bias
- CC2/CC6: Preference/Bias
- CC7: Volume
- CC4/CC8: Density/Bias

Note that Harmonicity/Preference/Density and the corresponding Bias controls
apply to the part(s) set in the "Harmonicity Sweep" subpatch shown in Raptor's
main patch. The Volume controller sets the corresponding controls in all parts
and is also passed through to MIDI output.

## Switches

(PAD1-8 on Akai MPK mini in CC mode)

- CC20: Start/Stop
- CC21: Metronome
- CC22: Hold
- CC23: Preset-
- CC24: Mute 1
- CC25: Mute 2
- CC26: Mute 3
- CC27: Preset+

CC23 and CC27 work like push buttons (only react to "on" values), the others
are toggles. Note that in contrast to standard MIDI semantics, *any* value >0
means "on" here; so velocity-sensitive buttons like on customary pad
controllers should work fine.

## Other

- PC (1-5): Preset #0-#4 (Pads 1-5 on Akai MPK mini in PROG CHANGE mode)

- CC16 (0-4): Preset #0-#4 (alternative way to change presets, mainly useful
  for automation)

- CC64: Hold (keeps note input until released, usually mapped to the hold
  pedal)

- CC80: Start/Stop (alternative way to control transport state, see below)

Note that CC64 (hold) and CC80 (general purpose button #1) are interpreted
using standard MIDI button semantics, so a value >=64 means "on", <64 "off".

## Transport

Raptor's playback state can be controlled through the usual system realtime
messages start/cont/stop. This should work with most popular DAWs. (Bitwig
Studio and Reaper have been tested, YMMV.)

To synchronize Raptor with your DAW, it's usually sufficient to turn on MIDI
clock sync in the DAW and make sure that the transport messages are delivered
to Raptor (but see *Limitations/TODO* below for some caveats).

If your DAW doesn't support MIDI clock sync then you can also start/stop
Raptor explicitly through a special controller message (CC80, see above).
Use a CC80 value >= 64 to start, <64 to stop Raptor.

## OSC Support

Alternatively, Raptor can also be controlled through OSC (including parameter
feedback). A corresponding TouchOSC layout is included (Raptors.touchosc).
The main patch also includes an OSC browser subpatch which lets you detect and
connect to OSC devices on the local network (either manually or through
Zeroconf). Using Zeroconf, the Raptor patch is visible to OSC devices as
"Raptor".

Raptor supports OSC natively (if you have the requisite mrpeach externals
installed), so no MIDI bridge is needed. The Zeroconf support requires that
you have a corresponding system service running, usually Avahi on Linux, or
Bonjour on Mac OS X or Windows.

## Limitations/TODO

- The ostinato feature of Raptor 4 isn't implemented yet.

- Currently it's not possible to change tempo and timebase on the fly inside a
  measure. If Raptor is running and you change tempo, meter, division etc.,
  it will only take effect *after* the current measure. This also affects
  tempo/timebase changes initiated by changing presets.

- SPP (song position pointer) and tempo sync through MIDI clock messages
  aren't supported yet. Thus, when driving Raptor from a DAW, you have to make
  sure that both the DAW and Raptor are set to the same tempo, and that the
  DAW starts off at the beginning of a measure. Tempo and meter changes during
  playback are possible, but only at measure boundaries.
