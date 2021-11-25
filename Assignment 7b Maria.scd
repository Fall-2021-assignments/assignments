(
~degree = Pseq((0 .. 7).mirror1, inf).asStream;
~octave = Pseq((4 .. 7).mirror1, inf).asStream;
~mtranspose = Pseq((0 .. 4).mirror1, inf).asStream;
~scale = Pdup(Pexprand(7, 9), Pseq([
    Scale.aeolian.tuning_(Tuning.sept1),
    Scale.locrian.tuning_(Tuning.sept1),
    Scale.mixolydian.tuning_(Tuning.sept1),
].mirror1, inf)).asStream;
~pan = Pseq((0.0, 0.055 .. 1).mirror2, inf).asStream;
~stretch = Pdup(Pexprand(1, 7), Pmeanrand(0.01, 8, inf)).asStream;
Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \dfd,
		legato: Pfunc({~stretch}),
		scale: Pfunc({~scale}),
		octave: Pfunc({~octave}),
        degree: Pfunc({~degree}),
		pan: Pfunc({~pan}),
        mtranspose: Pfunc({~mtranspose}),
		sustain: 5,
		dur: 1/6,
		//legato: 20,
		pan: Pdup(Pwhite(0, 50), Pwrand([Pwhite(1.0, 0.400), Pwhite(0.506, 1.0)], [1, 1.5].normalizeSum, inf)),
		cai: Pdup(Pwrand([1, 21], [1, 9].normalizeSum, inf), Pwhite(0.0, 1.0)),
		//tun: Pwrand([1, 20, 4, 8], [8, 44, 2, 1].normalizeSum, inf),
		//tun: Pwrand([1, 3, 7, 6], [0.125, 0.25, 0.5, 2.0, 0.125], inf),
		fed: Pdup(80, Pwhite(0.0, 3.5)),
		sho: Pwhite(0.0, 20.0),
		bnd: Pwhite(-0.032258054516129, 1.142258064516129),
		pew: Pdup(Pwhite(1, 9), Pseq((0.0, 0.1 .. 1.0), inf)),
		dst: 0.63,
		amp: 1.0,

	])
).play
)