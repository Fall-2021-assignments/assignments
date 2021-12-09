/* Notes:

I decided to continue working on the same patch from last time.

I ended up spending most of my time working on a function to try and recreate the tape
transport speed-up and slow-down that occurs about half way into the piece.

I needed to figure out how to smoothly increase the tempo and perform a pitchbend.
I opted to do both of these on the interpreter versus the server, and came to a good thread
that provided the inspiration:
https://scsynth.org/t/newbie-what-is-the-unit-of-wait-and-can-it-be-changed/1450/7

I made a function which contains a Pbind.  It has to run on a different clock than the one it
will modify.  It uses a Pseg that ranges from 1 to some top value of a scaling factor.  These
values are incrementally read at the rate of \dur by a Pfunc, which multiplies the starting
tempo of the clock which is bundled with the musical Pdefs, along with the frequency of any
running synths introduced during that period.  Since values are updated at the rate of \dur,
it acts like the sample rate/resolution.  Decrease dur for higher resolution, increase it
for lower.  0.02 seems to work pretty well though.

Since the Pseg never runs back down to 1, the function is one directional - it will either
bend up, or down.  In order to do both, I used a Routine to call it twice.  The important
thing is both calls use the same \scale value, except the second call must be the reciprocal.
For every other argument that the function has, it should be possible to provide unique values,
eg- \bendTime, and \curve.  Having these different can add a slight humanizing touch that's
a bit more like a person using a knob to control tape playback speed...

In order to bend the frequency of all running Synths, I added a callback function to each circle's
Pdef/Pbind combo.  The callback function is able to provide all values, explicitly set and
implicitly known for each Event.  The Node ID along with the frequency for each note is stored
in a dictionary.  It is then referenced in the transport function and modified to allow for a
pitchbend.  There is also a garbage collection function that at least one of the circles needs
to have inside of the callback.  It checks which NodeIDs are stored in the dictionary against
those that are active on the server.  Inactive entries are removed.

Since the piece uses \degree and \octave to set each note's frequency, but the pitchbend works
with the highest level parameter, \freq, it was necessary to create an extra function for the
conversion.  The callback function should normally provide all these conversions on its own,
but I was not able to reliably receive it because of a few internal mechanisms in how \cln is
set up.  The function to do this conversion is initialized in the upper set up section and
called directly at the point of entering values.


To do:
I still to figure out a good way to compose the piece.  I haven't yet made my way back to
arranging all the Pdefs.  Ptpar is not specifically satisfying, but it's very straight forward.

Ultimately, I'd like to take the framework of the piece, modularize it, and swap in different
things for each module. Use the bending function to modify different parameters...
And if set up in a specific way it should be possible to use it like a lo-fi LFO.

I'm still trying to find the balance between making all functionality as modular as possible
with the understanding that since I'm writing the code, I can just add, rewrite, or "crosswire"
parts of it as I see fit when necessary...


*/


// Syv Cirkler, Else Marie Pade

// Score:
// https://issuu.com/edition-s/docs/circles_full-score_b4land_
// Recording:
// https://youtu.be/pmvmyCn4gqA


// Seven circles; each circle is a note progression spread over three octaves.
// The note progression is the same for each circle, though the register,
// and starting notes all _mostly_ rotate.
// The note progression 7 notes long: C, C#, D, Eb, E, F, Gb
// or multiples of these 7 notes.

// Each circle's notes are half as long and played twice as fast as the preceeding circle.
// Each note duration is (@ 60 bpm):
// Circle 1: 4 seconds
// Circle 2: 2 seconds
// Circle 3: 1 second
// Circle 4: 0.5 seconds
// Circle 5: 0.25 seconds
// Circle 6: 0.125 seconds
// Circle 7: 0.0625 seconds
// There is tape speed modulation at around Circle 6...

// Playback starts with Circle 1, and after one loop Circle 2 is added.
// After another loop of Circle 1, Circle 3 is then added, then 4, then 5, then 6, then 7.
// At this point all circles play at the same time.
// And then they are removed one by one, starting with 7, then 6, 5, 4, 3, 2,
// until only Circle 1 plays by itself again, and then the piece is over.

