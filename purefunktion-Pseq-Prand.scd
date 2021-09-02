

(
Pdef(\stratos,
	Pbind(*[
		type: \cln,
		snd: \ixa,
		freq: Pexprand(70,400, inf),
		dur: Pseq([1,2,4,5,6,7,2,1], inf),
		bes: Prand([1, 4, 7, 20], inf),
		ber: Prand([1, 2, 4, 5, 15, 20], inf),
		abs: Prand([1, 2, 4, 5, 15, 20], inf),
		abr: Prand([1, 2, 4, 5, 15, 20], inf),
		bnd: Prand([0, 3,5,6,7], inf),
		bnt: Prand([0,2,5, 6, 7], inf),
		fdb: Pexprand(0.0001,100.0),
		sustain: Pexprand(2.5,5.0, inf),
		legato: Pkey(\dur)*Pexprand(16,64),
		atk: Pexprand(0.01,4.0),
		hld: Pkey(\dur)*2,
		rel: Pkey(\dur)*2,
		rts: 6,
		hal: 100,
		pan: Pexprand(0.2,0.8,inf);
	])
)
)

Pdef(\stratos).play;
Pdef(\stratos).stop;

