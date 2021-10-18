/* assignment from september 30th
dirk dullmaier

goals:
1. granular-like fieldrec mangling via extremely low durations
2. use psegs for evolving modulations and distortions
3. better ordering, remote control

WORK IN PROGRESS (i think this is going to be a running joke from now on)
samples can be found at: https://github.com/dormirj/samples/tree/main/pseg_etc_30sep
*/

//SETUP
(
SynthDef(\piano, {
	arg out, freq = 440, gate=1, rel = 0.9, hld = 0;
	// guess i should utilize more of cleans parameters, look more into mdapiano and envelopes
	var sig = MdaPiano.ar(freq, gate, release: rel, stereo: 0.3, sustain: hld);
	DetectSilence.ar(sig, 0.01, doneAction:2);
	Out.ar(out, sig * 0.1);
}).store;
);
//PDEFS
(
(Pdef(0,
	Pbind(*[
		type: Pseq([\cln, \r]++(\cln!3)++(\r!2), inf),
		snd: \piano,
		scale: Scale.dorian,
		// probably wanna do some more interesting things here at some point TODO
		degree: Pseq([[1, 3], [1, 6], [3, 5]], inf),
		dur: Pseq([2, 1, 1, 1/2], inf),
		amp: 0.5,
		dla: 0.4,
		dlt: 2 * Pkey(\dur),
		dlf: 0.3,
		cav: 0.9,
		legato: 1.2,
	]),
)
);

/*i still haven't managed to make this seamless, not sure what's wrong.
is my calculation off or are there still some limitations with the built-in
envelope, i tried to omit the fadetime--*/
(Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \pseg_etc_30sep,
		segments: 50,
		num: Pdup(25, Pseq([0, 1, 2], inf)),
		length: Pfunc { arg event; ~clean.buffers[\pseg_etc_30sep][event.num].numFrames / ~clean.buffers[\pseg_etc_30sep][event.num].sampleRate },
		single: Pkey(\length) / Pkey(\segments),
		bgn: Pseg([0.0, 1.0], Pkey(\length), \lin, inf),
		dur: Pkey(\single),
		legato: Pkey(\single) * 1.3,
		dla: Pwhite(0.3, 0.42),
		// dlt: 1 / Pkey(\segments) + Pwhite(0.01, 0.1),
		dlf: Pwhite(0.01, 0.02),
		hpf: 800,
		amp: 0.8,
		cav: 0.8,
		// utility: Pfunc { arg event; event.single.postln },
	]),
)
);

(Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \pseg_etc_30sep,
		segments: Pseq([Pseq([100], 4), Pdup(477, Pwhite(500, 750))], inf),//cut the playback into n pieces
		num: Pdup(Prand([10,40,100], inf), Pwhite(0, 2), inf),
		length: Pfunc { arg event; ~clean.buffers[\pseg_etc_30sep][event.num].numFrames / ~clean.buffers[\pseg_etc_30sep][event.num].sampleRate },
		single: Pkey(\length) / Pkey(\segments),
		// slices: Pfunc { arg event; Array.interpolation(event.segments, 0.0, 1.0) },
		// bgn: Pseq(Pkey(\slices), inf), --doesnt work
		// bgn: Pseg([0.0, 1.0], Pkey(\length), \lin, inf),
		bgn: Pseg(Pwhite(0.1, 0.9), Pwhite(1, 50), \lin, inf),
		dur: Pkey(\single),
		legato: Pkey(\single) + Pseg([1.0, 30.0, 12.0, 40.0, 1.0], Pkey(\length) / 4, \sin, inf),
		dla: Pwhite(0.3, 0.42),
		dlf: Pwhite(0.01, 0.02),
		stretch: Pseg(Pmeanrand(0.5, 2.0), Pwhite(20.0, 40.0), \exp, inf),
		spd: Pseg([1.0, -1.0], [Pkey(\length) * 4], \wel, inf),
		tri: Pseq([Pseq([0.0], 1000), Pwrand2((0 .. 300), (300 .. 0), inf)], inf),
		hpf: 200,
		hpq: 0.1,
		pan: Pmeanrand(0.0, 1.0),
		amp: 0.35,
		tnh: 0.25,
		tng: 0.4,
		cav: 0.7
		// utility: Pfunc { arg event; event.single.postln },
	]),
)
);

(Pdef(3,
	Pbind(*[
		type: Pdup(40, Pseq(
			[Pseq([\cln, \r]++(\cln!3)++(\r!12), inf),
				\r, \r], inf)),
		snd: \piano,
		scale: Scale.dorian,
		degree: Pseq([[8, 10], [8, 13], [10, 12]], inf),
		// degree: Pseg([[15, 10], [10, 12]], Prand([5, 10, 7.5], inf), \sin, inf),
		dur: Pseq([1/8, 1/16, 1/16, 1/32], inf),
		amp: Pseg([0.1, 0.5, 0.2], [5, 3], \lin, inf),
		dla: 0.4,
		dlt: 2 * Pkey(\dur),
		dlf: 0.3,
		cav: 0.5,
		legato: 2,
	]),
)
);

// used pbindf to create instances with variations
(Pdef(4,
	Pbindf(Pdef(0), *[
		degree: Pseq([12, 13, 14], inf),
		amp: 0.55,
])));

(Pdef(5,
	Pbindf(Pdef(2), *[
		bgn: Pdup(Pwhite(1, 20), Pseg(Pwhite(0.1, 0.9), Pwhite(1, 50), \lin, inf)),
])));

(Pdef(6,
	Pbindf(Pdef(2), *[
		segments: 10,
])));

);

//PLAY
(
Routine{
	// s.record;
	"intro".postln;
	Pdef(1).play;
	20.wait;
	Pdef(0).play;
	40.wait;
	"engage chaotic elements".postln;
	Pdef(3).play;
	Pdef(2).play;
	20.wait;
	"change up params".postln;
	Pdef(3).stop;
	Pdef(4).play;
	20.wait;
	Pdef(5).play;
	20.wait;
	Pdef(2).stop;
	Pdef(6).play;
	Pdef(1).stop;
	20.wait;
	Pdef(5).stop;
	"outro".postln;
	10.wait;
	Pdef(0).stop;
	Pdef(6).stop;
	Pdef(3).play;
	10.wait;
	Pdef(3).stop;
	Pdef(4).stop;
}.play
);
