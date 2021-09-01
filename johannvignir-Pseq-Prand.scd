(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \bow,
		dur: Pseq([0, 0.001, 0.01, 0.1, 0.01, 0.001], inf) / Prand([1/4, 1/7, 2/4] ,inf),
		atk: Prand([0.01, 0.1, 0.5, 1], inf),
		rel: Prand([0.01, 0.5, 1], inf),
		hld: 0,
		legato: Pseq([0, 1, 2, 3, 2, 1, 0], inf, 1),
		tun: Pseq([1, 5, 7, 8], inf),
		degree: Pseq([0, 2, 5, 6, 8, 5, 1], inf, 2),
		octave: Prand([1, 2, 3, 6], inf),
		dla: Prand([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7], inf),
		dlf: Pseq([0, 0.4, 0.6, 1.0, 0.6, 0.4], inf),
		dlt: Prand([0.1, 0.12, 2.13, 0.14], inf) * Pkey(\dur),
		pan: Pkey(\dur, inf) * Prand([0.0, 0.3, 0.5, 0.7, 0.9, 1], inf),
		ocu: 1,
		smr: Pseq([0, 0.3, 0.5, 0.7, 0.5, 0.3, 0], inf),
		shi: Pseq([0.2, 0.22, 0.222, 0.2222], inf),
		rma: 0.5,
		rmf: 10 / Prand([100, 200, 300, 400], inf),
		rin: Pseq([0.3, 0.5, 0.7, 0.9, 1, 0.9, 0.7, 0.5, 0.3, 0], inf),
		rev: 0.9,
		dry: 0.5,
		cai: 0.1 / Pkey(\atk),
		cvt: Pkey(\octave),


	]),
).play
)