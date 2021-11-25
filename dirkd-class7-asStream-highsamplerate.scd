/* assignment from november 11th
dirk dullmaier

goals:
1. super high samplerate pitch down action
2. "fading" between samples?
3. some interconnectedness with env-vars and streamed Pobjects

WORK IN WORK
--i guess this is a still an early alpha of what i wanted to make,
but time was not on my side--

4 samples, 2x analog vco, 2x shakuhachi recorded at 192khz

https://github.com/dormirj/samples/tree/main/asstream_highsamplerate_11nov

(i wanted to use longer samples, but github wanted them to be smaller
than 25mb and i havent thought about where to put them)

crossfading slowly at the beginning, somehow with a shared variable for "where"
in the field between those sources we are,

starts off slowly fading them slowly into each other,
slowing them down and then accelerating

currently i've not managed to also make ~segments and ~speed into shifting
pattern objects, because then i get a bunch of errors
"non boolean in test" -- need to find out whats going on there...

also still have some popping, not sure if its clipping or some unclean
starting and stopping of the segments, need to investigate further
*/
(
//
// ~locx = 0.9;
// ~locy = 0.5;
~locx = Pseg([0, 1, 0], [50, 150], \sin, 1).asStream;
~locy = Pseg([1, 0, 1], [150, 50], \wel, 1).asStream;
// ~segments = Pseg([2, 20, 1000, 2], [120, 70, 10], \lin, 1).asStream;
~segments = 100;
// ~speed = Pseg([0.9, 1.0, 0.1, 2.0], [80, 40, 120], \lin, 1).asStream;
~speed = 1;

Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \asstream_highsamplerate_11nov,
		segments: Pfunc{~segments},
		num: 0,
		lop: 1,
		speed: Pfunc{~speed},
		length: Pfunc { arg event; ~clean.buffers[\asstream_highsamplerate_11nov][event.num].numFrames / ~clean.buffers[\asstream_highsamplerate_11nov][event.num].sampleRate } / Pkey(\speed),
		single: Pkey(\length) / Pkey(\segments),
		atk: 1.4 + Plprand(2.0, 3.0),
		rel: Pkey(\atk) + Plprand(1.0, 3.0),
		bgn: Pxshuf((0.01, 0.02 .. 0.99), inf),
		dur: Pkey(\single),
		legato: Pkey(\dur) * 10,
		// spd: Pkey(\speed) + Pwhite(-0.01, 0.001),
		spd: Pfunc{~speed} * Pseg([0.9, 1.0, 0.1, 6.3], [50, 130, 20], \lin, 1),
		amp: 0.09 * (1.4142135623731 - Pfunc{ sqrt((squared(~locx - 0)) + (squared(~locy - 0))) }),
		pan: Prand([Pfunc{~locx}, Pfunc{~locy}], inf),
		// utility: Pfunc { arg event; event.amp.postln },
		cav: 0.12,
		dlt: Pkey(\atk),
		dla: Pseq([0.2, 0.3, 0.4], inf),
		hpf: 24,
		aux: 0,
	]),
).play;

Pdef(1,
	Pbindf(Pdef(0), *[
		num: 1,
		amp: 0.09 * (1.4142135623731 - Pfunc{ sqrt((squared(~locx - 1)) + (squared(~locy - 0))) }),
])).play;

Pdef(2,
	Pbindf(Pdef(0), *[
		num: 2,
		amp: 0.09 * (1.4142135623731 - Pfunc{ sqrt((squared(~locx - 0)) + (squared(~locy - 1))) }),
])).play;

Pdef(3,
	Pbindf(Pdef(0), *[
		num: 3,
		amp: 0.09 * (1.4142135623731 - Pfunc{ sqrt((squared(~locx - 1)) + (squared(~locy - 1))) }),
])).play;

Pdef(4,
	Pbindf(Pdef(0), *[
		num: Prand([0, 1, 2, 3], inf),
		degree: Pwrand([3, 6, 10, 5], [5, 2, 1, 1], inf),
		amp: Pseg([0.0, 0.001, 0.1, 0.0], [100, 10, 90], \lin, 1),
		scale: Scale.farahfaza.tuning_(\sruti),
		spd: Pfunc{~speed},
	]),
).play;

);
