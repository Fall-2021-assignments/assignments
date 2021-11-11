(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \saw,

		amp: 0.5,

		dur: Pseries(0.125, 0.005, inf).wrap(0.125, 0.3),

		stretch: Pdup(Pwhite(47, 92), Pseq([Prand((3, 5 .. 7)), Prand([1, Prand((3, 5 .. 7))])], inf)) +
			Pseg([Pwrand2([-0.15, -2], [20, 1], inf), 0.2], 1, \lin, inf),

		clump: Pdup(Pwhite(2, 7), Pwhite(1, 4)),
		freq: Pseries(200, 1, inf).wrap(200, 250),
		freq: Pclump(Pkey(\clump), Pseq([Pkey(\freq), Pkey(\freq) * 2.5, Pkey(\freq) * 4.75, Pkey(\freq) * 0.5], inf)),

		iph: Pclump(Pkey(\clump), Pwhite(0.0, 1.0)),
		wid: Pclump(Pkey(\clump), Pbrown(0.0, 1.0, 0.05)),

		pan: Pclump(Pkey(\clump), Pmeanrand(0.0, 1.0)),

		// bnd: Pclump(Pkey(\clump), Pdup(Pwhite(1, 40), Pwhite(-1.0, 1.0))) * 0.25,
		// bnt: Pkey(\dur) * Pwhite(0.333, 0.666),
		// bno: Pkey(\dur) * Pmeanrand(0.0, 0.333),

		atk: Pseries(0.001, 0.004, inf).wrap(0.001, 0.2),
		rel: Pdup(Pwhite(10, 33), Pseries(2, 0.05, inf).wrap(2, 4)),
		legato: Pdup(Pwhite(10, 33), Pseries(1.2, 0.05, inf).wrap(1.2, 3)),

		fzv: Pseq((0, 0.05 .. 4.0), inf),
		fuz: 1,
		fza: 1,

		dla: 0.8,
		dlt: 0.5,
		dlf: 0.2,

		cmb: Pwhite(0.0, 1.0),
		frz: Pseg([-1, 1], 0.3, \lin, inf),
		// frb: 0.75,

		sdx: Pdup(Pwhite(3, 43), Pseq((1, 1.1 .. 2.5), inf)),
		sdt: Pdup(Pwhite(1, 8), Pwhite(8.0, 13.0)),
		sdq: Pseg([0, 1], 0.8, \lin, inf),

		scm: Pseq((0.0, 0.05 .. 1.0), inf),
		// scb: 0.5,

		mir: Pseg([0, 1, 0.15, 0], 0.0625, -1, inf),
		mii: Pseg([1, 0, 1, 0], [0.1, 0.0625, 0.0625], \lin, inf),

	])
).play;
);
