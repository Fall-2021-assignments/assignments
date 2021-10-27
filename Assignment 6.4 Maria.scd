(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \dfd,
		dur: 1.0 / Pdup(Pwhite(1, 80), Pwhite(5, 11)) / 2,
		amp: Pseg(Pwhite(1.0, 18.0), Pwhite(5.0, 30.0), \exp, inf).trace,
		freq: Pseg([100, 400, 220, 180, 560, 590, 350, 50], [4, 2, 5, 3], \exp, inf),
		pan: Pdup(Pwhite(0, 1), Pwrand([Pwhite(1.0, 0.400), Pwhite(0.506, 1.0)],   [1, 1.5].normalizeSum, inf)),
		lpf: Pseg(Pexprand(20, 20000), 1.5, \exp, inf),
		sustain: 8,
		legato: 4,
		dst: 0.55,
		cav: 2,

	])
).play;


Pdef(1,
    Pbind(*[
        type: \cln,
        snd: \sin,
        dur: 1/3,
        amp: Pseq([5/8, 6/8, 7/8, 1], inf),
		legato: 4,
        freq: 35 * Pdup(6, Pseq([1, 2, 3, 4,7 ], inf)),
		stretch: Pseg([0.8, 1.2], 10, \lin, inf),

    ])
).play(quant:1);



Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \dfd,
		dur: 2.2 / Pdup(Pwhite(1, 111), Pwhite(3, 8)) / 4,
		amp: Pseg(Pwhite(0.0, 8.0), Pwhite(2.0, 10.0), \exp, inf).trace,
		freq: Pseg([40, 300, 220, 100, 40, 280, 35, 400], [2, 5, 3, 8], \exp, inf),
		lpf: Pseg(Pexprand(20, 20000), 4.5, \exp, inf),
		aux: 5,
		sustain: 2,
		fuz:2.12,
	])
).play
)