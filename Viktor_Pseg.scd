// command + enter to play all

(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \kps,
		dur: 1 / Pdup(Pwhite(4, 11), Pwhite(3.0, 6.0)),
		amp: Pseg(Pwhite(0.0, 2.0), Pwhite(5.0, 10.0), \exp, inf), // interpolate smoothly between amp values exponentially over stochastic time values
		freq: Pseg([Pwhite(50,200).round(50)*Pwhite(1,3), Pwhite(50,200).round(50)*Pwhite(1,3), Pwhite(50,200).round(100)*Pwhite(1,3), Pwhite(50,200).round(100)*Pwhite(1,3)], [10, 5, 8], \exp, inf), // linear sequence of values interpolated to over a linear sequene of  times
		lpf: Pseg(Pexprand(20, 20000), 2.5, \exp, inf), // exponential choice of value with a single fixed time for every interpolaton
		sustain: Pseg(Pwhite(0.0,1.0),Pwhite(5.0, 10.0), \lin, inf),
		pan:Pmeanrand(0.0,1.0),
		stretch: Pkey(\dur)*1.2,
	])
).play;

Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \drm,
		amp: Pseed(0, Pseg(Pwhite(0.01, 1), Pwhite(5.0, 10.0), \exp, inf)), // interpolate smoothly between amp values
		dur: 1 / Pseg(Pwhite(2, 20), Pwhite(20, 40), \lin, inf), //exponentially over stochastic time values
		freq: Pseg([50, 100, 150, 100], [8, 5, 10], \exp, inf), // linear sequence of values interpolated to over a linear sequene of  times
		lpf: Pseg(Pexprand(20, 20000), 2.5, \exp, inf), // exponential choice of value with a single fixed time for every interpolaton
		//sustain: Pseg(Pwhite(0.0,1.0),Pwhite(5.0, 10.0), \lin, inf),
		pan:Pmeanrand(0.0,1.0),
	])
).play;


Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \fmx,
		rps: Pwhite(1,2),
		hr1: Pdup(Pkey(\rps) - Pwhite(0, 7), Pshuf((1 .. 4), inf)),
		hr2: Pdup(Pkey(\rps) + Pwhite(0, 7), Pshuf((1 .. 4), inf)),
		fdb: Pexprand(0.0001, 100.0),
		mi2: Pdup(Pkey(\rps) + Pwhite(0, 7), Pshuf((0.0001 .. 4.0), inf)),
		dur: Pwhite(6,8)/ Pseg(Pwhite(2.0, 4.0), Pwhite(2, 4), \lin, inf),
		amp: Pseed(0, Pseg(Pwhite(0.1, 1), Pwhite(5.0, 10.0), \exp, inf)),
		en1: Pdup(Pkey(\rps) + Pwhite(0, 7), Pexprand(0.0001, 0.555)),
		en2: Pdup(Pkey(\rps) + Pwhite(0, 7), Pkey(\en1) * Pexprand(0.2, 0.666)),
		en3: Pdup(Pkey(\rps) + Pwhite(0, 7), Pkey(\en1) * Pkey(\en2) / Pexprand(0.3, 0.777)),
		en4: Pdup(Pkey(\rps) + Pwhite(0, 7), Pkey(\en1) * Pkey(\en2) / Pkey(\en3) * Pexprand(0.4, 0.888)),
		cu1: Pdup(Pkey(\rps) + Pwhite(0, 7), Pwhite(0.25, 1.0)),
		cu2: Pdup(Pkey(\rps) + Pwhite(0, 7), Pwhite(0.25, 1.0)),
		cu3: Pdup(Pkey(\rps) + Pwhite(0, 7), Pwhite(0.25, 1.0)),
		cu4: Pdup(Pkey(\rps) + Pwhite(0, 7), Pwhite(0.25, 1.0)),
		dur: Pdup(Pkey(\rps) + Pwhite(2, 9), 2 / Pbrown(5, 19, Pwhite(1, 3), inf)),
		//legato: Pkey(1/\dur),
		freq: (Pdup(Pexprand(4, 32), 10 * Pexprand(1, 5).round)
			* Pdup(Pexprand(1, 64), Pexprand(1, 5)).round
			* Pdup(Pkey(\rps), Pexprand(1, 7).round)),
		cav: Pseg(Pexprand(0.25, 1.0), Pexprand(8.0, 64.0), \welch, inf),
		pan: Pbrown(0.0, 1.0, Pdup(Pwhite(1, 3), Pwhite(0.01, 0.1))).trace,
		stretch: Pkey(\dur)*Pwhite(1,2),
	])
).play
)

