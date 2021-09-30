(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \saw,
		//freq: Plprand(100, 1000).round(100),
		freq: [50, 50,0100,30]* Pwhite(1, 5) / 5,
		dur: 1 / Pwhite(5, 11),
		pan: Pmeanrand(0.0, 1.0),
		amp: Pexprand(0.5, 7.0),
		lpf: Plprand(20, 20000),
		rel: 20,
		legato: 10,
		])
).play
)