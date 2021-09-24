
~clean.lsf("/Users/annawedin/Desktop/Viktor SC/SKHP/");
(
Pdef(0,
	Pseed(1,
		Pbind(*[
			type: \cln,
			snd: \saw,
			scale: Pdup(Pwhite(1,4), Pseq([
				Scale.harmonicMinor,
				Scale.minor.tuning,
				Scale.melodicMinor,
			], inf)),
			freq: Pdup(Pwhite(1,4),Pseq([Plprand(100, 500).round(50),
				Plprand(400, 500).round(25)],inf)-150),
			dur: Pdup(Pwhite(1,4), 1/Pwhite(5,10)),
			pan: Prand([Pwhite(0.0, 0.333), Pwhite(0.666, 1.0)]),
			amp: Pwhite(50,60),
			lpf: Pseq((20, 25 .. 200000), inf),
			legato: 20,
		])
	)
).play;

Pdef(2,
	Pseed(1,
		Pbind(*[
			type: \cln,
			snd: \fmx,
			scale: Pdup(Pwhite(1,4), Pseq([
				Scale.harmonicMinor.tuning_(Tuning.wcSJ),
				Scale.minor.tuning_(Tuning.sept1),
				Scale.melodicMinor.tuning_(Tuning.mean4),
			], inf)),
			freq: Pdup(Pwhite(1,4),Pseq([Plprand(100, 500).round(50),
				Plprand(400, 1400).round(50)],inf)),
			dur: 0.5/Pseed(2,Pwhite(1,5)),
			pan: Prand([Pwhite(0.0, 0.333), Pwhite(0.666, 1.0)]),
			amp: Pseq((200,300..2000),300),
			lpf: Pseq((20, 25 .. 200000), inf),
			sustain: Pexprand(0.5, 2.0),
		])
	)
).play;

Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \mmd,
		num: 1,
		dur: 0.4/Pdup(Prand([2,4],inf),Pseed(2,Pwhite(2,4))),
		scale: Pdup(Pwhite(1,4), Pseq([
			Scale.harmonicMinor.tuning_(Tuning.wcSJ),
			Scale.minor.tuning_(Tuning.sept1),
			Scale.melodicMinor.tuning_(Tuning.mean4),
		], inf)),
		freq: (Pkey(\dur)*700).round(50),
		amp: Pwhite(40,70)*2.5/Pkey(\dur),
		sustain: Pexprand(0.5, 1.0),
		legato: Pkey(\dur)/2,
		pan:Pmeanrand(0.0,1.0),
	])
).play;


);
