/*
This is an attempt to do something similar to
https://github.com/micah-frank-studio/Kickblast/blob/master/Kickblast.csd
which is a kick drum sample maker of sorts that i stumbled upon.

I first wanted to try and make samples inside a Pdef-Pbind pattern but didn't find
a way so went with Routine instead.
Also borrowed the superclean drum synthdef for this to keep on topic :)

There is a lot room for improvements here.
but as always...time.
*/

// if you haven't already
s.boot;

//create buffer
b = Buffer.new(s);

// allocate some space in the buffer
b = Buffer.alloc(s, s.sampleRate * 1.0, 2);

// add the synthdef
(
SynthDef(\trumman, {
	var out = \out.ir, amp = \amp.kr(0.3), pan = \pan.kr, attack = \attack.ir(0.01).abs, release = \release.ir(1).abs,
	ampEnvCurve = \ampEnvCurve.ir(-3), gate = \gate.tr(1), timeScale = \timeScale.kr(1).abs, bufnum = \bufnum.kr;
	var tune = \tune.kr.abs, feedback = \feedback.kr.abs, sweep = \sweep.kr(1).abs, cutoff = \cutoff.kr(9000).abs;

	var bendEnv, tuning, ampEnv, signal;

	tune = ((tune > 0) * tune) + ((tune < 1) * 3);
	tuning = (tune * 10).midicps;
	bendEnv = XLine.kr(tuning.expexp(10, 2000, 1000, 8000), tuning, 0.025 * sweep.reciprocal);

	ampEnv = Env.linen(attack, (timeScale - 1).max(0), release, amp, ampEnvCurve).kr(Done.freeSelf, gate/*, timeScale*/); // orig w/ sustainTime control

	signal = SinOscFB.ar(bendEnv, feedback);
	signal = LPF.ar(signal, cutoff);

	signal = signal * ampEnv;
	signal = CleanPan.ar(signal, 2, pan);
	RecordBuf.ar(signal, bufnum, doneAction: Done.freeSelf, loop: 0);

	OffsetOut.ar(out, signal)
}
).add;
)


// OBS before you run this make sure to change the path to match your comp.
(
var r;
r = Routine {
    3.do({ arg a;
		~path = "C:/Users/User/Music/" ++ Date.localtime.stamp ++"" + "kick.wav"; // configure this line
		Synth(\trumman, [\out, 0, \bufnum, b, \tune, rrand(0.0, 4.0), \sweep, rrand(0.3, 2)], s);
		b.write(~path, "WAV", 'int16');
		1.wait;
    });
    // Wait half second before saying we're done
    0.5.wait;
    "done".postln;
}.play;
)


// original kick pattern idea
(
Pdef(0,
	Pbind(*[
		type: \cln,

		snd: \drm,
		atk: Pwhite(0.01, 0.1), // 0.01 -0.1
		rel: Pwhite(1, 2), //1-2
		crv: Pwhite(-10, -3), //-3 -10
		//tsc: 0.5 not used
		tun: Pwhite(0.0, 4.1),   // 0.0 4.0
		fed: Pwhite(0.0, 0.8), // 0-0.8
		pew: Pwhite(0.3, 2), // 0.3 - 2
		fco: 9000
	])
).play(quant:1, s, );
)


// some stuff to remember

//~path = "C:/Users/User/Music/" + "kick.wav";
//b.write(~path, "WAV", 'int16');
//Synth.new(\trumman, [\out, 0, \bufnum, b], s);
//Synth.new(\help_RecordBuf_playback, [\out, 0, \bufnum, b], s);