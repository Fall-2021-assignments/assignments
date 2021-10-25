s.record

~clean.lsf("/Users/annawedin/Desktop/Viktor SC/rec/") //load the sound file of the recording

//this first pattern makes a sample that is used in the code. I made a recording that you can find here:https://github.com/NJVD91/Supercollider_stuff/blob/main/SC_211017_003051.wav but you could just as well make your own.
(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \fmx,
		dur: 1/10000*Pseq((1..7),10),
		freq: (Pseg([30,50,40],[4,4],\lin,inf) * (Pseq((1..100)++(100..1),inf))).round(100), // one to a hundred, wired
		amp: Pseg([0.3,0.5,0.5],[5,5],\wel,40),
		stretch: Pseg([0.5,4],[10],\lin,1),
	])
).play(quant:1);
)

//the following bit make sound
(
Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \drm,
		dur: Pwhite(0.9,1.1)*1/(1*Pseq((2..8),inf)),
		stretch: Pseg([0.5,0.2,5,0.5],[5,5,5],\lin,inf),
		tun: Pseg([0.01,10],[160],\lin,1)/Pseq((0 ,0.1 .. 2), inf),
		amp: Pseg([0.01,0.21,0.21,0.01],[5,5,5],\wel,15),
		lpf: Pseg([20,2000,5000,15000],[5,5,5],\wel,15),
		
	])
).play(quant:1);


Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \fmx,
		dur: 1/(Pwhite(1,4)),
		legato:1,
		pan: Pwhite(0.0, 1.0),
		degree: Pseq((0 .. 7), inf)*Pwhite(1,4),
		stepsPerOctave: Pwhite(1, 12),
		stretch: Pseg([1,5,0.1,0.5],[15,15],\wel,inf),
		amp: Pseg([0.01,0.51,0.51,0.01],[5,5,5],\wel,15),
		bpf: Pseg([20,2000,5000,15000],[10,10,10],\wel,inf),
		sustain:3,
	])
).play(quant:1);



Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \rec, //you might have to change this name to the folder where your sample is located
		bgn: Pwhite(0.0, 1.0),
		legato:0.1,
		dur: 4 / Pwhite(2, 11),
		amp: Pseg([0.01,1,1,0.1],[5,5,2],\wel,inf),
		spd: Pseg([8,0.4,8],[15,50],\wel,inf),
		lpf: Pseg([2000,10000,20000,150],[5,5,30],\wel,5),
		//cav:0.1,
		pan: Pseg([0,1,1,0],[5,5,5],\lin,inf),
		bnd: Pwhite(-4.0,4.0),
		bnt:	Pwhite(1,3),
		sustain: 4,
	])
).play(quant:1);
)



