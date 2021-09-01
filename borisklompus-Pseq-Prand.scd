// todo: 
// convert variables into keys, and use (external) value patterns to generate arrays for all the voices
// // these can then be sequenced, or interchanged between keys, or subject to further manipulation based on other factors.
// create more correlation between values
// // eg- rounding factor changes based on the amount of overtones. fewer overtones, larger value? bandwidth stays the same, so more space to fill?
// // or opposite? from this perspective the bandwidth can also be a key.
// some sort of end of chain (pattern mixing ability)
// auxes?



// evaluate first
// evaluate first
// evaluate first
(
// SuperClean input
// simple SynthDef which has an input of x channel size (according to amount of channels set in SuperClean)
// sustaining envelope, with optional delay parameter for env start
SynthDef(\route, { |in, out, amp = 0.5, pan = 0.5, gate = 1, del = 0, atk = 0.01, dec = 0.3, hld = 1.0 rel = 0.5, crv = -4.0|
	var sound;
	// var env = EnvGen.kr(Env.adsr(atk, dec, hld, rel, amp, crv), gate, doneAction: 2);
	// DADSR
	var env = EnvGen.kr(Env.dadsr(del, atk, dec, hld, rel, amp, crv), gate, doneAction: 2);
	sound = In.ar(in, ~clean.numChannels);
	sound = sound * env;
	sound = CleanPan.ar(sound, ~clean.numChannels, pan);
	OffsetOut.ar(out, sound);
}).store;

// add SynthDef to SuperClean Environment / Event
~clean.soundLibrary.addSynth(\route,
	(
		instrument: \route,
		in: {
			~clean.audioRoutingBusses.wrapAt(~from ? 0).index
		}
	)
);


// create audio bus to easily send signal into SuperClean events
// ~cleanIn = Bus.audio(s, ~clean.numChannels);

// to create an array with several indexable buses:
// ~cleanIn = (Bus.audio(s, ~clean.numChannels) ! 3);

// to create several named buses, use IdentityDictionary, and pass the names into a do method:
~cleanPatchPoint = IdentityDictionary.new;
[\cleanIn1, \cleanIn2, \cleanIn3, \cleanIn4, \cleanMix1, \cleanMix2, \cleanMix3, \cleanMix4].do { |name, i|
	~cleanPatchPoint.put(name, Bus.audio(s, ~clean.numChannels));
};
)


// evaluate second
// evaluate second
// evaluate second
(
// sound source, using default event prototype, mainly for \strum function, routed through an audio bus into a different pattern using SuperClean event prototype

var harmonics;
var holds;
var attacks;
var releases;
var curves;
var pans;
var pans2;
var amps;
var phases;
var bends;
var bendTimes;
var bendCurves;

Pdef(\source,
	Pbind(*[
		instrument: \sin,

		dur: Pwhite(0.0625, 10, inf).round(Prand([0.0625, 0.05], inf)),

		change: Pseq([1, Prand([1, 1, 0], inf)], inf), // Prand will take over on second step; Pseq here just to guarantee initial loading of arrays in setup

		otam: Pwhite(1, Pseq([16, 32, Prand([12, 17, 3])], inf), inf), // "OverTone AMount" amount of voices
		round: Prand([30, 30, 30, 35, 35, 100, 22, 78.5], inf), // overtone freq round factor
		otlw: Prand([50, 22, 147], inf), // "OverTone LoW" - lowest possible freq. depending on random and/or round, not guaranteed!
		otbw: Prand([Pseq([1600, 2200, 4700], 1), 2177, 1600], inf), // "OverTone BandWidth" - upper limit of possible overtone freq

		setup: Pfunc { |ev|
			if (ev[\change] == 1) {
				harmonics = Array.fill(ev[\otam] + 1, { exprand(ev[\otlw], ev[\otbw]).round(ev[\round]) });
				attacks = Array.fill(harmonics.size, { rrand(0.001, 0.60) });
				holds = Array.fill(harmonics.size,  { rrand(0.01, 0.8) });
				// holds = Array.fill(harmonics.size,  { rrand(0.80, 2.20) });
				releases = Array.fill(harmonics.size, { |i| if (harmonics[i] > 600) { rrand(15.5, 17.5) } { rrand(0.5, 2.5) } });
				pans = Array.fill(harmonics.size, { 1.0.rand2; });
				amps = Array.fill(harmonics.size, { |i| if (harmonics[i] < 600) { exprand(0.35, 0.60) } { exprand(0.01, 0.25) } });
				phases = Array.fill(harmonics.size, { rrand(0.00, 1.00) });
				bends = Array.fill(harmonics.size, { rrand(0.00, 1.00) });
				bendTimes = (phases * bends).scramble * 2;
				bendCurves = Array.fill(harmonics.size, { 1.00.bilinrand });
			} {
				harmonics;
				attacks = Array.fill(harmonics.size, { 2 } );
				holds = Array.fill(harmonics.size, { 2 } );
				releases;
				pans;
				amps;
				phases;
				bends = Array.fill(harmonics.size, { rrand(0.00, 1.00) });
				bendTimes = (phases * bends).scramble * 2;
				bendCurves = Array.fill(harmonics.size, { 1.00.bilinrand });
			}
		},

		freq: Pfunc { harmonics },
		atk: Pfunc { attacks },
		hld: Pfunc { holds },
		rel: Pfunc { releases },
		iph: Pfunc { phases },
		bno: Pfunc { bends },
		bnt: Pfunc { bendTimes },
		bnc: Pfunc { bendCurves },
		pan: Pfunc { pans },
		
		// higher overtones are quieter
		amp: Pfunc { |ev| amps * (ev.[\otam] * 0.9).reciprocal },

		strum: Prand([-1, 1, 1, 1, 1], inf) * Prand([0, 0.0625, 0.03125, 0.125, 0, 0, 1, 0.5, 0.01, 0.08, 0.02], inf),

        // patch to audio bus that is referenced in a different pattern
		out: ~cleanPatchPoint[\cleanIn1],

	])
).play(quant: 1)
)


