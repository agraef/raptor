Raptor 5: The Random Arpeggiator
================================

Albert Gräf <aggraef@gmail.com>  
Computer Music Research Group  
Johannes Gutenberg University (JGU) Mainz, Germany

The Raptors.pd patch implements an experimental algorithmic composition
arpeggiator program with 3 parts (i.e., 3 Raptor instances running in
parallel, each with their own set of parameters). Open the corresponding
subpatch for the GUI controls of all parameters of each part.

A few sample presets can be found in the presets folder. Use the sample
raptor-preset.pd patch to switch between presets from the main patch. This
subpatch also has some controls to change meter and tempo.

The patch accepts MIDI note input, as well as controller and system realtime
messages for the most important controls as detailed below. The controller
assignments should be convenient to use with popular modern MIDI controllers
featuring keys, pads and rotary controllers, such as the Akai MPK mini, or
more "classic" equipment like the Behringer FCB 1010 controller. (Note,
however, that at present there's no MIDI controller feedback for controllers
taking MIDI input, like the Behringer BCF2000.)

The actual algorithmic core of Raptor is implemented as a Pd external written
in Pure, see the raptor.pure program. Thus in addition to Miller Puckette's Pd
you'll also need the author's Pure plugin loader for Pd (pd-pure) to run it.
Any recent version and flavour of Pd will do; see <http://puredata.info/>. The
author's Pure programming language and the pd-pure plugin loader can be found
at <https://agraef.github.io/pure-lang/>. We also provide ready-made packages of
pd-pure for Linux (Arch, Ubuntu and derivatives) and macOS (via [MacPorts][]),
please refer to the link above for details. Mac users may also want to check
the [Pure on Mac OS X][] wiki page for detailed instructions.

[MacPorts]: http://www.macports.org/
[Pure on Mac OS X]: https://github.com/agraef/pure-lang/wiki/PureOnMacOSX

## Copying

Copyright (c) 2005-2018 by Albert Gräf.

Raptor is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

Raptor is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>.

## Changing Presets, Tempo and Meter

The main Raptors patch has a raptor-preset subpatch offering controls to
change presets, meter and tempo in a convenient fashion.

The preset-changing control is the radio button strip in the right upper
corner of the subpatch. Simply click on one of the radio buttons to change the
preset. This will affect all three parts. Note that currently the preset names
for the different parts are hard-wired, so in order to change these you'll
have to open the subpatch and edit the patch accordingly. Also note that once
the patch has been loaded, switching presets will *not* affect the tempo and
meter any more, so that these can be changed freely with the corresponding
controls, see below. To force tempo and meter settings to be loaded from a
preset, click the red button in the lower right corner of the subpatch and
then choose the presets you want to load by clicking on the corresponding
radio button as usual.

The tempo (in BPM a.k.a. beats per minute) can be changed using the slider or
the number entry widget in the bottom row of the subpatch. By default, in
tempo calculations a "beat" is taken to mean a quarter note. The actual
frequency of base pulses in the chosen meter is then $m/4$ times the BPM
value, where $m$ is the denominator of the meter (see below).

The meter can be changed with the three strips of radio buttons in the middle
of the subpatch. The *green* strip changes the numerator, the *red* strip the
denominator of the meter. In addition, the white strip allows you to change
the number of subdivisions of the meter's base pulse in order to play tuplets
(subdivisions in the range from 1 to 7 can be entered using the radio buttons).

The meter is displayed in the symbol entry widget above the white strip of
radio buttons, and can also be entered directly there. The format used by
Raptor allows you to specify the meter using the customary $n/m$ notation
where $n$ denotes the numerator (the number of base pulses making up a
measure) and $m$ the denominator of the meter. The latter is usually a power
of 2, but Raptor allows you to use any positive integer there which is useful
when tuplets are the base pulse of the meter. Moreover, the numerator $n$ can
also be specified in *stratified* form by explicitly listing the decomposition
of the meter into different levels separated by dashes. E.g., 12/16 can also
be specified as 4-3/16 or 2-2-3/16. Or you could write 6-2/16 or 2-3-2/16 to
denote a 6/8 meter subdivided into 16th notes. Likewise, a 6/8 meter
subdivided into triplets would be specified as 18/24, 6-3/24 or 2-3-3/24.

The default meter is 4/4 (common time) a.k.a. 2-2/4. If you don't specify a
stratified meter, Raptor does the stratification internally anyway, by
decomposing the numerator into its prime factors in ascending order. Finally,
if the denominator $m$ is omitted, Raptor chooses the power of 2 which is
nearest to the numerator as a reasonable default, so that in most cases you
can also just specify the (unstratified or stratified) numerator of the
meter. E.g., 2 becomes 2/2, 3 becomes 3/4, 9 becomes 3-3/8, 12 becomes
2-2-3/16, 2-3-2 becomes 2-3-2/16, etc.

