(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \sin,
		dur: Pdup(Pwhite(0.001, 5.0), Pwhite(0.7, 1.89)) * 0.25,
		legato: 2,
		sustain: Pseq([0.0001, 0.002, 0.03, 0.4, 1, 1.5], inf),
		//atk: 0.01,
		//rel: Pwrand2((0.8, 0.9 .. 2.00), (2.0, 1.9 .. 0.08), inf).trace,
		//bgn: Pseg(Pwhite(0.1, 0.9), Pwhite(1, 25), \exp, inf),
		bgn: Pseg(Pwhite(0.1, 0.9), Pwhite(1, 50), \lin, inf),
		end: 0.6 - Pkey(\bgn),
		bnd: Pdup([Pkey(\dur)], Pwhite(0.001, 0.6)) - Pwhite(0.02, 0.9),
		//bnt: 1,
		//bno: Pkey(\dur),
		ocd: Pdup(12, Pwhite(-12, 0)),
		smr: Pexprand(0.00001, 0.1),
		enh: Pwhite(0.0, 0.4),
		dla: 1 / Pkey(\sustain),
		dlf: 2,
		dlt: 2 * Pdup([Pkey(\sustain)], Prand([-0.0001, -0.002, -0.03, -0.4, 1, 1.5], inf)),
		cav: Pkey(\enh),
		cai: 0.4,
		cvt: 0.1,
		cvh: 0.7,
		tnh: 0.001,
		tng: 300,
		pan: Pwhite(0.1, 1.0),
		amp: Pexprand(0.5, 0.7),





	]),
).play
);