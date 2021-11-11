
(
TempoClock.default.tempo = 4;

Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \drm,

		dur: Pseq([4, Pwrand([5, 4, 2, 3, 7], [1, 1, 0.5, 0.8, 0.9].normalizeSum)], inf),

		amp: Pseq([0.6, 0.5], inf),

		tun: Pn(Pif(Ptime(inf) <= 10, Env([1.5, 0.5, 0.5, 0.3, 0.5], [1, 4, 2, 1], \exp)), inf),
		// tun: 0.5,

		pew: Pn(Pif(Ptime(inf) <= 7, Env([0.3, 0.3, 0.5, 1, 10], [2, 0.5, 0.5, 4], \sin)), inf),
		fed: Pn(Pif(Ptime(inf) <= 11, Env([1000, 100, 110, 80, 100, 10], [1, 2, 1.5, 1.5, 5], \lin)), inf),

		sustain: 8,

		lpf: Pn(Pif(Ptime(inf) <= 8, Env([10000, 800], 8, \exp)), inf),
		lpq: Pbrown(0.1, 0.5, 0.02),

		hpf: Pn(Pif(Ptime(inf) <= 9, Env([20, 100, 300, 80], [1.7, 5.3, 2], \wel)), inf),
		hpq: Pn(Pif(Ptime(inf) <= 4, Env([0.2, 0.4], 0.5, \lin)), inf),

		pan: Pwhite(0.0, 1.0),

		dla: Pkey(\amp) - 0.2,
		dlt: Pseq([0.5, 1, 0.125, 0.8, 3.5].scramble, inf),
		dlf: Pn(Pif(Ptime(inf) <= 18, Env([0.0, 0.9], 18)), inf),


		cav: Pseg([0.01, 30, 100.0], Pkey(\dur), \exp, inf),
		cai: Pseg([0.01, 0.2, 0.7, 0.7, 0.01], [0.01, 0.15, Pkey(\dur) * 0.75, Pkey(\dur) * 0.5], [\exp, \sin, \lin, \sin], inf),
		cvt: Pseg(Pseq((0.125, 0.1875 .. 0.5)), Pkey(\dlt) * 8, \exp, inf),
		cvd: Pseq((1.0, 0.9 .. 0.1), inf),
		cvl: Pseq([1.0, 0.75, Pwrand([0.25, Pseq([0.625, 0.5, 0.375, 0.25])], [2, 1].normalizeSum)], inf)
	])
);


Pdef(1,
	Pbindf(Pdef(0), *[
		amp: Pn(Pif(Ptime(inf) <= 0.375, Env([0.2, 0.35], 0.375, \wel)), inf) * 0.7,
		fsh: Pxrand([0.001, -0.001, 0.3, 0.01], inf),
		fsm: Prand([-1, 1, 2, -2], inf),
		fsp: Pwhite(0.0, 10.0).mod(pi),
		aux: 1,

		tun: Pn(Pif(Ptime(inf) <= 10, Env([1.5, 0.5, 0.5, 0.3, 0.5].scramble, [1, 4, 2, 1].scramble, \exp)), inf) * 2,

		pew: Pn(Pif(Ptime(inf) <= 7, Env([0.3, 0.3, 0.5, 1, 10].scramble, [2, 0.5, 0.5, 4].scramble, \sin)), inf),
		fed: Pn(Pif(Ptime(inf) <= 11, Env([1000, 100, 110, 80, 100, 10], [1, 2, 1.5, 1.5, 5], \lin)), inf),

		// dla: Pkey(\amp) * 0.8,
		// dlt: Pseq([0.5, 0.375, 0.125, 0.25].scramble, inf),
		// dlf: Pn(Pif(Ptime(inf) <= 2, Env([0.0, 0.9], 2)), inf),
		dla: 0.65,
		dlf: Pwrand([1, 0.5, 0.25, 0.125], [0.5, 1, 1, 0.25].normalizeSum, inf),
		dlt: Pseg([Pkey(\dur), Pkey(\dur), Pkey(\dur) * 0.25], [Pkey(\dur) * 0.125, Pkey(\dur) * 0.5], \exp, inf),
		dlt: Prand([Pkey(\dlt, 3), Pkey(\dur) * 0.25], inf),
	])
);


Pdef(2,
	Pbindf(Pdef(1), *[
		amp: Pn(Pif(Ptime(inf) <= 0.625, Env([0.35, 0.2], 0.625, \exp)), inf) * 0.6,
		rma: 2,
		rmf: Pkey(\tun) * Pwrand([1.01, 0.25, 4, 10, 20], [1, 1, 3, 1.5, 0.5].normalizeSum, inf),
		rdf: Pkey(\rmf) * 10 * Pwhite(-1, 1),
		rdt: Pxrand([0, 0.1, 0.5, 1, 3, 10, Pkey(\dur)], inf),
		aux: 0,
	])
);


Pdef(3,
	Pbindf(Pdef(1), *[
		amp: Pn(Pif(Ptime(inf) <= 1, Env([0.3, 0.2, 0.35, 0.15], [0.3, 0.3, 0.4], \exp)), inf),
		dur: 1,
		sustain: 4,
		mir: Pseg([0.8, 0.01, 0.2], [Pkey(\dur) * 0.25, Pkey(\dur) * 0.5], [\sin, \exp], inf),
		mii: Pseg([0, 1.3], Pkey(\dur) * 0.0625, \lin, inf),
	])
);


Pdef(4,
	Pbindf(Pdef(3), *[
		dur: Pseq([0.5, 0.375, 0.125], inf),
		bpf: Pseq([400, 200], inf) * Pseq([0.5, 1, 2], inf),
		bpq: Pseq([0.1, 0.15, 0.2, 2.5], inf),
		amp: 0.05,
		aux: 1,
	])
);


Pdef(5,
	Pdup(Phprand(3, 11),
		Pbindf(Pdef(2), *[
			amp: 0.3,
			dur: Pdefn(\d),
		])
	)
);

Pdefn(\d, 10);
)


// i like it in this order, but with time between each Pdef being played, but you pick
Pdef(5).play;
Pdef(0).play;
Pdef(3).play;
Pdef(2).play;
Pdef(1).play;
Pdef(4).play;

// messing with Pdefn(\d) is fun too, which sets the bounce time of Pdef(5), small values very bouncy
Pdefn(\d, 0.5);
Pdefn(\d, 0.75);
Pdefn(\d, 1);
Pdefn(\d, 1.5);
Pdefn(\d, 3);
Pdefn(\d, 6);
Pdefn(\d, 10);

// no preference for stopping
Pdef(0).stop;
Pdef(1).stop;
Pdef(2).stop;
Pdef(3).stop;
Pdef(4).stop;
Pdef(5).stop;



// (
// r = Routine {
// 	Pdefn(\d, 0.5);
// 	Pdef(5).play;
// 	2.wait;
// 	Pdefn(\d, 0.75);
// 	2.wait;
// 	Pdefn(\d, 1.5);
// 	2.wait;
// 	Pdefn(\d, 3);
// 	2.wait;
// 	Pdefn(\d, 6);
// 	2.wait;
// 	Pdefn(\d, 10);
// 	2.wait;
// 	Pdef(0).play;
// 	7.wait;
// 	Pdef(3).play;
// 	10.wait;
// 	Pdef(2).play;
// 	5.wait;
// 	Pdef(1).play;
// 	10.wait;
// 	Pdef(4).play.yield;
// }
// )
// r.play
