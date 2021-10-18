/* assignment from october 14th
dirk dullmaier

first dirty cut

goals:
1. do some multilayered stuff with stretch, custom params?
2. try out the spectral effects, maybe round stuff?
3. use proper auxing for global fx
4. psegs as envelopes?

WORK IN PROGRESS (i think this is going to be a running joke from now on)
*/

(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: Pwrand2([\add, \r], [200, 1], inf),
		dur: Pwrand2([1/4, 1/2, 1/8, 1], [10, 2, 2, 1], inf),
		mod1: Pseg([0, 1, 0], Pkey(\dur), \wel, inf),
		mod2: Pseg([0.01, 1, 0.01], Pkey(\dur), \exp, inf),
		// ada: 0.1 * Pkey(\mod2),
		adr: 0.5 * Pkey(\mod1) * 2,
		adc: 0.9 * Pkey(\mod1),
		slw: 0.3 * Pkey(\mod2),

		// degree: Pwhite(1, 9) + [0, 7, 14, 20],
		degree: Pwhite(1, 3) + Pwrand2([[1, 4], [3, 10], [7, 14], [-4, 7], [11, 21]], [5, 4, 3, 2, 1], inf),
		scale: Scale.mixolydian,

		lpf: 9000 * Pkey(\mod1) + Pseg([0, 4000, 0], 25, \sin, inf),
		lpq: 0.9 * Pseg([0.1,1,0.2,0.1], Pkey(\dur) / 2, \exp, inf),

		// shp: 0.1,
		// shi: Pseg([0.01, 0.1, 0.01], 17, \sin, inf),
		// slo: Pseg([0.01, 0.2, 0.01], 20, \sin, inf),

		shp: 0.9,
		tng: 3,
		dla: 0.5,
		dlt: 1 + Pkey(\dur),
		dlf: 0.5,
		amp: Pseg([0, 0.6, 0.2, 0], [10, 80, 10], \lin, 1),
		cav: 0.1,
		aux: 0,
])).play;

Pdef(1,
	Pbindf(Pdef(0), *[
		dur: 1 / 12,
		mod1: Pseg([0,1,0], Pkey(\dur) / 3, \exp, inf),
		degree: Pwhite(15, 23) - [0, 7, 14, 20],
		cav: Pseg([0.3, 0.7, 0.3], 40, \wel, inf),
		aux: 1,
		amp: Pseg([0.01, 0.5], 100, \lin, 1),
])).play;

Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \sin,
		scale: Scale.mixolydian,
		degree: Pwrand2([1, 5], [20, 1], inf),
		dur: 1 / Pwhite(50, 64),
		aux: 2,
		legato: 2 + Pseg([0, 10], 30, \lin, 1),
		tnh: 0.9,
		tng: 2,
		amp: Pseg([0, 0.5, 0], [5, 50], \sin, 1),
		pan: Pseg([0.3, 0.7], 30, \lin, 1),
	])
).play;

Pdef(3,
	Pbindf(Pdef(0), *[
		stretch: Pseg([1, 1.1, 0.9, 1], 55, \lin, inf),
		amp: Pseg([0, 0.7], 120, \sin, 1),
])).play;

Pdef(4,
	Pbindf(Pdef(0), *[
		stretch: Pseg([0.8, 1.2], 10, \lin, inf),
		amp: Pseg([0, 0.1, 0.8], 100, \sin, 1),
		shp: 0.1,
		shi: Pseg([0.01, 0.1, 0.01], 17, \sin, inf),
		slo: Pseg([0.01, 0.2, 0.01], 20, \sin, inf),
])).play;

)