Note that the raptor-preset patch always changes tempo and meter for all
Raptor parts simultaneously. However, it is also possible to change meter and
tempo (and even the definition of a "beat") by changing the corresponding
values in each individual Raptor part. This complicates things, but makes it
possible to produce polyrhythms in Raptor.

Also note that in the present implementation changing tempo and meter only
takes effect at measure boundaries, so at present it is *not* possible to
change tempo and meter at some arbitrary point inside a measure. This is a
very fundamental limitation of Raptor's design, so don't expect this to change
anytime soon. However, it is usually possible to work around this limitation
by using shorter measures with the appropriate meter and tempo changes. (This
can become difficult to control in real-time, though, so you'll want to use
DAW as time master to automatize the meter and tempo changes in such cases.)

## Editing Presets

You can click the Edit button in each of the three Raptor parts to open the
corresponding subpatch, which will give you a bunch of additional control
parameters which can be changed to affect Raptor's operation. (A more detailed
description of the parameters is beyond the scope of this document, so we
refer the reader to the raptor.pure script instead.)

Once you have changed the parameters to your liking, you can close the
subpatch and click the Save button to write your changes to the corresponding
preset file. You can also use the SaveAs button if you want to save the
settings in a new preset file instead, or use the Load button to load a
different preset file.

## Controller Assignments

(e.g., K1-8 on Akai MPK mini)

- CC1/CC5: Harmonicity/Bias
- CC2/CC6: Preference/Bias
- CC7: Volume
- CC4/CC8: Density/Bias

Note that Harmonicity/Preference/Density and the corresponding Bias controls
apply to the *active* part(s) set in the "Harmonicity Sweep" subpatch shown in
Raptor's main patch. The Volume controller sets the corresponding controls in
all parts and is also passed through to MIDI output. Also note that all these
controls are reset when switching presets (see below).

**FCB 1010 users:** The FCB 1010 has its *right* continuous controller pedal
assigned to CC7 by default and can thus be used to control the Volume setting
of all Raptor parts. You may want change this to match your preferences and
playing style.  E.g., I have the FCB's left and right continuous controller
pedals (CC27 and CC7) assigned to CC1 and CC2, respectively, so that I can
control both the Harmonicity and Preference parameters of the active part(s)
while playing. The controls can be remapped most conveniently by using some
appropriate MIDI plugin inside a DAW (like pizmidi's midiConverter3), or a
stand-alone MIDI filter/mapping software (like qmidiroute on Linux, MidiPipe
on the Mac,or MidiOx on Windows).

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
controllers should work fine. A suitable Akai MPK mini II configuration
is included (Raptors.mk2). 

**FCB 1010 users:** The FCB 1010 has its *left* continuous controller pedal
assigned to CC27 by default, which will wreak havoc with Raptor's preset
setting when you operate this controller. Thus you'll want to to reassign the
pedal to a different CC number (such as CC1, see above).

## Program Changes

The presets #0-#4 can also be accessed directly through program changes (PC)
1-5, which correspond to Pads 1-5 on Akai MPK mini in PROG CHANGE mode, and to
foot switches 1-5 on a Behringer FCB 1010 foot controller.

PC changes will be taken modulo 5, i.e., they wrap around after PC 5, so they
will also work with the higher banks on the FCB 1010. To make this more
useful, Raptor actually implements four "sets" with different variations of the
presets, which are identical to the original presets #0-#4 but with some parts
muted, as follows:

- Set #0 (PC 1-5): all parts playing
- Set #1 (PC 6-10): lead part ("piano") muted
- Set #2 (PC 11-15): upper part ("guitar") muted
- Set #3 (PC 16-20): lead and upper part muted ("bass" solo)
- Set #4 (PC 21-25): all parts muted (no output from Raptor)

Again, these wrap around after set #4, so that higher banks of the FCB 1010
(second row of FCB bank 02 and beyond) will simply cycle through Raptor
sets #0-#4. Note that all this assumes the FCB 1010 default setup which has PC
1-10 mapped out over its ten banks accessible with the Up/Down pedals.

## Other

- CC16 (0-4): Preset #0-#4 (alternative way to change presets, mainly useful
  for automation)

- CC64: Hold (keeps note input until released, usually mapped to the hold
  pedal)

- CC80: Start/Stop (alternative way to control transport state, see below)

Note that CC64 (hold) and CC80 (general purpose button #1) are interpreted
using standard MIDI button semantics, so a value >=64 means "on", <64 "off".

Also note that all these settings are just examples tailored to the external
MIDI gear and software applications that I use; you can customize these to
your heart's content (have a look at the midi-in subpatch of the controls
subpatch in the Raptors main patch).

## Transport

Raptor's playback state can be controlled through the usual system realtime
messages start/cont/stop. This should work with most popular DAWs. (Bitwig
Studio and Reaper have been tested. Tracktion's system realtime implementation
seems to be broken, so you'll have to use the CC80 workaround described
below. YMMV, though.)

