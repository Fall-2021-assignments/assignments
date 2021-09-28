(
Pdef(0,
	Pseed(2,
		Pbind(*[
			type: \cln,
			snd: \dfd,
			dur: 1/Pwhite(2,5, inf),
			rel: Prand([12,3,4], inf),
			atk: 2,
			octave: 4,
			degree: Pseq([1, 1, 3, 4, 1, 3, 4, 5, 5, 7, 8, 7, 5, 7, 8, 5],inf),
			scale: Scale.rast,
			sustain: Prand([1, 3, 5, 7], inf),
			legato: Prand([3, 5, 7, 11], inf),
			lpf: Plprand(20, 20000),
			amp: Pmeanrand(0.8, 1.1),
			pan: Pwhite(0.4,0.8,inf),
	])
	)
).play
)