// Syv Cirkler's note progression is C, C#, D, Eb, E, F, Gb, with rotated variations
// Typically each note is a different octave,
// C-0, C#-1, D-2, Eb-0, E-1, F-2, Gb-0
// though Circle 2 and 6 are variations on the typical octave jumps

// The volume for each circle:
// Circle 1: forte
// Circle 2: forte
// Circle 3: mezzo forte
// Circle 4: mezzo forte
// Circle 5: forte
// Circle 6: mezzo forte
// Circle 7: forte


// Setup Begin

// 1-
// Pieces for Patterns
(
var degrees, octaves; // per step values, an array used in all circles
var dur, vol; // per circle values, each circle pulls one value from the array

// time, set to 60 bpm
~clock = TempoClock(1).permanent_(true);

// storage for nodeID and freq bundles to reference and later manipulate
~synth = IdentityDictionary.new;

// pitch to frequency workaround formula
~degToFreq = { |degree = 0, mtranspose = 0, scale = (Scale.major), stepsPerOctave = 12, gtranspose = 0, root = 0, octave = 5, ctranspose = 0, harmonic = 1|
	var note, midinote, freq;
	note = (degree + mtranspose).degreeToKey(scale, stepsPerOctave);
	midinote = ((note + gtranspose + root) / stepsPerOctave + octave) * 12;
	freq = (midinote + ctranspose).midicps * harmonic;
	freq
};

// create a scale specifically for this piece, for ease of using degree key in patterns
Scale.all.put(\syvCirkler, Scale((0..6)));

// note progression
degrees = (0 .. 6); // -> [ 0, 1, 2, 3, 4, 5, 6 ]

// typical octave motion; oct 0 in score == 4
octaves = (0..2).wrapExtend(7); // -> [ 0, 1, 2, 0, 1, 2, 0 ] aka -> [ 4, 5, 6, 4, 5, 6, 4 ]

// duration per step in each circle
dur = 7.geom(4, 0.5); // -> [ 4, 2.0, 1.0, 0.5, 0.25, 0.125, 0.0625 ]

// volume of each circle
vol = [0.4, 0.36, 0.22, 0.18, 0.32, 0.28, 0.2]; // f, f, mf, mf, f, mf, f

// progression: step duration, volume, notes, and octaves for each circle
~progression = { |circ = 1, octShift = 0, notes = (degrees), octs = (octaves),
	scale = (Scale.syvCirkler), durs = (dur), vols = (vol),
	clock = (TempoClock(1).permanent_(true)), octBase = 4, outputMode = 4|
	var ext, rot, steps;

	// for more natural function calling, start with "1", not 0.
	circ = circ - 1;

	// for amount of steps of each circle
	steps = notes.size;
	ext = steps * steps.geom(1, 2)[circ]; // length doubles with each internal circle

	// rotate method uses a negative value to move "forward" this is counter intuitive to me
	// this swap allows me to provide a positive value instead
	rot = circ.neg;

	// set baseline octave to range that works with Event key octave
	octs = octs + octBase;

	// use outputMode to select how data should be formatted
	switch(outputMode,
		0, { // step based-  [[dur, vol, degree, octave]..., scale, clock]
			((durs[circ] ! steps) +++ (vols[circ] ! steps) +++ notes.rotate(rot) +++ (octs.rotate(rot) + octShift)).wrapExtend(ext) ++ scale ++ clock;
		},
		1, { // interlaced note & oct steps-  [[degree, octave]...]
			(notes.rotate(rot) +++ (octs.rotate(rot) + octShift)).wrapExtend(ext);
		},
		2, { // organized note & oct steps-  [[degree...], [octave...]]
			[notes.rotate(rot), (octs.rotate(rot) + octShift)].wrapExtend(ext);
		},
		3, { // global, interlaced note & oct steps-  [dur, vol, [degree, octave]..., scale, clock]
			[durs[circ], vols[circ], (notes.rotate(rot) +++ (octs.rotate(rot) + octShift)).wrapExtend(ext), scale, clock];
		},
		4, { // global, organized note & oct steps-  [dur, vol, [degree...], [octave...], scale, clock]
			[durs[circ], vols[circ], notes.rotate(rot).wrapExtend(ext), (octs.rotate(rot) + octShift).wrapExtend(ext), scale, clock];
		}
	);
};
)


