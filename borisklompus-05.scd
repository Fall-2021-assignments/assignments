(
// Evaluate this first. Updates Spectral Delay and adds a new spectral effect that's nice for spatialization

// Spectral Delay. Made by Mads Kjeldgaard.
// Slight update to what's currently in Clean.
SynthDef(\clean_spectralDelay, {
	var bus = \bus.ir, inputGain = \inputGain.kr(1), outputGain = \outputGain.kr(1), blend = \blend.kr(1).linlin(0.0, 1.0, -1.0, 1.0),
	depth = \depth.kr(1), layerScale = \layerScale.kr(10), delayScale = \delayScale.kr(2), resonance = \resonance.kr(0.02).clip(0, 1);
	var size = 16, maxDelayTime = 0.2, delayTime, signal = Array.newClear(2); // array index: [0] - in/clean, [1] - effect/main
	delayTime = delayScale * maxDelayTime;
	resonance = ((resonance < 0.1) * (resonance * 0.1).linlin(0.0, 1.0, 0.005, 1.0)) + ((resonance >= 0.1) * resonance); // scale resonance
	signal[0] = In.ar(bus, ~clean.numChannels) * inputGain;
	signal[1] = (1 .. size).sum { |i|
		var filterFreq = i.linexp(1, size, 40, 17000);
		var sig = BPF.ar(signal[0], filterFreq, resonance);
		DelayN.ar(sig, maxDelayTime, i & layerScale * size.reciprocal * delayTime) // the delay pattern is determined by bitwise-and of layerScale
	};
	signal[1] = signal[0] * 0.2 + (signal[1] * 4 * depth);
	signal[1] = XFade2.ar(signal[0], signal[1], blend);
	signal[1] = signal[1] * outputGain;
	ReplaceOut.ar(bus, signal[1])
}).add;

~clean.addModule(\sdx, { |cleanEvent|
	cleanEvent.sendSynth(\clean_spectralDelay, [
		layerScale: ~sdx ?? { SynthDescLib.global.at(\clean_spectralDelay).controlDict[\layerScale].defaultValue },
		delayScale: ~sdt ?? { SynthDescLib.global.at(\clean_spectralDelay).controlDict[\delayScale].defaultValue },
		depth: ~sda ?? { SynthDescLib.global.at(\clean_spectralDelay).controlDict[\depth].defaultValue },
		resonance: ~sdq ?? { SynthDescLib.global.at(\clean_spectralDelay).controlDict[\resonance].defaultValue },
		inputGain: ~sdi ?? { SynthDescLib.global.at(\clean_spectralDelay).controlDict[\inputGain].defaultValue },
		outputGain: ~sdo ?? { SynthDescLib.global.at(\clean_spectralDelay).controlDict[\outputGain].defaultValue },
		blend: ~sdb ?? { SynthDescLib.global.at(\clean_spectralDelay).controlDict[\blend].defaultValue },
		bus: ~out
	])
}, { ~sdx.notNil or: ~sdt.notNil });


// new effect
SynthDef(\clean_spectralPhaseDecorrelator, {
	var bus = \bus.ir, inputGain = \inputGain.kr(1), outputGain = \outputGain.kr(1), blend = \blend.kr(0.5).linlin(0.0, 1.0, -1.0, 1.0),
	depth = \depth.kr(0.1).linlin(0.0, 1.0, 0, 2pi), accumulate = \accumulate.kr;
	var signal = Array.newClear(2); // array index: [0] - in/clean, [1] - effect/main
	var numFrames = 2048;
	signal[0] = In.ar(bus, ~clean.numChannels) * inputGain;
	signal[1] = signal[0].asArray.collect { |x| FFT(LocalBuf(numFrames), x) };
	signal[1] = IFFT(PV_PhaseShift(signal[1], [depth, depth.linlin(0, 2pi, 2pi, 0)], accumulate));
	signal[1] = XFade2.ar(signal[0], signal[1], blend);
	signal[1] = signal[1] * outputGain;
	ReplaceOut.ar(bus, signal[1])
}).add;

~clean.addModule(\psd, { |cleanEvent|
	cleanEvent.sendSynth(\clean_spectralPhaseDecorrelator, [
		depth: ~psd ?? { SynthDescLib.global.at(\clean_spectralPhaseDecorrelator).controlDict[\depth].defaultValue },
		accumulate: ~psa ?? { SynthDescLib.global.at(\clean_spectralPhaseDecorrelator).controlDict[\accumulate].defaultValue },
		inputGain: ~psi ?? { SynthDescLib.global.at(\clean_spectralPhaseDecorrelator).controlDict[\inputGain].defaultValue },
		outputGain: ~pso ?? { SynthDescLib.global.at(\clean_spectralPhaseDecorrelator).controlDict[\outputGain].defaultValue },
		blend: ~psb ?? { SynthDescLib.global.at(\clean_spectralPhaseDecorrelator).controlDict[\blend].defaultValue },
		bus: ~out
	])
}, { ~psd.notNil or: ~psb.notNil });
)


