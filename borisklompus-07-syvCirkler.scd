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


// Setup
(
// create a scale specifically for this piece, for ease of using degree key in patterns
Scale.all.put(\syvCirkler, Scale((0..6)));

// notes (can also be (0 .. 6))
n = Scale.syvCirkler.degrees; // -> [ 0, 1, 2, 3, 4, 5, 6 ]

// typical octave motion; oct 0 in score == 4
o = (0..2).wrapExtend(7); // -> [ 4, 5, 6, 4, 5, 6, 4 ] aka -> [ 0, 1, 2, 0, 1, 2, 0 ]

// duration per step in each circle
d = 7.geom(4, 0.5); // -> [ 4, 2.0, 1.0, 0.5, 0.25, 0.125, 0.0625 ]

// volume of each circle
v = [0.4, 0.4, 0.3, 0.3, 0.4, 0.3, 0.4];

// progression: step duration, volume, notes, and octaves for each circle
p = { |circ = 1, octShift = 0, octBase = 4|
	var ext, rot, steps, octs;

	// for more natural function calling, start with "1", not 0.
	circ = circ - 1;

	// for amount of steps of each circle
	steps = n.size;
	ext = steps * steps.geom(1, 2)[circ]; // length doubles with each internal circle

	// rotate method uses a negative value to move "forward" this is counter intuitive to me
	// this swap allows me to provide a positive value instead
	rot = circ.neg;

	// set baseline octave to range that works with Event key octave
	octs = o + octBase;

	// step based-  [[dur, vol, degree, octave]...]
	// ((d[circ] ! steps) +++ (v[circ] ! steps) +++ n.rotate(rot) +++ (octs.rotate(rot) + octShift)).wrapExtend(ext);
	// interlaced note & oct steps-  [[degree, octave]...]
	// (n.rotate(rot) +++ (octs.rotate(rot) + octShift)).wrapExtend(ext);
	// organized note & oct steps-  [[degree...], [octave...]]
	// [n.rotate(rot), (octs.rotate(rot) + octShift)].wrapExtend(ext);

	// global, interlaced note & oct steps-  [dur, vol, [degree, octave]...]
	// [d[circ], v[circ], (n.rotate(rot) +++ (octs.rotate(rot) + octShift)).wrapExtend(ext)];

	// global, organized note & oct steps-  [dur, vol, [degree...], [octave...]]
	[d[circ], v[circ], n.rotate(rot).wrapExtend(ext), (octs.rotate(rot) + octShift).wrapExtend(ext)];
};

// clock, set to 60 bpm
c = TempoClock(1).permanent_(true);

// set up each circle
~cirk1 = p.(1);
~cirk2 = p.(2, 1);
~cirk3 = p.(3); // ~cirk3 = p.(3, 2);
~cirk4 = p.(4); // ~cirk4 = p.(4, 3);
~cirk5 = p.(5); // verify this, as score has subtle differences // ~cirk5 = p.(5, 4);
~cirk6 = p.(6, 1); // ~cirk6 = p.(6, 5);
~cirk7 = p.(7, 1); // this may actually need either octave jump, or double time // ~cirk7 = p.(7, 6);
)