// 2-
// Set Up Each Circle
(
// [0, 1, 0, 0, 0, 1, 1].do { |item, i|
// 	i = i + 1;
// 	currentEnvironment.put(("cirk" ++ i).asSymbol, ~progression.(i, item))
// };
~cirk1 = ~progression.(1);
~cirk2 = ~progression.(2, 1);
~cirk3 = ~progression.(3);
~cirk4 = ~progression.(4);
~cirk5 = ~progression.(5); // verify this, as score has subtle differences
~cirk6 = ~progression.(6, 1);
~cirk7 = ~progression.(7, 2); // this may actually need either octave jump, or double time
)


// 3-
// Pattern Factory Stylee
(
// generate Pbind archetype
var bind = { |deg, oct, dur, amp, scale, snd = \sin|
	Pbind(*[
		type: \cln,
		snd: snd,
		tri: 0.15,

		scale: scale,
		degree: Pseq(deg),
		octave: Pseq(oct),

		dur: dur,
		amp: amp,

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,

		// maybe worth using argument to flag whether to include this or not-- since it's only nec in 1 of the Pbinds...
		cav: 0.3,
		cvt: 0.3,
		cvd: 0.8,
		cvl: 0.6,

		callback: { |ev|
			// ev.postln;

			// store nodeID & freq of the Synth created from this Event
			~synth.put(ev[\synthGroup], ~degToFreq.(degree: ev[\degree], octave: ev[\octave]));
			// ~synth.put(ev[\synthGroup], ev[\freq]);

			// garbage collection: query the active group where Synths are spawned
			// and remove reference of Synths which no longer exist from the dictionary
			// reference to Node Group where all Synths are spawned. 2 == ~clean.aux[0]
			2.asGroup.query { |...info| // returns array: [0] serverCmd, [1] nodeID, [2] parent, [3] prev, [4] next, [5] isGroup, [6] head, [7] tail
				// here, head is the "oldest" running synth. tail is the newest
				// info.postln;
				// remove all entries which are older than the oldest running synth
				~synth.keys.reject { |i| i >= info[7] }.do { |j| ~synth.removeAt(j) }
			};
		}.inEnvir,
	]);

};

// generate all Pdefs, nesting Pbind with valid settings, using iteration
(1 .. 7).do { |i|
	// simple way to step through sequential variables
	// currentEnvironment[\cirk1] === ~cirk1
	var cirk = currentEnvironment[("cirk" ++ i).asSymbol];
	// [dur, vol, [degree...], [octave...], scale, clock]
	Pdef(i, bind.(cirk[2], cirk[3], cirk[0], cirk[1], cirk[4]))
};
)


// 4-
// Bend Functionality
(
var updatedSynth = IdentityDictionary.new;
var elapsedTime = 0, remainingTime = 0;
var timeBend;

timeBend = { |bendTime = 10, scale = 2, growthStage = 2, curve = \lin resolution = 0.02, startTempo = (~clock.tempo)|
	var scaleAmount = growthStage.geom(1, scale).last;
	var bentFreq;

	// use pattern running on default clock to update clock my pattern is running on & change pitch accordingly
	Pbind(*[
		grow: Pseg([1, scaleAmount], bendTime, curve),

		update: Pfunc { |ev|
			// update tempo
			~clock.tempo = ev[\grow] * startTempo;

			// update pitch
			~synth.pairsDo { |node, freq, i|
				bentFreq = freq * ev[\grow];
				node.asGroup.set(\freq, bentFreq);

				// update storage
				updatedSynth.put(node, bentFreq)
			}
		},

		type: \rest,
		dur: resolution, // update resolution
	]).play
};

~transportControl = { |bendTime = 10, scale = 2, growthStage = 2, curve = \lin, resolution = 0.02, currentTempo = ({ ~clock.tempo })|
	Routine {
		// currentTempo contains a function, which must be evaluated.
		// this allows for the tempo to update correctly in between bending up and down

		// bend one way
		timeBend.(bendTime, scale, growthStage, curve, resolution, currentTempo.value);

		bendTime.wait;
		~synth = updatedSynth.copy;
		updatedSynth.clear;

		// add functionality so that all new synths created in this period are freq * scale
		// eg - if tempo doubles, and stays that way, all synths created should be an octave higher

		// bend back
		timeBend.(bendTime, scale.reciprocal, growthStage, curve, resolution, currentTempo.value);

		~synth = updatedSynth.copy;
	}.play
}
)


