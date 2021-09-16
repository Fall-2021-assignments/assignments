(
Pdef(1,
	Pseed(1,
		Pbind(*[
			type: \cln,
			snd: \dfd,
			freq: Pwhite(100, 200).round(25),
			amp: 1,
			rel: 20,
			legato: 20,
			stretch: Pseed(0, Prand([1, 1.01], inf)),
		])
	)
).play
)