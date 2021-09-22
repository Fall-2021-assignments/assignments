
~clean.lsf("/Users/annawedin/Desktop/Viktor SC/SKHP/");
(
Pdef(0,
	Pseed(1,
		Pbind(*[
			type: \cln,
			snd: \fmx,
			scale: Pdup(Pwhite(1,4), Pseq([
				Scale.harmonicMinor.tuning_(Tuning.wcSJ),
				Scale.minor.tuning_(Tuning.sept1),
				Scale.melodicMinor.tuning_(Tuning.mean4),
			], inf).trace),
			freq: Pdup(Pwhite(1,4),Pseq([Plprand(100, 1000).round(50),
				Plprand(100, 1000).round(50)],inf)),
			dur: 1/Pwhite(1,10),
			pan: Prand([Pwhite(0.0, 0.333), Pwhite(0.666, 1.0)]),
			amp: Pseq((200,300..2000),300),
			lpf: Pseq((20, 25 .. 200000), inf),
		])
	)
).play;

Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \mmd,
		num: 1,
		dur: 1 / Pwhite(5, 11),
		amp: Pseed(1,0.1*Pseq((200,300..2000),300)),

	])
).play;


);