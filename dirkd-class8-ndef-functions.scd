/* assignment from november 25th
dirk dullmaier

goals:
1. n strings play continously as ndefs
2. several pdefs to grab sound from the pdefs and play
them with pattern logic while also somehow doing things
to each other

dare i say it? work in progr.
*/

// setup
(
(
/* guess this is the most important value, how many parallel
ndefs are running that our pdefs are later gonna access?

also gonna create a bus for each one of them and clear whole
ndef space just in case */

~numberOfStrings = 13; // i do kinda like it with just 4
~stringBus = Array.fill(~numberOfStrings, {Bus.audio(s, 2);});
Ndef.clear;

);

(
/* this is the ndef factory, creates an ndef which is a
constantly running ndef, which can be affected by various
gates (currently "affect" which adds a little spike to the
frequency and "noise" which adds a bit of pink noise for
the duration of a percussive envelope) */
~string = {
	arg num, f;
	// freq.postln;
	Ndef((\string ++ num).asSymbol, {
		arg freq = 220, t_ring = 0, affectIntensity = 25.0,
		t_noise = 0, noiseIntensity = 0.3;
		var amp = 0.25, sig;

		// freq = f;
		sig = LockhartWavefolder.ar(SinOsc.ar(freq
			+ EnvGen.kr(Env.perc(0.001, 0.135), t_ring, affectIntensity, 0.0, 1.0, 0)
		), 5);

		sig = Mix.ar([
			sig,
			PinkNoise.ar
			* EnvGen.kr(Env.perc(0.01, 0.02), t_noise, noiseIntensity, 0.0, 1.0, 0)]);

		sig * amp ! 2;
	});
	Ndef((\string ++ num).asSymbol).set(\freq, f);
}

);
/* create as many strings as we declared beforehand and play
them through their seperate busses */
~numberOfStrings.do{arg index; ~string.(index, 80 * (index + 1));};
~numberOfStrings.do{arg index; Ndef((\string ++ index).asSymbol).play(~stringBus[index]);};

/* functions to do things to running ndef
you could do a lot of things to make weird connections between
what one ndef could do to other ndefs that are running,
currently i've only got these two */
(
~affect = {
	arg index, intensity;
	~numberOfStrings.do{
		arg i;
		if(i == index)
		{}
		{Ndef((\string ++ i).asSymbol).set(\t_ring, 1, \affectIntensity, intensity);}
}}
);

(
~sloppy = {
	arg index, intensity;
	var adj;

	adj = (index + 1) % ~numberOfStrings;
	Ndef((\string ++ adj)).set(\t_noise, 1, \noiseIntensity, intensity);
}
);

(
// change the base frequency of all ndefs
~changeBase = {
	arg newFreq;
	~numberOfStrings.do{
		arg index;
		Ndef((\string ++ index).asSymbol).set(\freq, newFreq * (index + 1));
}}
);

);

// actual playing starts here
(
(
/* this one doesnt play sound, it changes the base frequency of the
harmonic net after a bunch of stream events */
Pdef(16,
	Pbind(*[
		type: \cln,
		snd: \default,
		base: Pdup(Pwhite(70, 90), Pseq([80, 110], 3)),
		change: Pfunc{arg event; ~changeBase.(event.base);},
		amp: 0.0,
		/* i'm not 100% sure, but i think having this play through
		aux 0 per default will affect my cave reverb */
		aux: 10,
	]),
).play
);

(
/* just a foundational steadily walking sequence */
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \rcv,
		numStrings: Pfunc{~numberOfStrings},
		which: Pwhite(1, Pkey(\numStrings)) - 1,
		input: Pfunc{arg event; ~stringBus[event.which]},
		amp: Pseg([0.4, 0.38, 0.4], 200, \lin, 1),
		dur: 1 / Pseq ([4, 3, 2, 1, 101], inf),
		intensity: Plprand(5.0, 40.0),
		affect: Pfunc{arg event; ~affect.(event.which, event.intensity);},
		pan: Pmeanrand(0.0, 1.0),
		cav: 0.1,
		aux: 0,
	]),
).play
);

(
/* long notes that come in after a while */
Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \rcv,
		numStrings: Pfunc{~numberOfStrings},
		which: Pwhite(1, Pkey(\numStrings)) - 1,
		input: Pfunc{arg event; ~stringBus[event.which]},
		amp: Pseg([0, 0.4, 0], 200, \lin, 1),
		atk: 0.2,
		tsc: 20,
		rel: 0.5,
		dur: Pseq([20, 30], inf) + Pwhite(0.01, 1.01),
		intensity: Plprand(5.0, 15.0),
		affect: Pfunc{arg event; ~affect.(event.which, event.intensity);},
		pan: Pmeanrand(0.0, 1.0),
		cav: 0.23,
		dlt: Pkey(\dur) / 5,
		dla: Pwhite(0.1, 0.24),
		dlf: Pwhite(0.1, 0.13),
		aux: 1,
	]),
).play
);

(
/* barely audible on itself, but adds a lot of frequency
spikes and noise in the running ndefs */
Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \rcv,
		numStrings: Pfunc{~numberOfStrings},
		which: Pwrand2([1, Pkey(\numStrings) - 1], [10, 1], inf),
		input: Pfunc{arg event; ~stringBus[event.which]},
		amp: Pseg([0, 0.02, 0.03], 200, \lin, 1),
		dur: 1 / Pseg([1, 10, 100, 1], [50, 10, 20], \exp, inf),
		intensity: Pseg([0, Plprand(50.0, 100.0), 0], Pwhite(35, 200), \wel, inf),
		affect: Pfunc{arg event; ~affect.(event.which, event.intensity);},
		noise: Pfunc{arg event; ~sloppy.(event.which, event.intensity);},
		pan: Pmeanrand(0.0, 1.0),
		cav: 0.01,
		aux: 2,
	]),
).play
);
);
