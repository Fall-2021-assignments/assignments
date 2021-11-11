
(
~totalTime = 20;
~bigAmp = Pseg([0,1,0],[Pfunc{~totalTime}/2,Pfunc{~totalTime}/2],\wel,inf);
~dur0 = 1;
~dur1 = 1;
);

(
(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \kps,
		dur: 1 / Pseq((1,2 .. 100).mirror, inf),
		degree: Pwhite(4,10),
		scale: Scale.bartok,
		stretch: Pseg([1,5,1],[Pfunc{~totalTime}/2,Pfunc{~totalTime}/2],\lin,1),
		mod1: Pseg([0, 1, 0], Pkey(\dur), \exp, inf),
		amp: Pseg([0,1,0],[Pfunc{~totalTime}/2,Pfunc{~totalTime}/2],\wel,inf),
		pan: Pmeanrand(0.0, 1.0),
		tnh: 0.3,
		tng: 0.01,
		aux: 0,
		pan: Pwrand([1,0,1],[2,1,2],inf),
		fdb: Pexprand(1.0, 50.0),
	])
).play;


Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \drm,
		dur: Pseq([0.1, 0.5, 0.7].mirror,inf)*Pwhite(0.9,1.6),
		degree: Pseq([[Pwhite(50,60), 45, Pwhite(50,60)], [Pwhite(50,60), 45, Pwhite(50,60)], [Pwhite(50,60), 45, Pwhite(50,60)]],inf),
		//mod1: Pseg([0, 1, 0], Pkey(\dur), \exp, inf),
		stretch: Pseg([1,5,1],[5,5],\lin,inf),
		tun: Pseq([1, 1, 1],inf)*9*Pwhite(0.9,1.1),
		legato: 1/Pkey(\dur),
		//scale: Scale.bartok,
		amp: Pseg([0.01,0.21,0.21,0.01],[5,5,5],\wel,15),
		//lpf: Pseg([20,2000,5000,15000],[5,5,5],\wel,15),
		aux: 1,
		pan: Pwrand([1,0,1],[2,1,2],inf),
	])
).play(quant:1);

)
)

(
Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \rec, //you might have to change this name to the folder where your sample is located
		num: 1,
		bgn: Pwhite(0.0, 1.0),
		legato:0.1,
		dur: 4 / Pwhite(2, 11),
		amp: Pseg([0.01,1,1,0.1],[5,5,2],\wel,inf),
		spd: Pseg([8,0.4,8],[15,50],\wel,inf),
		lpf: Pseg([2000,10000,20000,150],[5,5,30],\wel,5),
		cav:0.01,
		pan: Pseg([0,1,1,0],[5,5,5],\lin,inf),
		bnd: Pwhite(-4.0,0),
		bnt: Pwhite(2,1),
		sustain: 4,
	])
).play(quant:1);
)

/*
Pdef(1,
Pbind(*[
type: \cln,
snd: \drm,
dur:Rest(4),
multiply: Pseg([1, 100, 1], [Pfunc{~totalTime}/2,Pfunc{~totalTime}/2], \lin, inf),
//degree: Pseg([0, 0.02, 0], 0.001, \sin, inf) + Pseq([[0, 1], [5, 7], [0, 1], [5, 7], [0, 1], [-1, 2]],inf),
//scale: Scale.minor(\just),
dur: 1 / Pkey(\multiply),
mod1: Pseg([0, 1, 0], Pkey(\dur), \exp, inf),
//amp: Pseg([0,0,1, 0], [Pfunc{~totalTime}/2, Pfunc{~totalTime}/2, Pfunc{~totalTime}/2], \wel, inf),
amp: Rest(Pfunc{~totalTime}/2),
amp: Pseg([1,1,1],[Pfunc{~totalTime}/2,Pfunc{~totalTime}/2],\wel,inf).postln,
//cav: 0.1,
pan: Pmeanrand(0.0, 1.0),
// utility: Pfunc{ arg event; event.dur.postln },
calculate: Pfunc{ arg event; ~dur0 = event.dur },
tnh: 0.3,
tng: 0.01,
aux: 0,
])).play;*/


)