// Patterns
(
Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: Scale.syvCirkler,
		degree: Pseq(~cirk1[2]),
		octave: Pseq(~cirk1[3]),

		dur: ~cirk1[0],
		amp: ~cirk1[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,

		cav: 0.3,
		cvt: 0.3,
		cvd: 0.8,
		cvl: 0.6,
	])
);

Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: Scale.syvCirkler,
		degree: Pseq(~cirk2[2]),
		octave: Pseq(~cirk2[3]),

		dur: ~cirk2[0],
		amp: ~cirk2[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: Scale.syvCirkler,
		degree: Pseq(~cirk3[2]),
		octave: Pseq(~cirk3[3]),

		dur: ~cirk3[0],
		amp: ~cirk3[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(4,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: Scale.syvCirkler,
		degree: Pseq(~cirk4[2]),
		octave: Pseq(~cirk4[3]),

		dur: ~cirk4[0],
		amp: ~cirk4[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(5,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: Scale.syvCirkler,
		degree: Pseq(~cirk5[2]),
		octave: Pseq(~cirk5[3]),

		dur: ~cirk5[0],
		amp: ~cirk5[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(6,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: Scale.syvCirkler,
		degree: Pseq(~cirk6[2]),
		octave: Pseq(~cirk6[3]),

		dur: ~cirk6[0],
		amp: ~cirk6[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(7,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: Scale.syvCirkler,
		degree: Pseq(~cirk7[2]),
		octave: Pseq(~cirk7[3]),

		dur: ~cirk7[0],
		amp: ~cirk7[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);
)


// Playback
// ... gain staging isn't correct
// and that nice tempo/pitch modulation from the middle isn't working, so Pdef(6) and Pdef(7) are a bit jarring, and different
// Explore removing Ptpar and using a Routine or Tdef to deal with .play-ing Pdefs. That way .set([detune: x]) can be used to modify pitch
// as tempo changes (unverified).
(
Ptpar([
	0, Pn(Pdef(1), 13),
	~cirk1[0] * ~cirk1[2].size, Pn(Pdef(2), 11 * 2),
	~cirk1[0] * ~cirk1[2].size * 2, Pn(Pdef(3), 9 * 4),
	~cirk1[0] * ~cirk1[2].size * 3, Pn(Pdef(4), 7 * 8),
	~cirk1[0] * ~cirk1[2].size * 4, Pn(Pdef(5), 5 * 16),
	~cirk1[0] * ~cirk1[2].size * 5, Pn(Pdef(6), 3 * 32),
	~cirk1[0] * ~cirk1[2].size * 6, Pn(Pdef(7), 1 * 64)
]).play(c)
)

c.tempo = 1 // ffwd










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










// Early stages --
// Alternate Function Version:
// Making things more modular to use the piece as a framework, not a cover.
// Argument presets are set up for identical as original function above,
// but it is also possible to override all these settings.
(

// create a scale specifically for this piece, for ease of using degree key in patterns:
Scale.all.put(\syvCirkler, Scale((0..6)));

c = TempoClock(1).permanent_(true);

// progression: step duration, volume, notes, and octaves for each circle, along with ability to set unique scales and clocks
p = { |circ = 1, octShift = 0, octBase = 4, notes = (Scale.syvCirkler.degrees), octs = ((0..2).wrapExtend(7)),
	durs = (7.geom(4, 0.5)), vols = #[0.5, 0.5, 0.2, 0.2, 0.5, 0.2, 0.5], scale = (Scale.syvCirkler),
	clock = (TempoClock(1).permanent_(true)), outputMode = 4|
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
p.value(outputMode: 3)

(
(
Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: ~cirk1[4],
		degree: Pseq(~cirk1[2]),
		octave: Pseq(~cirk1[3]),

		dur: ~cirk1[0],
		amp: ~cirk1[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,

		cav: 0.3,
		cvt: 0.3,
		cvd: 0.8,
		cvl: 0.6,
	])
);

Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: ~cirk2[4],
		degree: Pseq(~cirk2[2]),
		octave: Pseq(~cirk2[3]),

		dur: ~cirk2[0],
		amp: ~cirk2[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: ~cirk3[4],
		degree: Pseq(~cirk3[2]),
		octave: Pseq(~cirk3[3]),

		dur: ~cirk3[0],
		amp: ~cirk3[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(4,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: ~cirk4[4],
		degree: Pseq(~cirk4[2]),
		octave: Pseq(~cirk4[3]),

		dur: ~cirk4[0],
		amp: ~cirk4[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(5,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: ~cirk5[4],
		degree: Pseq(~cirk5[2]),
		octave: Pseq(~cirk5[3]),

		dur: ~cirk5[0],
		amp: ~cirk5[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(6,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: ~cirk6[4],
		degree: Pseq(~cirk6[2]),
		octave: Pseq(~cirk6[3]),

		dur: ~cirk6[0],
		amp: ~cirk6[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);

Pdef(7,
	Pbind(*[
		type: \cln,
		snd: \sin,
		tri: 0.15,

		scale: ~cirk7[4],
		degree: Pseq(~cirk7[2]),
		octave: Pseq(~cirk7[3]),

		dur: ~cirk7[0],
		amp: ~cirk7[1],

		cai: Pkey(\amp),

		atk: Pkey(\dur) * 0.0125,
		rel: Pkey(\dur),
		crv: 2,
		sustain: Pkey(\dur) * 1.5,
	])
);
)
