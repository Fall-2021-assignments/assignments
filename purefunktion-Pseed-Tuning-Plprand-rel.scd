(
Pdef(0,
	Pseed(4,
		Pbind(*[
			type: \cln,
			snd: \fmx,
			scale: Pdup(99, Pseq([
				Scale.ritusen.tuning_(Tuning.just),
				Scale.pelog.tuning_(Tuning.sept1),
				Scale.todi.tuning_(Tuning.mean4),
			], inf)),
			degree: Plprand(0, 7),
			octave: Plprand(3, 6),
			dur: 1 / Pwhite(2, 8),
			lpf: Plprand(20, 2000),
			//pan: Pmeanrand(0.0, 1.0),
			amp: Pexprand(0.5, 1.0),
			rel: 10,
			legato: 10,
			stretch: Pseed(2 ,Pseq([2.01, 1, 0.5])),
		])
	)
).play
)

Scale.directory;
Tuning.directory;