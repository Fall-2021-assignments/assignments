
(
// if clock doesn't exist, make one, otherwise use it
~clock = ~clock ?? { TempoClock(2).permanent_(true) };


// re-evaluating these immediately updates the running Pdef
~kik = Pbindef(\kik, *[
	type: \cln,
	snd: \drm,

	tun: Prand([0.5, 1.2, 4, 0.7], inf),
	pew: Phprand(0.7, 3.5),
	fed: Prand([0.0001, Plprand(0.0, 2.0, 1)], inf),

	rel: Pwhite(1.0, 4.0).round(0.25),

	dur: 1,
	// dur: Pseq([1, 1, 2], inf) * Pdup(2, Prand([1, 0.5, 2, 1.25], inf)),
	// dur: Prand([Pseq([3, 1, 1]), Pseq([3, 1, 1, 3])], inf),

	// length is recalculated each time this block is re-evaluated
	length: Pdup(25.rrand(100), Pseq([0])),
]);

~clp = Pbindef(\clp, *[
	type: \cln,
	snd: \clp,

	srp: 0.4,
	// srp: Prand([0.15, 0.35, 0.75], inf),
	srq: Pwrand2([0.5, 0.1], [10, 1], inf),
	bdy: Pmeanrand(0.1, 1.3),
	bdt: Phprand(0.0, 0.05),
	tha: 0.7,
	tho: 0.7,

	amp: 0.3,

	rel: Prand([0.1, 0.2, 0.3], inf),

	dur: 1,
	// dur: Pseq([2, 3, Pwrand2([Pseq([2, 3]), 1, 4], [10, 1, 2])], inf),
	// dur: Pseq([2, 3, Pwrand([Pseq([2, 3]), 1, 4], [10, 1, 2])], inf),

	length: Pdup(25.rrand(100), Pseq([0])),
]);

~hat = Pbindef(\hat, *[
	type: \cln,
	snd: \hat,

	tun: Pmeanrand(1.2, 1.4).round(0.1),
	cfr: Pmeanrand(1700, 2800).round(50),
	bnd: Pmeanrand(-0.02, 0.02),
	bno: Pwhite(0.0, 0.02),
	bnc: Pwhite(0, 5),

	rel: Pwrand2([0.125, 0.25, 0.75, 1.5], [50, 3, 1, 0.1], inf),

	dur: 1,
	// dur: Pseq([1, Pwrand([1, 2, 0.5], [10, 1, 2])], inf),
	// dur: Pseq([1, Pwrand([1, 2, 0.5], [10, 1, 2])], inf),

	length: Pdup(25.rrand(100), Pseq([0])),
]);


~bind = Pbindef(\bind, *[
	type: \cln,
	snd: Pseed(1, Prand([\sin, \saw, \fmx], inf)),

	wid: 0,
	iph: Pwhite(0.0, 0.07),

	amp: Pmeanrand(0.1, 0.4),
	pan: Pbrown(-1.0, 2.0, Pmeanrand(0.005, 0.075)).wrap(0.3, 0.6),

	scale: Scale.pelog,
	degree: Place([Pxrand([0, 3, 7, 1, 6, 0, 2], inf), Pxrand([0, 3, 7, 1, 6, 0, 2], inf)], inf),
	octave: Pwrand2((4 .. 5), [10, 1], inf),

	atk: Plprand(0.01, 0.11),
	rel: Prand([1, 3, 0.5], inf) * 2,
	tsc: Pwhite(0.7, 2),

	sustain: 1.5,

	dur: 1 / Pwrand2((2 .. 16), [3, 1, 2].lace(15), inf),

	dla: 0.6,
	dlt: Prand([2.25, 3, 2], inf),
	dlf: 0.93,

	length: Pdup(25.rrand(100), Pseq([0])),
]);

~bass = Pbindef(\bass, *[
	type: \cln,
	snd: \saw,

	scale: Scale.pelog,
	degree: Pseq([0, 3, 7, 1, 6, 0, 2], inf),
	octave: Pseq([4, 4, Prand([4, 3])], inf),
	// octave: 4,

	// rest: Pseq([0, 0, Prand([0, \r])], inf),

	// rel: Pmeanrand(1.5, 3.5),
	rel: Pmeanrand(0.5, 2.5),

	tri: Plprand(0.0, 0.3),

	wid: Pwhite(0.45, 0.55),

	amp: 0.3,
	// dur: Prand([3, 2, 1, 2, 3], inf),
	dur: Pseq([3, 2, 1, 2, 3], inf),

	length: Pdup(25.rrand(100), Pseq([0])),

	// verify: Pfunc { "bass".postln },

]);
)




// interweave patterns
(
Pdef(0,
	Pseed(Pseq((0 .. 3), inf), // < "melodic progression"

		// tracker
		// add or remove elements here in a similar vein
		Ppatlace([
			~kik,
			// Ppar([~kik, ~hat]),
			// Ppar([~clp, ~bass]),
			~clp,
			~kik,
			Ppatlace([ // ~hat
				Pwrand2([~bass, ~bind], [100, 1]),
				~hat,
				~kik,
				Ppar([~clp, ~hat]),
			], 2),
			~bind,
		], 5)
	)
).play(~clock, quant: 5)
)


~clock.tempo = 7.2

Pdef(0).stop