// (
// Pdef(\dry,
// 	Pbind(*[
// 		type: \cln,
// 		snd: \route,
// 		in: ~cleanPatchPoint[\cleanIn1],
// 		
// 		amp: 1,
// 		
// 		del: 0,
// 		atk: 0.01,
// 		dec: 0.3,
// 		hld: 1.0,
// 		rel: 3,
// 		
// 		dur: 4,
// 	])
// ).play(quant: 1)
// )
// Pdef(\dry).stop


(
Pdef(\proc1,
	Pseed(48, // <<<
		Pbind(*[
			type: \cln,
			snd: \route,
			in: ~cleanPatchPoint[\cleanIn1],

			dur: 0.125,

			legato: Prand([1, Phprand(0.2, 1.2, 1)], inf),

			// first values of  prand were the former sole values
			amp: Prand([1, Phprand(0.3, Pmeanrand(0.7, 1.2, inf), 1)], inf),

			// shorter dur > wider panning more likely, longer dur, closer to center
			pan: Pif(Pkey(\dur) < 2, Pbeta(0.05, 0.95, 0.5, 0.5, inf), Pbeta(0.2, 0.7, 1.6, 1.6, inf), 0.5),
			// pan: Prand([0.5, Pwhite(0.0, 1.0, 1)], inf),

			rel: 3,

			sac: 1,
			slo: Pseq((0..10) * 0.1, inf),
			shi: Pseq((0..10) * 0.1, inf, 3),
			sho: Pseq((0..10) * 0.1, inf, 5),
			lot: Pseq((0..10) * 0.1, inf, 7),
			hit: Pseq((0..10) * 0.1, inf, 9),

			tri: Prand([0.7, 0, Pwhite(0.0, 1.0, 1)], inf),

			dla: 1,
			dlt: [0.5, 0.75],
			dlf: Prand([1.0, 0.4, 0.1, 0.7, 0.3, 0.6], inf),
			
		])
	)
).play(quant: 1)
)


(
Pdef(\proc2,
	Pseed(48, // <<<
		Pbind(*[
			type: \cln,
			snd: \route,
			in: ~cleanPatchPoint[\cleanIn1],

			amp: 0.8,

			dur: Prand([2, Pseq([0.125, 0.13, 0.135, 0.14, 0.145, 0.15, 0.155, 0.16, 0.165, 0.17, 0.175, 0.18, 0.185], 1), Prand([0.5, 1.5, 4], 1)], inf),

			del: Pif(Pkey(\dur) < 1, 0, Prand([0, 0, 0, 0.04, 0.09, 0.1, 0.3], inf)),
			atk: 0.01,
			dec: 0.3,
			hld: 1,

			rel: 5,


			pan: Pwhite(0.2, 0.8, inf) ! 2,
			// pan: 0.5,

			dla: Prand([1, 0, Phprand(0.4, 1.2, 1)], inf),
			dlt: Prand([
				Pseq([0.625, 0.1, 1.4], 1),
				Pwhite(2.0, 6.0, 1).round(Prand([0.0625, 0.06], inf)),
				Pseq([0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0], 1) * Pxrand([
					Pseq([1], 8), Pseq([2], 8), Pseq([3], 4), Pseq([4], 4), Pseq([5], 4), Pseq([6], 4), Pseq([0.5], 8),
				], 1),
			], inf),
			dlf: Prand([Prand([1.0, 0.4, 0.1, 0.7, 0.3, 0.6], 1), Pbrown(0.6, 0.98, 0.08, 11)], inf),


			rma: Prand([0.0, 0.7, 0.5], inf),
			rmf: Prand([200, 202, 198, 70], inf),
			rdf: Prand([100, 65, 2592, 7000], inf),
			rdt: Prand([0.5, 1.3, 1.8, 1.4, 2.2, 1.37], inf),

			// rma: Prand([0.7, Pwhite(0.34, 0.8, 1)], inf),
			// rmf: Prand([ // from otlw, otbw, and round:
			// 	200,
			// 	Pwhite(
			// 		Prand([50, 22, 147], 1),
			// 		Prand([Pseq([1600, 2200, 4700], 1), 2177, 1600], 1), // inf?
			// 1)], inf).round(Prand([30, 30, 30, 35, 35, 100, 22, 78.5], inf)), // switch to Plambda / Plet / Pget to reference rather than copy/paste
			// rdf: Prand([ // from otlw, otbw, and round:
			// 	7000,
			// 	Pwhite(
			// 		Prand([50, 22, 147], 1),
			// 		Prand([Pseq([1600, 2200, 4700], 1), 2177, 1600], 1),
			// 1)], inf).round(Prand([30, 30, 30, 35, 35, 100, 22, 78.5], inf)), // switch to Plambda / Plet / Pget to reference rather than copy/paste
			// rdt: Prand([1.4, Pwhite(0.15, 3.4, 1)], inf),

			tri: 0.7,

		])
	)
).play(quant: 1)
)

// 
Pdef(\source).stop

Pdef(\dry).stop
Pdef(\proc1).stop
Pdef(\proc2).stop