// End setup




// Playback
// explore removing Ptpar and using a Routine or Tdef to deal with .play-ing Pdefs.
(
Ptpar([
	0, Pn(Pdef(1), 13),
	~cirk1[0] * ~cirk1[2].size, Pn(Pdef(2), 11 * 2),
	~cirk1[0] * ~cirk1[2].size * 2, Pn(Pdef(3), 9 * 4),
	~cirk1[0] * ~cirk1[2].size * 3, Pn(Pdef(4), 7 * 8),
	~cirk1[0] * ~cirk1[2].size * 4, Pn(Pdef(5), 5 * 16),
	~cirk1[0] * ~cirk1[2].size * 5, Pn(Pdef(6), 3 * 32),
	~cirk1[0] * ~cirk1[2].size * 6, Pn(Pdef(7), 1 * 64)
]).play(~clock)
)

// bend it!
// bendTime, scale factor, recursive scale times, env curve
~transportControl.(10, 2, 2, \sin)

// rudimentary ffw
~clock.tempo = 8
~clock.tempo = 1



// Testing

// testing to verify correct amount of steps per circle
~cirk1[2].size; // 7 * 1
~cirk2[2].size; // 7 * 2
~cirk3[2].size; // 7 * 4
~cirk4[2].size; // 7 * 8
~cirk5[2].size; // 7 * 16
~cirk6[2].size; // 7 * 32
~cirk7[2].size; // 7 * 64

// amountSteps * dur = total duration of each circle
~cirk1[2].size * ~cirk1[0]; // 28
~cirk2[2].size * ~cirk2[0]; // 28
~cirk3[2].size * ~cirk3[0]; // 28
~cirk4[2].size * ~cirk4[0]; // 28
~cirk5[2].size * ~cirk5[0]; // 28
~cirk6[2].size * ~cirk6[0]; // 28
~cirk7[2].size * ~cirk7[0]; // 28

// test that pattern factory worked
Pdef(1).play(~clock, quant: 1);
Pdef(2).play(~clock, quant: 1);
Pdef(3).play(~clock, quant: 1);
Pdef(4).play(~clock, quant: 1);
Pdef(5).play(~clock, quant: 1);
Pdef(6).play(~clock, quant: 1);
Pdef(7).play(~clock, quant: 1);

Pdef(1).stop;
Pdef(2).stop;
Pdef(3).stop;
Pdef(4).stop;
Pdef(5).stop;
Pdef(6).stop;
Pdef(7).stop;

// check nodeID for all running notes (while running)
~synth.keysDo { |key| key.postln };

// check nodeID and freq for all running notes (while running)
~synths.pairsDo { |node, freq| [node, freq].postln };

~synth




