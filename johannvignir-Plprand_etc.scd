(
Pdef(0,
	Pseed(1,
		Pbind(*[
			type: \cln,
			snd: \dfd,
			dur: Pdup(2, Pseq([0.25, 0.50, 0.67, 0.75], inf)),
			scale: Pdup(4, Pseq([
				Scale.harmonicMinor.tuning_(Tuning.just),
				Scale.harmonicMinor.tuning_(Tuning.vallotti),
			], inf)),
			degree: Plprand(0, 6),
			atk: 0.01,
			hld: 0.01,
			rel: 2,
			dla: 0.7,
			dlt: Pkey(\dur, inf) * 6,
			dlf: Plprand(0.55, 0.94),
			legato: 99,
			pan: Pmeanrand(0.6, 1.0),

		]),
	)
).play;


Pdef(1,
	Pseed(1,
	Pbind(*[
		type: \cln,
		snd: \dfd,
		dur: Pdup(2, Pseq([0.25, 0.50, 0.67, 0.75], inf)),
		scale: Pdup(4, Pseq([
			Scale.harmonicMinor.tuning_(Tuning.just),
			Scale.harmonicMinor.tuning_(Tuning.vallotti),
		], inf)),
		degree: Plprand(0, 6),
		atk: 0.01,
		hld: 0.01,
		rel: 2,
		dla: 0.7,
		dlt: Pkey(\dur, inf) * 6,
		dlf: Plprand(0.55, 0.94),
		legato: 99,
		pan: Pmeanrand(0.0, 0.4),
		stretch: Pseed(1, Prand([1, 1.01], inf)),

	]),
	)
).play
)