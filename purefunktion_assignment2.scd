TempoClock.default.tempo = 123/60;

// ... and then this in whatever order
// layers to put on/off
Pdef(\ondaflau).play(quant:1);
Pdef(\ondaflau).stop;

Pdef(\snare).play(quant:1);
Pdef(\snare).stop;

Pdef(\hatsnare).play(quant:1);
Pdef(\hatsnare).stop;

Pdef(\synten).play(quant:1);
Pdef(\synten).stop;

Pdef(\finiteState).play(quant:1);
Pdef(\finiteState).stop;

/// Run this first
(
// Kick
Pdef(\ondaflau,
	Pbind(*[
		type: \cln,
		snd: \drm,

		tun: 0.125,
		//dur: 1 / Pdup(Phprand(5, 11), Pwhite(3, 9)),
		//dur: 1 / Pseq([1], inf), // fau on da flau
		dur: Pbjorklund2(Pseq([3,2,3,2],inf),8)/4,
		amp: Pexprand(0.9,1.0),
		sustain: 0.9,
		//hal:0.89
		//fed: 1,
		//fzv: 1.2,//0,1,2
		//fuz: 1
	])
);


// snare...or, well something

Pdef(\snare,
	Pbind(*[
		type: \cln,
		snd: \drm,

		tun: 3.5,
		//dur: 1 / Pwrand([1,2,0.5], [9,1,1].normalizeSum, inf),
		dur: 1 / Pseq([0.5], inf),
		amp: Pexprand(0.80,0.85),
		//pew: 0.6,
		//fed: 0.5,
		sustain: 0.1,
		legato: 0,
		hpf: 400,
		smr: 0.5,
		//fzv: 5,//0,1,2
		fuz: 1
	])
);

// hihaty snareish
Pdef(\hatsnare,
	Pbind(*[
		type: \cln,
		snd: \hat,
		tun: 0.18,
		bnd: 0.8,
		sustain: 0.38,
		fuz: 1,
		dur: 1 / Pseq([2,2,4,4,2,2],inf),
		//dur: 1 / Pseq([1],inf), // straight 4
		amp: 0.35
	])
);

// fm synt with scale
b = Scale.sikah; // happi
//b = Scale.prometheus; //
Pdef(\synten,
	Pbind(*[
		type: \cln,
        snd: \fmx,
		degree: Pseq([5,3,11,3,6,7,5,3, \r, 1,3,3,5,5,6], inf),
		scale: Pfunc({b}, inf),
		//dur: 1 / Pseq([Prand([1,2,3,4,5,6], 2)]++(1.5!6), inf),
		dur: Pbjorklund2(Pseq([3,3,6,3,5],inf),8)/4,
		mil: Pexprand(0.1,0.9),
		hr4: Pexprand(0.1,0.99),
		hr3: Pexprand(0.1,0.99),
		hr2: Pexprand(0.1,0.99),
		hr1: 1,//Pexprand(0.4,0.9),
		mi4: Pexprand(0.1,0.99),
		mi3: Pexprand(0.5,0.99),
		mi2: Pexprand(0.5,0.99),
		en1: Pexprand(0.01,0.02),
		en2: Pexprand(0.01,0.05),
		en3: Pexprand(0.01,0.1),
		en4: Pexprand(0.01,0.1),
		cu1: Pexprand(0.001,0.05),
		cu2: Pexprand(0.001,0.1),
		cu3: Pexprand(0.001,0.1),
		cu4: Pexprand(0.01,0.1),
		det: 0.9,
		fdb: Pexprand(50,300.0),
		//amp: 1,
		//fuz: 1,
		fzv: 1.1,
		amp: 1.5,
		rev: 0.88,
		rin: 0.5,
		sustain: Prand([0.5,0.3,0.3,0.3],inf),

	])
);

)

/////////////////////////
//Finite State Machine
// testing the cln synths in a random fashion
(
Pdef(\finiteState,
Pfsm([
    #[0], // entry states

    //state 0
    Pbind(*[
		type: \cln,
		snd: \fmx,
		dur: Pbjorklund2(Pseq([3,3,3,5],inf),8)/4,
		midinote: Pseq([ 86, 75, 65 ]),
		amp: 1
	]),
    #[1],

	//state 1
    Pbind(*[
		type: \cln,
		snd: \add,
		dur: Pbjorklund2(Pseq([3,2,3,5],inf),8)/4,
		midinote: Pseq([ 86, 75, 65 ]),
		amp: 1
	]),
	#[1,0,2,3],

	// state 2
    Pbind(*[
		type: \cln,
		snd: \bow,
		dur: Pbjorklund2(Pseq([3,2,3,5],inf),8)/4,
		midinote: Pseq([ 86, 75, 65 ]),
		amp: 1
	]),
	#[1,0,2,3],

	// state 3
    Pbind(*[
		type: \cln,
		snd: \kps,
		dur: Pbjorklund2(Pseq([3,2,3,5],inf),8)/4,
		midinote: Pseq([ 86, 75, 65 ]),
		amp: 1
	]),
	#[1,0,3,4],

	// state 4
    Pbind(*[
		type: \cln,
		snd: \ixa,
		dur: Pbjorklund2(Pseq([3,2,3,5],inf),8)/4,
		midinote: Pseq([ 86, 75, 65 ]),
		amp: 1
	]),
	#[1,0,3,5],

	nil,nil
])
).play(quant:1 );
)