// Test Rig for Bend
(
Pdef(11,
	Pbind(*[
		type: \cln,
		snd: Pwrand2([\sin, \saw], [10, 1], inf),

		iph: Plprand(0.0, 1.0),
		wid: Pmeanrand(0.4, 0.6),

		atk: Plprand(0.01, 0.11),
		rel: Prand([7, 4, 9], inf),
		tsc: Pwhite(3, 7),

		amp: Pmeanrand(0.2, 0.6),
		pan: Pbrown(0.15, 0.85, Pmeanrand(0.005, 0.075)),


		// freq: Pxrand((100 .. 1000), inf).round(47),
		degree: Pxrand((0 .. 12), inf) + Pmeanrand(0.0, 1.0),
		octave: Pxrand((2 .. 7), inf),

		sustain: Pmeanrand(7, 13),
		dur: Pseq([2.0, Pxrand([2.0, 1.5, 0.75, 0.5], 2)], inf),

		callback: { |ev|
			// ev.postln;

			// store nodeID & freq of the Synth created from this Event
			~synth.put(ev[\synthGroup], ~degToFreq.(degree: ev[\degree], octave: ev[\octave]));
			// ~synth.put(ev[\synthGroup], ev[\freq]);

			// garbage collection: query the active group where Synths are spawned
			// and remove reference of Synths which no longer exist from the dictionary

			// reference to Node Group where all Synths are spawned. 2 == ~clean.aux[0]
			2.asGroup.query { |...info| // returns array: [0] serverCmd, [1] nodeID, [2] parent, [3] prev, [4] next, [5] isGroup, [6] head, [7] tail
				// here, head is the "oldest" running synth. tail is the newest
				// info.postln;
				// remove all entries which are older than the oldest running synth
				~synth.keys.reject { |i| i >= info[7] }.do { |j| ~synth.removeAt(j) }
			};
		}.inEnvir,
	])
)
)
Pdef(11).play(~clock)
// bendTime, scale factor, recursive scale times, env curve
~transportControl.(3, 0.5, 2, \wel)
~transportControl.(10, 2, 2, \sin)
Pdef(11).stop

// check tempo
~clock.tempo



// Different Notes & Scales
(
var octShift = [0, 1, 0, 1, 0, 1, 2];
var notes = [0, 3, 7, 1, 6, 0, 2];
var octaves = [0].wrapExtend(7);
var scale = Scale.pelog;
var bind;

// circle, octaveShift, notes, octaves, scale, dur, vol, (clock), baseOctave, outputMode
[0, 1, 0, 1, 0, 1, 2].do { |octShift, i|
	i = i + 1;
	currentEnvironment.put(("cirk" ++ i).asSymbol, ~progression.(i, octShift, notes, octaves, scale))
};

// generate Pbind archetype
bind = { |deg, oct, dur, amp, scale, snd = \sin|
	Pbind(*[
		type: \cln,
		snd: snd,
		tri: 0.15,

		pan: Pbrown(0.4, 0.6, Pmeanrand(0.0025, 0.035)),

		scale: scale,
		degree: Pseq(deg, inf),
		octave: Pseq(oct, inf),

		dur: dur,
		amp: amp,

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,

		// maybe worth using argument to flag whether to include this or not-- since it's only nec in 1 of the Pbinds...
		cav: 0.3,
		cvt: 0.3,
		cvd: 0.8,
		cvl: 0.6,

		callback: { |ev|
			// ev.postln;

			// store nodeID & freq of the Synth created from this Event
			~synth.put(ev[\synthGroup], ~degToFreq.(degree: ev[\degree], octave: ev[\octave]));
			// ~synth.put(ev[\synthGroup], ev[\freq]);

			// garbage collection: query the active group where Synths are spawned
			// and remove reference of Synths which no longer exist from the dictionary
			// reference to Node Group where all Synths are spawned. 2 == ~clean.aux[0]
			2.asGroup.query { |...info| // returns array: [0] serverCmd, [1] nodeID, [2] parent, [3] prev, [4] next, [5] isGroup, [6] head, [7] tail
				// here, head is the "oldest" running synth. tail is the newest
				// info.postln;
				// remove all entries which are older than the oldest running synth
				~synth.keys.reject { |i| i >= info[7] }.do { |j| ~synth.removeAt(j) }
			};
		}.inEnvir,
	]);

};

// generate all Pdefs, nesting Pbind with valid settings, using iteration
(1 .. 7).do { |i|
	// simple way to step through sequential variables
	// currentEnvironment[\cirk1] === ~cirk1
	var cirk = currentEnvironment[("cirk" ++ i).asSymbol];
	// [dur, vol, [degree...], [octave...], scale, clock]
	Pdef(i, bind.(cirk[2], cirk[3], cirk[0], cirk[1], cirk[4]))
};
)

(1 .. 7).do { |i| Pdef(i).play(~clock, quant: 1) }

~transportControl.(3, 0.5, 2, \wel)
