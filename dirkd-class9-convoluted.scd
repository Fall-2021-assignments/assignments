/* assignment from december 9th
dirk dullmaier

WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING:
MIGHT BE DANGEROUS TO PLAY IN CURRENT STATE, PROCEED WITH CAUTION
WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING:

goals:
1. after using pdefs to play whats going on in a number of ndefs,
now we have ndefs playing back and recording stuff that's coming
from pdefs
2. convolution, cross-convolution, sounds convoluted

i guess this is kind of dangerous territory, because there is some
feedback thing going on and it could get out of hand, so be cautious
when trying to play this

i'm still figuring out stuff about execution order, ndefs and clean,
this code is behaving sometimes differently and i dont know why,
sometimes it starts off gentle and plays itself up to a little
distortion, sometimes it already starts off completely bricked
onto the limiter ---

WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING:
MIGHT BE DANGEROUS TO PLAY IN CURRENT STATE, PROCEED WITH CAUTION
WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING:

wip
*/

(
(
/* setup,
allocate buffers, assign busses */
~recBuf1 = Buffer.alloc(s, s.sampleRate * 16.0, 2);
~recBuf2 = Buffer.alloc(s, s.sampleRate * 16.0, 2);

~playerBus1 = Bus.audio(s, 2);
~playerBus2 = Bus.audio(s, 2);
);

/* instantiating ndefs and adding some fadetime */
Ndef(\player1).fadeTime_(10);
Ndef(\player2).fadeTime_(20);
);

s.record;

(
(
/* play sequences into busses */
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \sin,
		dur: 1 / Pwrand2([4, 5], [20, 1], inf),
		degree: Pseq([0, 0, 0, 3, 6], inf),
		wetbalance: Pseg([0, 1], 100, \lin, 1),
		wetfunc: Pfunc{ arg event; Ndef(\player1).set(\dry, 1 - event.wetbalance, \wet, event.wetbalance); },
		amp: 0.1,
		pan: Pmeanrand(0.0, 1.0),
		out: ~playerBus1,
	]),
).play
);

(
Pdef(1,
	Pbind(*[
		type: Pwrand([\cln, \r], [10, 1], inf),
		snd: \sin,
		dur: 1 / 2,
		wetbalance: Pseg([0, 1], 110, \lin, 1),
		wetfunc: Pfunc{ arg event; Ndef(\player2).set(\dry, 1 - event.wetbalance, \wet, event.wetbalance); },
		amp: 0.1,
		pan: Pmeanrand(0.0, 1.0),
		out: ~playerBus2,
	]),
).play
);

(
/* start two ndefs that play stuff from the busses,
record what they play onto the buffers and convolve
their signal with the buffer from the other ndef */
Ndef(\player1, {
	arg rate = 1.0, amp = 0.4, wet = 0.5, dry = 0.5;
	var sig, conv, rec, ptr, bufDur, bufFrames;

	bufDur = BufDur.ir(~recBuf1);
	bufFrames = BufFrames.ir(~recBuf1);

	ptr = Phasor.ar(
		0,
		rate,
		0,
		bufFrames
	);

	sig = In.ar(~playerBus1, 2);

	// writing input to buffer
	~recBuf1.do {
		arg buf, index;
		BufWr.ar(sig[index], buf, ptr)
	};

	conv = [Convolution.ar(sig[0], ~recBuf2.bufnum, 8192),
		Convolution.ar(sig[1], ~recBuf2.bufnum + 1, 8192)];

	// conv = sig;

	sig = Limiter.ar(Mix.ar([sig * dry, conv * wet]), 0.9);

	sig * amp;
}).play
);

(
Ndef(\player2, {
	arg rate = 1.0, amp = 0.35, wet = 0.5, dry = 0.5;
	var sig, conv, rec, ptr, bufDur, bufFrames;

	bufDur = BufDur.ir(~recBuf2);
	bufFrames = BufFrames.ir(~recBuf2);

	ptr = Phasor.ar(
		0,
		rate,
		0,
		bufFrames
	);

	sig = In.ar(~playerBus2, 2);

	// writing input to buffer
	~recBuf2.do {
		arg buf, index;
		BufWr.ar(sig[index], buf, ptr)
	};

	conv = [Convolution.ar(sig[0], ~recBuf1.bufnum , 8192),
		Convolution.ar(sig[1], ~recBuf1.bufnum + 1, 8192)];

	// conv = sig;

	sig = Limiter.ar(Mix.ar([sig * dry, conv * wet]), 0.9);

	sig * amp;
}).play
);
);
