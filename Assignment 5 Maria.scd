(
Pdef(0,
    Pbind(*[
        type: \cln,
        snd: \dfd,
        dur: 1/3,
        amp: Pseq([5/8, 6/8, 7/8, 1], inf),
		legato: 4,
        freq: 45 * Pdup(6, Pseq([1, 2, 3, 4], inf)),
    ])
).play(quant:1);



Pdef(1,
    Pbind(*[
        type: \cln,
        snd: \fmx,
        dur: 1/7,
        amp: Prand([5/8, 6/8, 7/8, 1], inf),
		pan: Pdup(Pwhite(0, 300), Pwrand([Pwhite(1.0, 0.400), Pwhite(0.506, 1.0)], [1, 1.5].normalizeSum, inf)),
		dst: 0.3,
		bnd: Pwhite(-0.1739416203724519, 0.1739416203724519),
        freq: 45 * Pwhite(6, Pseq([1,4,2,5.7, 6, 4.7], inf)),
    ])
).play(quant:1);



Pdef(2,
    Pbind(*[
        type: \cln,
        snd: \fmx,
		rps: Pexprand(9, 40),

			hr1: Pexprand(Pkey(\rps) - Pwhite(0, 7), Pshuf((1 .. 7), inf)),
		hr2: Pdup(Pkey(\rps, \dfd) + Pwhite(0, 7), Pshuf((1 .. 7), inf)),
        //dur: 1/2,
		cu4: Pdup(Pkey(\rps) + Pwhite(0, 7), Pwhite(0.25, 1.0)),
			dur: Pdup(Pkey(\rps) + Pwhite(2, 9), 2 / Pbrown(5, 19, Pwhite(1, 3), inf)),
			legato: Pkey(\dur) * Pexprand(16, 64),

		sustain: Pexprand(2.5, 4.0, inf),
		crv: 7,
		])
).play(quant:1);
)








