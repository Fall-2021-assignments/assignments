(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: Pseq([\add, \sin, \saw], inf),
		dur: 1/Prand([3, 5, 7, 9, 11, 16], inf),
		degree: Pwrand([0, 1, 2, 3], [0.1, 0.5, 0.1, 0.3], inf),
		scale: Scale.phrygian,
		octave: 3,
		atk: Prand([1, 3, 5, 7, 9, 11], inf),
		rel: Prand([1, 3, 5, 7, 9, 11], inf),
		sustain: Prand([1, 3, 5, 7], inf),
		cav: Pdup(5, Pwhite(0.2, 0.5)),
		cai: Pseq ([0.1, 0.2, 0.3, 0.4, 0.5, 0.4, 0.3, 0.2], inf) * 2,
		amp: 1 / Prand([1.25, 1.5, 2], inf),
	])
).play
)

