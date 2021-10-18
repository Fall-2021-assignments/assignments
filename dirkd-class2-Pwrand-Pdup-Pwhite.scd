/* assignment from september 2nd
dirk dullmaier

goals:
1. see if i can insert my own synthdef into clean
2. 2 pdefs with different voices, can parameters interact between them?
3. use all the words

feels a bit unfinished, but i didn't have any more time
*/

//TODO experiment with the more in-depth communication between streams
//TODO calculate, if the "pseed-synchronization" does happen at the right times

//setting up synthdefs, adding them to clean, set seed number

(
~seedN = 13;

/*inspired by boris code i wanted to get custom synthdefs into clean,
the ones i used are stolen & modified sound design examples working
with different types of noise*/

//static-y, flowing noise
SynthDef(\synthi, {
	arg in, out, amp = 0.5, pan = 0.5, gate = 1, freq = 0,
	atk = 0.09, hld = 0.4, rel = 0.9, crv = 4;
	var trg, sig;
	var env = EnvGen.kr(Env.asr(atk, hld, rel, crv), gate, doneAction: 2);
	10.collect{
		trg = Dust.kr(170);
		freq = freq + TExpRand.kr(800, 2000, trg)
		+ LFNoise1.kr(20, 200) + EnvGen.kr(Env.perc(1).range(0, 20), trg);
		sig = SinOsc.ar(freq, 0, 0.3) + Dust.ar(SinOsc.kr(440).range(30, 120));
		sig = sig * env;
		sig = CleanPan.ar(sig, ~clean.numChannels, pan);
		Out.ar(out, sig);
	}.mean
}).store;

//grimey noise that has some swells and sudden events
SynthDef(\noisier, {
	arg in, out, amp = 0.3, pan = 0.5, gate = 1,
	atk = 0.1, hld = 0.5, rel = 0.5, crv = 1;
	var sig, env1, env2;
	env1 = EnvGen.kr(Env.asr(atk, hld, rel, crv), gate, doneAction: 2);
	env2 = EnvGen.kr(Env.perc(atk, rel, amp, crv), gate, doneAction: 2);
	sig = HPF.ar(
		PinkNoise.ar(0.08 + LFNoise1.kr(0.3, 0.02))
		+ LPF.ar(Dust2.ar(LFNoise1.kr(0.2).range(40, 50)), 7000), 400) * env1
	+ LPF.ar(10 * HPF.ar(PinkNoise.ar(LFNoise1.kr(3).clip(0, 1)
		* LFNoise1.kr(2).clip(0, 1) ** 1.8), 20),
	LFNoise1.kr(1).exprange(100, 2500)).tanh * env2;
	sig = CleanPan.ar(sig, ~clean.numChannels, pan);
	Out.ar(out, sig);
}).store;

//taken from boris
~clean.soundLibrary.addSynth(\synthi,
	(
		instrument: \synthi,
		in: {
			//i don't completely understand this part, maybe ask about it next time
			~clean.audioRoutingBusses.wrapAt(~from ? 0).index
		}
	)
);

~clean.soundLibrary.addSynth(\noisier,
	(
		instrument: \noisier,
		in: {
			~clean.audioRoutingBusses.wrapAt(~from ? 0).index
		}
	)
);
);

//the actual patterns
(
(Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \synthi,
		degree: Pseq([0, 3, 5, 6],inf),
		amp: 0.02 + Pseq((0.001, 0.002 .. 0.1)++(0.1, 0.099 .. 0.001),inf) + Pwhite(0.0001, 0.0009),
		lpf: 15000 - Pwhite(0, 2000),
		dur: 10,
		lpq: 0.4,
		pan: [0.48, 0.49, 0.5, 0.51, 0.52] + Pwhite(0.1, 0.2),
		tnh: 0.1,
		smr: Pwhite(0.8,0.9),
		scm: 0.2,
		legato: 2,
	]),
).play
);

(Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \noisier,
		amp: 0.5 + Pwhite(0.01, 0.06),
		pan: [0.3, 0.7] + Pwhite(0.1, 0.2),
		dla: 0.4,
		dlt: 1/2,
	]),
).play
);

(Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \sin,
		//supposedly the seed trick from daniel
		scale: Pseed(~seedN, Pwrand([Scale.superLocrian, Scale.mixolydian], [20,2].normalizeSum, inf)),
		degree: Pwrand([[3, 5], [6, 8] , [2, 4], [7, 10] , [8, 12] , [2, 9]], [9, 4, 3, 1, 1, 2].normalizeSum, inf),
		mtranspose: Pwrand([Pseq([0, 2]), Pseq([0, 0, 1]), Pseq([0, 10])], [20, 4, 2], inf),
		dur: Pdup(14, Pwrand([1/4, 1/8], [10,1].normalizeSum, inf)),
		lpf: 20000 - Pwhite(2000, 8000),
		lpq: Pwrand([0.5, 0.4, 0.3, 0.2], [1, 2, 3, 5].normalizeSum, inf),
		dla: 0.5,
		dlf: 0.7 + Pwhite(0.01, 0.08),
		dlt: 2 * Pkey(\dur),
		hal: 0.4,
		//my silly take on a slow fade-in, i guess there are better ways to do this
		amp: Pseq([Pseq((0.01, 0.02 .. 0.4)),Pseq([0.4 + Pwhite(0.01, 0.1)],inf)]),
		legato: 2,
	]),
).play
);

(Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \hat,
		bnd: 0.1,
		rel: 0.1,
		//another different fade-in
		amp: Pseq([Pseq((0.01, 0.02 .. 0.3)),Pseq([0.4 + Pwhite(0.01, 0.1)],inf)]),
		dur: Pdup(28,Pwrand([7,1/16], [20,4].normalizeSum, inf)),
		legato: 3,
	]),
).play
);

(Pdef(4,
	Pbind(*[
		type: Pseq([Pdup(42, Pseq([\r])),Pdup(14, Prand([\cln,\r],inf))]),
		snd: \fmx,
		//same seed here, same pwrand
		scale: Pseed(~seedN, Pwrand([Scale.superLocrian, Scale.mixolydian], [20,2].normalizeSum, inf)),
		degree: Pseq([10,14,21],inf),
		mtranspose: Pwrand([Pseq([0, 2]), Pseq([0, 0, 1]), Pseq([0, 10])], [20, 4, 2], inf),

		//i wanted to get into more detail with this, still kind of fun extra layer
		hr1: Pwhite(0, 1, inf),
		hr2: Pwhite(0, 1, inf),
		hr3: Pwhite(0, 1, inf),
		hr4: Pwhite(0, 1, inf),
		fdb: Pwhite(0, 1, inf),
		mi2: Pwhite(0, 1, inf),
		mi3: Pwhite(0, 1, inf),
		mi4: Pwhite(0, 1, inf),
		en1: Pwhite(0, 1, inf),
		en2: Pwhite(0, 1, inf),
		en3: Pwhite(0, 1, inf),
		en4: Pwhite(0, 1, inf),
		cu1: Pwhite(0, 1, inf),
		cu2: Pwhite(0, 1, inf),
		cu3: Pwhite(0, 1, inf),
		cu4: Pwhite(0, 1, inf),

		dla: 0.5,
		dlf: 0.7 + Pwhite(0.01, 0.08),
		dlt: Pkey(\dur) / 2,
		dur: Pdup(7, Pwrand([1/2, 1/4], [10,1].normalizeSum, inf)),
		amp: 0.25 + Pwhite(0.1,0.2),
		legato: 3,
	]),
).play
);
);
