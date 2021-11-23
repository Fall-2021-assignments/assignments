
(

~degree = Pseq([0, 2, 1, 3, 2, 4, 3, 5].mirror1, inf).asStream;
~scale = Pdup(Pexprand(8, 16), Pseq([

    Scale.neapolitanMinor.tuning_(\sept1),
].mirror1, inf)).asStream;
~pan = Pxrand((0.0, 0.025 .. 1).mirror1, inf).asStream;
~stretch = Pdup(Pexprand(0.1, 5), Pmeanrand(0.001, 5, inf)).asStream;
~octave = Pseg([1, 5, 6], Pseq([1,2], inf), \welch, inf).asStream;


Pdef(0,
	Pseed(11,

		Pbind(*[
        type: \cln,
        snd: \fmx,
		legato: Pfunc({~stretch}),
		amp: Pdup(Pexprand(1, 3), Pexprand(0.3, 0.6)),
		hr1: Pmeanrand(1.560, 1.570),
		hr2: Pmeanrand(1.559, 1.565),
		mi1: Plprand(1.0, 10.0),
		mi2: Plprand(1.0, 10.0),
		en1: Pseg([0.1, 0.025, 0.0], 100, \sine, inf),
		en2: Pseg([0.1, 0.025, 0.0], 100, \sine, inf),
		cu1: 1,
		cu2: Pseg([0.1, 0.025, 0.0], 100, \sine, inf),
		fuz: 0.5,
		degree: Pfunc({~degree}),
		octave: Pfunc({~octave}),
		scale: Pfunc({~scale}),
		stretch: Pfunc({~stretch}),
		//lpf: 5000,
		cav: 0.2,
		pan: Pfunc{(~pan)},


		    ])
).play(quant: 1);

Pdef(1,
    Pbind(*[
        type: \cln,
        snd: \fmx,
		legato: 1 + Pfunc({~stretch}),
		amp: Pdup(Pexprand(1, 4), Pexprand(0.3, 0.6)),
		hr1: Pmeanrand(1.560, 1.570),
		hr2: Pmeanrand(1.559, 1.565),
		mi1: 1,
		mi2: 9,
		en1: Pseg([0.1, 0.025, 0.0], 100, \sine, inf),
		en2: Pseg([0.1, 0.025, 0.0], 100, \sine, inf).trace,
		cu1: 1,
		cu2: 2,
		fuz: 0.1,
		degree: Pfunc({~degree}),
		octave: Pfunc({~octave}),
		scale: Pfunc({~scale}),
		stretch: Pfunc({~stretch}),
		dla: 0.3,
		dlf: 0.5,
		dlt: Pfunc({~octave}),
		//lpf: 5000,
		cav: 0.1,
		pan: Pfunc{(~pan)},



		    ])
).play(quant: 1);
)
)