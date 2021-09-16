(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \dfd,
		sustain: 5,
		dur: 1/7,
		legato: 4,
		pan: Pdup(Pwhite(0, 50), Pwrand([Pwhite(1.0, 0.400), Pwhite(0.506, 1.0)], [1, 1.5].normalizeSum, inf)),
		cai: Pdup(Pwrand([1, 21], [1, 9].normalizeSum, inf), Pwhite(0.0, 1.0)),
		tun: Pwrand([1, 20, 4, 8], [8, 44, 2, 1].normalizeSum, inf),
		tun: Pwrand([1, 3, 7, 6], [0.125, 0.25, 0.5, 2.0, 0.125], inf),
		fed: Pdup(80, Pwhite(0.0, 3.5)),
		sho: Pwhite(0.0, 20.0),
		bnd: Pwhite(-0.032258054516129, 0.032258064516129),
		pew: Pdup(Pwhite(1, 9), Pseq((0.0, 0.1 .. 1.0), inf)),
		dst: 0.73,
		amp: 1.3,

	])
).play
)