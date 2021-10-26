(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \dfd,
		dur: 1.2 / Pdup(Pwhite(1, 80), Pwhite(5, 11)) / 2,
		amp: Pseg(Pwhite(1.0, 18.0), Pwhite(5.0, 40.0), \exp, inf).trace,
		freq: Pseg([100, 400, 40, 600, 50], [4, 2, 5, 30], \exp, inf),
		pan: Pdup(Pwhite(0, 50), Pwrand([Pwhite(1.0, 0.400), Pwhite(0.506, 1.0)],   [1, 1.5].normalizeSum, inf)),
		lpf: Pseg(Pexprand(20, 20000), 1.5, \exp, inf),
		sustain: 8,
		legato: 2,
		dst: 0.75,
		cav: 1,
	])
).play;



Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \dfd,
		dur: 2.2 / Pdup(Pwhite(1, 111), Pwhite(3, 8)) / 4,
		amp: Pseg(Pwhite(0.0, 8.0), Pwhite(2.0, 10.0), \exp, inf).trace,
		freq: Pseg([300, 200, 100, 200, 300, 400], [10, 5, 8], \exp, inf),
		lpf: Pseg(Pexprand(20, 20000), 4.5, \exp, inf),
		sustain: 1,
		fuz:2.12,
	])
).play
)