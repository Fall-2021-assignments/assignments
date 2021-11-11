(
Pdef(0,
	Pbind(*[
		type: Pwrand([\cln, \rest], [1, 6].normalizeSum, inf),
		type: \cln,
		snd: \kps,
		degree: Pseq([Pseq([3,4],2) + Phprand(-2,0,inf), 6],inf),
		scale: Pwrand([Scale.majorPentatonic, Scale.minorPentatonic], [1,2].normaliseSum, inf),
		dur: 1 / Pbrown(5, 11),
		dur: Pseq([1, 1, 1, 2, 3],inf)/16,
		octave: 5,
		pan: Pseg(Pwhite(0.0, 1.0), 10, \sin, inf), // stochastic interpolation between points in a multichannel ring
		rel: Pwhite(1, 11, inf),
		sustain: Pwhite(1, 5, inf),
		amp: Pexprand(0.0001, 0.1, inf),
	])
).play;
)