(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \drm,
		dur: 1 / Pwrand([1, 2, 4],[1, 2, 4]. normalizeSum, inf),
		pan: Pseq([0.5, 1.0, 0.5, 0.0], inf),
		amp:Pdup(Pwhite(1, 10), Pwhite(0.0, 1.0)),
	])
).play
)