To synchronize Raptor with your DAW, it's usually sufficient to turn on MIDI
clock sync in the DAW and make sure that the transport messages are delivered
to Raptor (but see *Limitations/TODO* below for some caveats).

If your DAW doesn't support MIDI clock sync then you can also start/stop
Raptor explicitly through a special controller message (CC80, see above).
Use a CC80 value >= 64 to start, <64 to stop Raptor.

## OSC Support

Alternatively, Raptor can also be controlled through OSC (including parameter
feedback). This is bidirectional, so Raptor will feed control data back to the
connected OSC device(s). A corresponding TouchOSC layout is included
(Raptors.touchosc). The main patch also includes an OSC browser subpatch
which lets you detect and connect to OSC devices on the local network (either
manually or through Zeroconf). Using Zeroconf, the Raptor patch is visible to
OSC devices as "Raptor".

Raptor supports OSC natively (if you have the requisite mrpeach externals
installed), so no MIDI bridge is needed. The Zeroconf support requires that
you have a corresponding system service running, usually Avahi on Linux, or
Bonjour on Mac OS X or Windows. Also note that in order to make OSC
communication work, your local network must have the OSC UDP input and output
ports open, so you might have to configure the firewall on your local router
accordingly.

For convenience, Raptor always connects to OSC (on the local UDP port given as
the argument of the oscbrowser abstraction) and starts browsing for possible
OSC clients during startup (i.e., patch load time). The default input port is
8000 which matches TouchOSC's default. If this interferes with other OSC
receiving software (such as OSCulator on the Mac) then you may want to change
the argument of oscbrowser to a different port number and reconfigure your OSC
devices accordingly.

Also, oscbrowser will auto-connect to the first available OSC client on the
local network as soon as it finds one. If this isn't desired then you can turn
oscbrowser off and disconnect it by clicking the corresponding message in the
main patch. You can also use oscbrowser's next and prev controls to cycle
through the list of all known OSC clients, or enter an IP address and port
number and then push the conn button to connect Raptor to the given client.
Finally, by clicking the "connect 255.255.255.255" message in the main window
you can have Raptor broadcast outgoing OSC messages to the local network, so
that any connected OSC client receives them. This is useful if you're running
multiple OSC devices on the same network. (You can adjust the outgoing port
number in the message as needed. The default is 9000 which matches TouchOSC's
default.)

## Metronome

Raptor optionally outputs a kind of metronome click in the chosen tempo and
meter, if you specify the number of clicks to emit per measure in the
metronome field of one of the parts (the sample presets all have this setting
in the upper part). In the future we may turn this facility into a separate
Raptor part providing a full-blown automatic drum sequencer, but for the time
being the metronome is there mostly for the traditional purpose: to help you
keep the right tempo and rhythm while you play.

The metronome always outputs MIDI note 37 (Side Stick) with varying velocities
on MIDI channel 10 (the drum channel on GM devices) while Raptor is running,
no matter whether the emitting part is currently muted or not. The velocities
of the notes are set from Raptor's internal pulse strengths computed from the
chosen meter, which are also used to determine the most prominent pulses at
which the clicks should occur. All this happens automatically. To quickly
toggle the metronome click you can use one of the available controls (CC21 or
function key F4 in Raptor's main window). To completely suppress the metronome
clicks just filter out MIDI channel 10 in your DAW, or reset the metronome
value to zero in the presets that you use.

## Limitations/TODO

- The ostinato feature of Raptor 4 isn't implemented yet. Did this ever work?
  I don't remember. ;-)

- At present you have to change the raptor-preset subpatch in the main Raptor
  patch to switch between different "banks" (preset collections). This really
  needs to be replaced with a more generic system which allows switching
  between banks more easily (maybe also through a MIDI controller).

- The meter and tempo controls in the raptor-preset subpatch need to be
  documented. Also, a MIDI mapping for these controls should be added so that
  it becomes easier to change these parameters on the fly.

- Currently it's not possible to change tempo and timebase inside a measure.
  If Raptor is running and you change tempo, meter, division etc., it will
  only take effect *after* the current measure. This also affects
  tempo/timebase changes initiated by changing presets.

- SPP (song position pointer) and tempo sync through MIDI clock messages
  aren't supported. Thus, when driving Raptor from a DAW, you have to make
  sure that both the DAW and Raptor are set to the same tempo, and that the
  DAW starts off at the beginning of a measure. Tempo and meter changes during
  playback are possible, but only at measure boundaries. (For the time being,
  it is probably easiest to just keep to a single tempo, use a DAW to record
  your performance including the accompaniment generated by Raptor, and then
  use the DAW's facilities to adjust the tempo for certain sections of the
  performance.)

- Adding support for Jack transport would make it possible to synchronize
  Raptor's playback, meter and tempo with DAWs like Ardour. This should be
  possible using the author's pd-jacktime external, but hasn't been
  implemented yet.
