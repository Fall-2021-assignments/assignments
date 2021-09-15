(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \mmd,
		num: Pseq((1, 2 .. 5),inf),
		dur: Prand([1/13, 1/16, 1/9, 1/10, 1/11],inf),
		amp: Prand([1/2, 0.8, 1, 0],inf),
		pan: Prand([0.3, 0.5, 0.7], inf),
		legato: 0.4,
		octave: 5,
		degree: Pwhite(1,14,inf),
		scale: Scale.nahawandDesc,
		dst: Pexprand(1, 2)-1,

	]),
).play
)
