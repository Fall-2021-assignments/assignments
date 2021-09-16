// Pwrand Pdup Pwhite and more assignment
//
// Load sound files: https://github.com/NJVD91/Supercollider_stuff/tree/main/SKHP
//start rythm by activating the first Pdef. Activate more Pdefs as you get bored



~clean.lsf("/Users/annawedin/Desktop/Viktor SC/SKHP/");

(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \SKHP,
		num: Pwrand([Pseq([0,0,0,1,0,0,1,0,0,0,0,1,0,0,1,0],1),Pseq([0,0,0,1,1,0,1,0,0,0,0,1,1,0,1,0],1)],[0.9,0.5].normalizeSum, inf),
		amp: Pseq([1,0,0,1,1,0,1,0,1,0,0,1,1,0,1,0],inf),
		dur: 1/5.5,
		mir: 100,
		octave: Pwrand([5, 5, 4, 2], [8, 4, 2, 1].normalizeSum, inf),
		//pew: Pdup(Pwhite(1, 9), Pseq((0.0, 0.1 .. 1.0), inf)),
		//dst: 1,
		//fuz: Pkey(\tun),
		pan:Pmeanrand(0.0,1.0),
	])
).play(quant:1);
)

(
Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \saw,
		dur: Pdup(Pwhite(1, 4), Pwhite(0.2,0.1)),
		//tun: Pwrand([100, 220, 400, 800], [1, 2, 4, 8].normalizeSum, inf),
		scale: Scale.major,
		iph: Pwhite(0,1),
		wid: Pkey(\iph),
		midinote: Pdup(8, Pwhite(77,82))+ Pwrand([2,4,6,8],[5,1,2,1],inf),
		slo: 0.8,
		mir: 100,
		bno: Pwhite(0.01,1),	//Offset the time at which the bend begins.
		bnc: Pwhite(-1 , 1), //Bend curvature. Accepts positive and negative values.
		rdf: Pwhite(20,200),	//The ringmodulation frequency to glissando in from, which can be above or below rmf, range is 20 to 20000
		crv: Pwrand([1,1,3,4],[1,2,3,1].normalizeSum, inf),
		amp: Pseq((0.1,0.2..0.6)++(0.6 , 0.5..0.1),inf),
		//crv: Pdup(4,Pwrand(Pseq(0, 0.1 .. 8),[0 , 0.1 .. 8].normalizeSum,inf)),	//Envelope curvature, swings both ways. That is to say it uses both positive and negative values, try values between -8 to 8
	])

).stop(quant:1);
)

(
Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \kps,
		amp: Pexprand(0.7, 1.0),
		midinote: Pdup(8, Pwhite(35,30))+ Pwrand([2,4,6,8],[5,1,2,1],inf),
		dur: Pexprand(0.5,2),
		sustain: Pexprand(0.5, 4.0),
	//	hpf: Pexprand(20, 20000),
		lpf: (20000 - Pexprand(20, 20000)),
		pan: Pwhite(0.0, 1.0),
	])
).play(quant:1);
)

(
Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \ixa,
		scale: Scale.major,
		iph: Pwhite(0,3),
		wid: 9,
		rel: 3,
		midinote: 30,
		dur: 0.76*4,
	//	iph: Pkey(\wid)*2,
		bnd: Pkey(\iph),
		bnt:Pkey(\iph),
		bno:Pkey(\iph),
		bnc: Pkey(\iph),
		amp: Pseq((0.3, 0.4 .. 1.20)++(1.20 , 1.10..0.3), inf),
	])

).play(quant:1);
)






// (
// Pdef(1,
// 	Pbind(*[
// 		type: \cln,
// 		snd: \mmd,
// 		num: Pwrand([9,13,16], [6,1,3].normalizeSum,inf),
// 		dur: Pdup(Pwhite(1, 3), Pwhite(0.3,0.4)),
// 		bno: Pwhite(0.01,1),	//Offset the time at which the bend begins.
// 		bnc: Pwhite(-1 , 1), //Bend curvature. Accepts positive and negative values.,
// 		mir: 10,
// 		tun: Pwrand([1, 2, 4, 8], [8, 4, 2, 1].normalizeSum, inf),
// 		//tun: Pwrand([1, 2, 4, 8], [0.125, 0.25, 0.5, 0.125], inf),
// 		fed: Pdup(8, Pwhite(0.0, 3.5)),
// 		octave: Pwrand([1, 2, 4, 6], [8, 4, 2, 1].normalizeSum, inf),
// 		//pew: Pdup(Pwhite(1, 9), Pseq((0.0, 0.1 .. 1.0), inf)),
// 		//dst: 1,
// 		fuz: Pkey(\tun),
// 		amp: 1,
// 	])
// ).stop(quant:1);
// )


/*(
Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \SKHP,
		num: Pseq([0,0,0,2.0,0,0,2.0,0,0,0,0,2.0,0,0,2.0,0],inf),
		amp: Pseq([0,0,0,0.5,0,0,0.5,0,0,0,0,0.5,0,0,0.5,0],inf),
		dur: 0.76/4,
		bno: Pwhite(0.01,1),	//Offset the time at which the bend begins.
		bnc: Pwhite(-1 , 1), //Bend curvature. Accepts positive and negative values.,
		mir: 10,
		tun: Pwrand([1, 2, 4, 8], [8, 4, 2, 1].normalizeSum, inf),
		//tun: Pwrand([1, 2, 4, 8], [0.125, 0.25, 0.5, 0.125], inf),
		//fed: Pdup(8, Pwhite(0.0, 3.5)),
		//octave: Pwrand([5, 2, 4, 6], [8, 4, 2, 1].normalizeSum, inf),
		//pew: Pdup(Pwhite(1, 9), Pseq((0.0, 0.1 .. 1.0), inf)),
		//dst: 1,
		//fuz: Pkey(\tun),
	])
).stop(quant:3);
)*/
