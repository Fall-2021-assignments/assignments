(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \tpr,
		num: Pseq([ 01, 01 ]),
		amp: Prand([0.5, 0.75, 0.5, 0.75], inf),
		dur: 1 / Prand([ 1 ], inf),
		Legato: 0.5,
		atk: 5 / Prand([9], inf),
		rel: 5,
		hld: 10,
		dst: 5 * Prand([2], inf),
		hal: 1



	])
).play
)