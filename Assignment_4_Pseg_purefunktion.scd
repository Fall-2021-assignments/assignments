TempoClock.default.tempo = 120/60;
(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: Prand([\kps, \add, \saw], inf),
		dur: 1 / Pseq([4,2,8,8,8,8,8,4,4,4,4], inf),
		freq: Pseg( Pseq([400, 1000], inf), Pseq([4,6,7,8,9,1,0.2],inf), Pseq([\exp, \lin],inf)),
		//lpf: Pseg(Pexprand(200, 2000), 0.5, \exp, inf),
		ada: Pexprand(0.1,10.1),
		adr: Pexprand(0.01,10.0),
		//dur: Prand([16, 32], inf) / Pwrand([1, 2, 4, 8],[8, 4, 2, 1].normalizeSum, inf),
		amp: Pexprand(0.5,0.8),
		legato: 1,
		hal: Pexprand(0.5,0.8),
		bnd: Pexprand(0.5,0.8),
		bnt: Pexprand(0.5,0.8),

		fsm: 4
	])
).play(quant:1);
)

(
// Kick
Pdef(\ondaflau,
	Pbind(*[
		type: \cln,
		snd: \drm,
		tun: 0.425,
		dur: 1 / Pseq([1], inf), // fau on da flau
		amp: Pexprand(0.9,1.0),
		sustain: 0.9,
	])
).play(quant:1);
)