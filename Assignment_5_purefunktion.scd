s.options.memSize = 8192 * 128;
(
s.waitForBoot {
	~clean = SuperClean(2, s); // Two output channels, increase if you want to pan across more channels.
	~clean.loadSoundFiles; // Hot swap in samples from anywhere!
	// for example: ~clean.loadSoundFiles("~/Downloads/rnb");
	s.sync; // Wait for samples to be read.
	~clean.start([0,0,0]); // First 8 out looks like [0,2,4,6]
	SuperClean.default = ~clean; // Make the clean key sequenceable inside of SuperCollider.
	"[ SuperClean up + running ]".postln;
};
)

//upset robots calming down

(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \add,
		rep: Pseg(Pseq([1/16, 1/8, 1/4, 1/7], 5),  Pseq([1,2,3,4], 2), \wel,2),
		freq: Pseg( Pseq([400, 1000], inf), Pseq([4,6,7,8,9,1,2],inf), Pseq([\exp, \lin],inf)),
		freq: Prand([[400, 1600, 500],[100,200,300], [1000,2000,3000]], inf), // comment this out for formant rip
		dur: Pkey(\rep), // trying key out
		ada: 0.0001,
		adr: 0.05,
		amp: 1,
		adc: 0.1,
		slw: 0.1,
		legato: 1.2,
		fsh: Prand([1,3,10,-3,-2], inf), // comment this out for formant rip
		fsm: Prand([1,3,-2], inf),
		stretch: Pseg([0.03, 2.6], 100, \wel, inf),
	])
).play(quant:1);
)