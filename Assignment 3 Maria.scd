(
Pdef(1,
	Pbind(*[
		type: \cln,
		snd: Pxrand([\dfd,\sqr,], inf),
		sustain: 4,
		dur:1 / Pdup(Pwhite(0, 2.7), Pwhite(0.5, 3)),
		legato: 5,
		pan: Pdup(Pwhite(0, 50), Pwrand([Pwhite(1.0, 0.400), Pwhite(0.506, 1.0)], [1, 1.5].normalizeSum, inf)),
		scale: Pdup(4, Pseq([
				Scale.harmonicMinor.tuning_(Tuning.just),
				Scale.harmonicMinor.tuning_(Tuning.vallotti),
			], inf)),
		cai: Pdup(Pwrand([1, 2, 1, 3, 2], [1, 9].normalizeSum, inf), Pwhite(0.0, 1.0)),
		tun: Pmeanrand([1, 0, 4, 8], [2, 4, 3, 1].normalizeSum, inf),
		tun: Pwrand([1, 3, 7, 6], [0.125, 0.25, 0.5, 2.0, 0.125], inf),
		fed: Pdup(80, Pwhite(0.0, 3.5)),
		sho: Pwhite(0.0, 200.0),
		bnd: Pwhite(-0.04, 2.7),
		pew: Pdup(Pwhite(1, 9), Pseq((0.0, 0.1 .. 1.0), inf)),
		dst: 4.73,
		amp: 0.7,
		stretch: Pseed(1, Prand([1, 3.01], inf)),
		pew: Pdup(Pwhite(1, 9), Pseq((0.0, 0.1 .. 9.0), inf)),
		//pan:Pmeanrand(0.1,2.0),

	])
).play;
)


