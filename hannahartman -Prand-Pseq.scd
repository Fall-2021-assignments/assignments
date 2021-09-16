(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \drm,
		dur: 1 / Prand([1, 2, 4], inf),
		pan: Pseq([0.5, 1.0, 0.5, 0.0], inf),
	])
).play
)
