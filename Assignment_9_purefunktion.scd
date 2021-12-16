// 4 on da floor

(
Pdef(0,
	Pbind(*[
		type: Pwrand2([\cln, \r], [10,1], inf),
		dur: 1 / Pwrand2([4, 8], [1, 4], inf),
		snd: \hat,
		aux: 0,
		amp: 0.4,
	])
).play(quant:1);
)

(
Pdef(1,
	Pbind(*[
		type: \cln,
		dur: 1/8,
		snd: \drm,
		amp: Pseq ([1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0], inf), // doesn't have to be static values
		aux: 2
	])
).play(quant:1);
)

(
Pdef(\bass,
	Pbind(*[
		type: \cln,
		dur: 1/8,
		dur: 1 / Pseq([4,4,4,8,8,8,8,4,2], inf),
		scale: Scale.melodicMinor.tuning_(Tuning.just),
		degree: Place(#[2, [2,3], 4, [8, 6, 9], [8, 5, 13], [8, 4, 12], [8, 3, 15], 4 ,2 ], inf),
		//degree: Pseq([2,2,4,8,8,8,8,4,2], inf),
		octave: 3,
		//octave: Plprand(2, 3),
		snd: \saw,
		amp: 1,
		legato: 2,
		sustain: 1,
		tnh: 0.5,
		tng: 5,
		aux: 7
	])
).play(quant: 1);
)


(
Pdef(\stratos,
	Pbind(*[
		type: \cln,
		snd: \ixa,
		freq: Pexprand(70,400, inf),
		dur: Pseq([8], inf),
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
		hal: 10,
		amp: 0.5,
		pan: Pexprand(0.2,0.8,inf),
		aux: 8
	])
)
)

Pdef(\stratos).play(quant:1);
Pdef(\stratos).stop;

Pdef(0).stop;
Pdef(1).stop;
Pdef(1).play;
Pdef(0).play;

Scale.directory;


























