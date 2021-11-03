/* assignment from october 28th
dirk dullmaier

first dirty cut

goals:
1. something new or such
2. weird conceptual thing with interconnected values

WORK IN PROGRESSss

these are basically two odd \kps sequences moving "towards" each other,
one starts very slow and in a kind of listenable pitch and amp area, the second
is silent at start, extremely fast and in some crazy octave. one goes faster and
higher, two goes slower and deeper, they meet in the middle, clap hands and one
moves towards silence, two plays to the end. also some additional ambience
things and a chord player, that sometimes comes up, all related to the durations
of the two main pdefs

as it stands it's more a weird experiment than an actual piece, i think about adding
some more flavour to make it more interesting to listen to..
*/

(
~totalTime = 200;
~dur0 = 1;
~dur1 = 1;
);

(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \kps,
		multiply: Pseg([1, 5, 1], [Pfunc{~totalTime} - 2, 2], \lin, 1),
		degree: Pseg([0, 0.02, 0], 0.001, \sin, inf) + Pseq([[0, 1], [5, 7], [0, 1], [5, 7], [0, 1], [-1, 2]],inf),
		scale: Scale.minor(\just),
		octave: 3 + Pkey(\multiply).round,
		mtranspose: 4,
		dur: Pseq([Pdup(5, Pwhite(0.18, 0.22, 1)), Pwrand2([0.6, 0.75], [5, 1])], inf) / Pkey(\multiply),
		mod1: Pseg([0, 1, 0], Pkey(\dur), \exp, inf),
		bnd: 0.11 * Pkey(\mod1) + Pseg([0, 0.3], Pfunc{~totalTime} / 4, \sin, inf),
		bnt: 0.1 * Pkey(\mod1),
		bno: 0.6 * Pkey(\mod1),
		bnc: Pwhite(-4, 1),
		ocq: 0.3,
		amp: Pseg([0, 1, 0], [2, Pfunc{~totalTime} - 2], \lin, 1),
		cav: 0.1,
		legato: Pseq([4, 4, 4, 4, 1, 4], inf),
		// pan: Pmeanrand(0.0, 1.0),
		// utility: Pfunc{ arg event; event.dur.postln },
		calculate: Pfunc{ arg event; ~dur0 = event.dur },
		tnh: 0.3,
		tng: 0.01,
		aux: 0,
])).play;

Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \kps,
		multiply: Pseg([5, 1, 0.5], [Pfunc{~totalTime} - 2, 2], \lin, 1),
		degree: Pseg([0, 0.02, 0], 0.001, \sin, inf) + Pseq([[3, 8], [2, 4], [3, 8], [2, 7], [2, 4], [3, 9]],inf),
		scale: Scale.minor(\just),
		octave: 3 + Pkey(\multiply).round,
		mtranspose: 4,
		dur: Pseq([Pdup(3, Pwhite(0.18, 0.22, 1)), Pwrand2([0.6, 0.75], [5, 1]), Pdup(4, Pwhite(0.18, 0.22, 1)), Pdup(2, Pwrand2([0.6, 0.75], [5, 1]))], inf) / Pkey(\multiply),
		mod1: Pseg([0, 1, 0], Pkey(\dur), \exp, inf),
		bnd: 0.11 * Pkey(\mod1),
		bnt: 0.1 * Pkey(\mod1) + Pseg([0, 0.3], Pfunc{~totalTime} / 3, \sin, inf),
		bno: 0.6 * Pkey(\mod1),
		bnc: Pwhite(-4, 1),
		ocq: 0.3,
		amp: Pseg([0, 1, 0], [Pfunc{~totalTime} - 2, 2], \lin, 1),
		cav: 0.1,
		legato: Pseq([4, 4, 4, 4, 1, 4], inf),
		// pan: Pmeanrand(0.0, 1.0),
		// utility: Pfunc{ arg event; event.dur.postln },
		calculate: Pfunc{ arg event; ~dur1 = event.dur },
		tnh: 0.3,
		tng: 0.01,
		aux: 0,
])).play;

Pdef(2,
	Pbind(*[
		type: \cln,
		snd: Pdup(Pwhite(1, 4) * 5, Prand([\sin, \r], inf)),
		degree: Pseq([[1, 4], [3, 6], [7, 2]], inf),
		mtranspose: Pwrand2([0, 1, 2], [10, 2, 1], inf),
		scale: Scale.minor(\just),
		dur: 2.5 * Pfunc{ [~dur0, ~dur1].maxItem },
		// utility: Pfunc{ arg event; event.dur.postln },
		amp: Pseg([0, 0.6, 0], Pfunc{~totalTime} / 2, \lin, 1),
		dla: 0.6,
		dlt: Pkey(\dur),
		cav: 0.3 + Pwhite(0.03, 0.08),
		aux: 1,
])).play;

Pdef(3,
	Pbind(*[
		type: \cln,
		snd: Pwrand2([\bow, \r], [2, 10], inf),
		degree: Pseq([1, 3, 7], inf),
		mtranspose: Pwrand2([0, 1, 2], [20, 2, 1], inf),
		scale: Scale.minor(\just),
		// dur: 5 * Pfunc{ [~dur0, ~dur1].minItem },
		mod2: Pseg([0, 1, 0], Pkey(\dur) / 2, \exp, inf),
		// utility: Pfunc{ arg event; event.dur.postln },
		frc: 0.5 * Pkey(\mod2),
		pos: 0.5 * Pkey(\mod2),
		bpr: 0.5 * Pkey(\mod2),
		shp: 0.21 * Pkey(\mod2),
		dla: 0.6,
		dlf: 0.4 + Pseg([0, 0.5, 0], [Pfunc{~totalTime} / 4, 3 * (Pfunc{~totalTime} / 4)], \exp, 1),
		dlt: Pkey(\dur) / Pseg([0, 100], Pfunc{~totalTime}, \lin, 1),
		cav: 0.2,
		amp: Pseg([0, 0.7, 0], [Pfunc{~totalTime} / 4, 3 * (Pfunc{~totalTime} / 4)], \lin, 1),
		pan: Pmeanrand(0.0, 1.0),
		aux: 2,
])).play;
)
