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
~seedN = 31;

~recordBus = Bus.audio(s, 2);

~tape = Buffer.alloc(s, s.sampleRate * 8.0, 2);

//writes into the buffer
SynthDef(\writer, {
	arg out, in, bufnum, sustain = 1, bgn = 0, end = 1, spd = 1, endspd = 1, freq = 440, pan = 0, fbk = 0;
	var sig, rate, phase, sawrate, numFrames;
	//playback speed.
	rate = Line.kr(spd, endspd, sustain) * (freq / 60.midicps);
	//phase =  Sweep.ar(1, rate * BufSampleRate.ir(bufnum)) + (BufFrames.ir(bufnum) * bgn);
	numFrames = BufFrames.ir(bufnum);
	sig = RecordBuf.ar(In.ar(in, 2), bufnum, BufFrames.ir(bufnum) * bgn, 1.0, fbk, doneAction:2);
	Out.ar(out, sig)
	//what are all those \ir actually for?---
}, [\ir, \ir, \ir, \ir, \ir, \ir, \ir, \ir]).store;

//plays from the buffer
SynthDef(\player, {
	arg out, bufnum, sustain = 1, bgn = 0, end = 1, spd = 1, endspd = 1, freq = 440, pan = 0;
	var sig, rate, phase, sawrate, numFrames;
	//playback speed.
	rate = Line.kr(spd, endspd, sustain) * (freq / 60.midicps);
	phase =  Sweep.ar(1, rate * BufSampleRate.ir(bufnum)) + (BufFrames.ir(bufnum) * bgn);
	numFrames = BufFrames.ir(bufnum);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.ir(bufnum) * rate, startPos: phase, loop: 0.0, doneAction:2);
	sig = CleanPan.ar(sig, 2, pan);
	Out.ar(out, sig)
}, [\ir, \ir, \ir, \ir, \ir, \ir, \ir, \ir]).store;

);

//INITIAL MOVEMENT
//fill the buffer a bit with random sine bloops
//also randomly play them back
(

(Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \sin,
		degree: Plprand(2, 6),
		Scale: Pseed(~seedN, Pwrand2([Scale.partch_u6(\wcSJ), Scale.partch_o3(\wcHarm)], [10, 1], inf)),
		dur: 1 / Pseed(~seedN, Pwrand2([8, 16], [2, 10], inf)),
		amp: 0.8,
		legato: 1.2 + Pexprand(0.1, 0.3),
		dlt: 2.0,
		dlf: 0.3,
		dla: 0.4,
		tnh: 0.2,
		tng: 0.8,
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
		fbk: 0.4,
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
		legato: 10,
		hal: 0.3,
		dlt: 1 / Pwrand2([1, 2, 8], [2, 10, 1], inf),
		dla: 0.5,
		dlf: 0.6,
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
		dur: Pwhite(2, 4),
		bufnum: ~tape,
		bgn: Pseq((0.1, 0.2 .. 1.0), inf),
		legato: Prand([2, 3, 6], inf),
		bit: Plprand(0.2, 0.4),
		out: ~recordBus,
	]),
).play
);

(Pdef(4,
	Pbind(*[
		type: \cln,
		snd: \player,
		dur: 1,
		bufnum: ~tape,
		bgn: Prand([1, 0.2, 0.4, 0.6, 0.8], inf),
		legato: 5,
		degree: Pseq([[-1, -4], [-10, -12], [3, 6], [8, 11]], inf),
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
		amp: Pwhite(0.2, 0.3),
		dur: Pseq([4, 6], inf),
		degree: Pwhite(3, 14),
		legato: 4,
		Scale: Pseed(~seedN, Pwrand2([Scale.partch_u6(\wcSJ), Scale.partch_o3(\wcHarm)], [10, 1], inf)),
		out: ~recordBus,
	]),
).play
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