(
Pdef(55,
	Pbind(*[
		type: \cln,
		// snd: Pwrand2([\ixa, Pwrand2([\saw, \ixa, \dfd, \sqr, \r], [1, 1, 1, 1, 0.2], 3)], [3, 1], inf),
		snd: Pwrand2([\saw, \ixa, \dfd, \sqr, \r], [1, 1, 1, 1, 0.2], inf),

		dur: Pseq([0.375, 0.25, 0.25, 0.375], inf) * 5,

		amp: Pif(Pkey(\snd) |==| \dfd, Pwhite(0.2, 0.4), Pwhite(0.5, 0.8)),
		atk: Pif(Pkey(\snd) |==| \dfd, Pwhite(0.3, 0.7), Pwhite(0.05, 0.2)),
		rel: Pwrand2([Pmeanrand(20, 40), Phprand(3, 10)], [10, 0.5], inf),

		iph: Plprand(0.0, 1.0),
		wid: Pseg([0.0, 1.0, 0.0], Pkey(\dur) * 0.25, \wel, inf),
		den: Prand([Plprand(0.0, 1.0), Phprand(0.0, 1.0)], inf),
		res: Pmeanrand(0.9, 1.01),
		typ: Pwhite(0.2, 0.8),
		nsl: Pwhite(0.0, 0.3),

		bes: Pseg([2, 1.5, 2.5, 2], Pkey(\dur) * 0.3, \exp, inf),
		ber: Pseg([1, 2.5, 0.5, 1], Pkey(\dur) * 0.09, \sin, inf),
		abs: Pseg([2, 1.5, 2.5, 2], Pkey(\dur) * 0.31, \wel, inf),
		abr: Pseg([1, 2.5, 0.5, 1], Pkey(\dur) * 0.1, \exp, inf),
		ths: Pseg([2, 1.5, 2.5, 2], Pkey(\dur) * 0.29, \sin, inf),
		thr: Pseg([1, 2.5, 0.5, 1], Pkey(\dur) * 0.11, \lin, inf),

		bnd: Pwrand([0, Pmeanrand(-0.2, 0.3), Pmeanrand(-1.0, 1.0)], [5, 2, 1], inf),
		bnt: Pkey(\rel) * Prand((0.025, 0.05 .. 1.0), inf),
		bno: Plprand(0.0, Pkey(\dur)),
		bnc: Pwhite(-7, 7),

		degree: Pstep([1, 8, 3, 7, -3], 0.125, inf),
		octave: Pseq([3, 2, 4], inf) + Pwhite(0, 1),

		psd: Pdup(Pwhite(22, 44), Pseq((0.05, 0.1 .. 0.95), inf)),
		psd: Pseg([0.01, 0.99, 0.01], Pkey(\dur) * 3.3, \lin, inf),
		psa: Pdup(Pwhite(22, 44), Pseq([0, 1], inf)),
		psb: Pseg([0.1, 0.9, 0.1], Pkey(\dur) * 1.7, \exp, inf),

		sdx: Pseg([11, 8, 14], Pkey(\dur) * 0.1, \lin, inf),
		sdt: Pkey(\dur) * Pseq((1 .. 3), inf),
		sdo: Pseg([0.7, 0.3, 0.1], Pkey(\dur) * 0.13, \exp, inf),
		sdb: Prand([0.5, Pseg([Phprand(0.0, 0.5), Pmeanrand(0.0, 1.0), Plprand(0.0, 0.5)], Pkey(\dur) * 0.2, [\sin, \wel], 4)], inf),
	])
).play;
)
