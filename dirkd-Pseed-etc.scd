/* assignment from september 16th
dirk dullmaier

goals:
1. do some form of dynamic buffer read & write synth
2. find out about tempo and quants in relation to "real" time (TODO)
3. use new words (pseed, plprand, phprand, stretch, pwrand2, pmeanrand, scale, tuning, etc.)

STILL HEAVILY A WORK IN PROGRESS (play at your own risk)
but i figured it's a "functional" homework
*/

//SETUP
//setting up synthdefs, adding them to clean, set seed number
//create bus and buffer for the read and write synths
(
~seedN = 611;

~recordBus = Bus.audio(s, 2);

~tape = Buffer.alloc(s, s.sampleRate * 4.0, 2);

~length = 1.0;


//mda piano from scplugins
SynthDef(\piano, {
	arg out, freq = 440, gate=1, rel = 0.9, hld = 0;
	var sig = MdaPiano.ar(freq, gate, release: rel, stereo: 0.3, sustain: hld);
	DetectSilence.ar(sig, 0.01, doneAction:2);
	Out.ar(out, sig * 0.1);
}).store;

//writes into a buffer
SynthDef(\writer, {
	arg out, in, bufnum, sustain = 1, bgn = 0, end = 1, spd = 1, endspd = 1, freq = 440, fbk = 0,
	gate = 1, atk = 0.01, hld = 0.9, rel = 0.9, crv = -4.0;
	var sig, rate, phase, sawrate, numFrames, env;
	//trying out with envelope
	env = EnvGen.kr(Env.asr(atk, hld, rel, crv), gate, doneAction: 2);
	//playback speed.
	rate = Line.kr(spd, endspd, sustain) * (freq / 60.midicps);
	numFrames = BufFrames.ir(bufnum) * ~length;
	sig = RecordBuf.ar(In.ar(in, 2), bufnum, BufFrames.ir(bufnum) * bgn, 1.0 * env, fbk, env, doneAction:2);
	Out.ar(out, 0.0)
	//what are all those \ir actually for?---
}, [\ir, \ir, \ir, \ir, \ir, \ir, \ir, \ir]).store;

//plays from a buffer
SynthDef(\player, {
	arg out, bufnum, sustain = 1, bgn = 0, end = 1, spd = 1, endspd = 1, freq = 440, pan = 1,
	gate = 1, atk = 0.01, hld = 0.9, rel = 0.9, crv = -4.0;
	var sig, rate, phase, sawrate, numFrames, env;
	env = EnvGen.kr(Env.asr(atk, hld, rel, crv), gate, doneAction: 2);
	//playback speed.
	rate = Line.kr(spd, endspd, sustain) * (freq / 60.midicps);
	phase =  Sweep.ar(1, rate * BufSampleRate.ir(bufnum)) + (BufFrames.ir(bufnum) * bgn);
	numFrames = BufFrames.ir(bufnum) * ~length;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.ir(bufnum) * rate, startPos: phase, loop: 0.0, doneAction:2);
	sig = CleanPan.ar(sig * env, 2, pan);
	Out.ar(out, sig)
}, [\ir, \ir, \ir, \ir, \ir, \ir, \ir, \ir]).store;

);

//INITIAL MOVEMENT
//fill the buffer a bit with piano stabs
//also randomly play them back
(

(Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \piano,
		degree: Pdup(80, Pwrand2([Plprand([-2, -5], [-14, -17]), Phprand([-6, -8], [-22, -27])], [20, 4], inf)),
		Scale: Pseed(~seedN, Pwrand2([Scale.partch_u6(\wcSJ), Scale.partch_o3(\wcHarm)], [10, 1], inf)),
		dur: 1 / Pseed(~seedN, Pwrand2([2, 4], [2, 10], inf)),
		amp: 0.9 + Pwhite(0.05, 0.15),
		legato: 1.2 + Pexprand(0.1, 0.3),
		dlt: 2.0 * Pkey(\amp),
		dlf: 0.3,
		dla: 0.7,
		tnh: 0.2,
		tng: 2.8,
		pan: Pmeanrand(0.0, 1.0),
		out: ~recordBus,
	]),
).play
);

(Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \writer,
		in: ~recordBus,
		dur: Pseed(~seedN, Pwrand2([1, 2], [1, 2], inf)),
		bufnum: ~tape,
		//the fbk value tells the writer how much amplitude of the existing
		//data in the buffer gets mixed with the input, this is the lynchpin
		//of creating interesting feedback effects, but also it getting out of
		//control
		fbk: 0.8,
		bgn: Pwhite(0.0, 1.0),
		legato: 10,
	]),
).play
);

(Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \player,
		dur: 2,
		bufnum: ~tape,
		bgn: Pwhite(0.0, 1.0),
		amp: 0.9 + Pmeanrand(0.1, 0.4),
		legato: 10,
		hal: 0.3,
		dlt: 1 / Pwrand2([1, 2, 8], [2, 10, 1], inf),
		dla: 0.5,
		dlf: 0.6,
		tnh: Pwhite(0.1, 0.6),
		tng: Plprand(0.1, 3.4),
	]),
).play
);

);

//SECOND MOVEMENT
//now i gets funkier, add a second buffer player that feeds
//back into the recording bus
//and another player that plays pitch shifted "chords"
(
(Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \player,
		dur: Pwhite(1, 3),
		bufnum: ~tape,
		bgn: Pseq((0.1, 0.2 .. 1.0), inf),
		legato: Prand([2, 3, 6], inf),
		bit: Plprand(1.9, 3.4),
		out: ~recordBus,
	]),
).play
);

(Pdef(4,
	Pbind(*[
		type: \cln,
		snd: \player,
		dur: Pdup(32, Pwrand([1/8, 1/4, 8], [8, 4, 1], inf)),
		bufnum: ~tape,
		bgn: Prand([1, 0.2, 0.4, 0.6, 0.8], inf),
		legato: 5,
		degree: Pseq([[-1, -4], [-10, -12], [3, 6], [8, 11]], inf),
		atk: Pwhite(0.001, 0.01),
		hld: Pseq([0.7, 0.8, 1, 0.8, 0.4], inf),
		rel: Pseq([0.5, 0.6, 0.7, 0.2], inf),
		amp: 0.9 + Pwhite(0.1, 0.2),
		cai: 0.4,
		cav: 0.9,
		tnh: Pwhite(0.1, 0.6),
		tng: Plprand(0.1, 3.4),
		Scale: Pseed(~seedN, Pwrand2([Scale.partch_u6(\wcSJ), Scale.partch_o3(\wcHarm)], [10, 1], inf)),
	]),
).play
);

);

//THIRD MOVEMENT
//just another instrument that plays into the recording bus
(
(Pdef(5,
	Pbind(*[
		type: \cln,
		snd: Pwrand2([\kps, \r], [1, 3], inf),
		amp: Pwhite(0.25, 0.4),
		dur: Pseq([4, 6, 7, 5], inf),
		ada: Pexprand(0.001,9.3),
		adr: Pkey(\dur)+(Pexprand(0.07,10.0)),
		bnd: 0.4,
		bnt: 0.6,
		bno: 0.3 + Pwhite(0.01, 0.07),
		bnc: 0.4,
		degree: Pwhite(3, 14),
		legato: 4,
		Scale: Pseed(~seedN, Pwrand2([Scale.partch_u6(\wcSJ), Scale.partch_o3(\wcHarm)], [10, 1], inf)),
		out: ~recordBus,
	]),
).fadeTime_(20).play
);

);

//FOURTH MOVEMENT
//second writer for total madness
(
(Pdef(6,
	Pbind(*[
		type: \cln,
		snd: \writer,
		in: ~recordBus,
		freq: Phprand(70, 200),
		dur: Pdup(80, Pwrand2([Pseed(~seedN, 1 / Pwrand2([4, 8], [4, 8], inf)), 10], [2, 8], inf)),
		bufnum: ~tape,
		fbk: 0.8,
		bgn: Pwhite(0.2, 0.8),
		legato: 6,
	]),
).fadeTime_(20).play
);

);

/*
--from daniels code, supposedly alternate version to playbuf--
sound = BufRd.ar(
numChannels: sampleNumChannels,
bufnum: bufnum,
phase: phase,
loop: 0,
interpolation: 4
);
*/
