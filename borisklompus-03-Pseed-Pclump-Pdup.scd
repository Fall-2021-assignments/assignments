// still WIP
// if so inclined, allow to play for a long time, it goes through interesting transitions, i think


// thinking about:
// maybe break delay out into separate Pbindf to allow for a bit more smearing?
// or break out dur into separate Pbindf -- this'll let the Pdup do it's thing, but with different timing for each repetition

(
Pdef(0,
	Pseed(1,
		Pdup(Plprand(1, 21),
			Pbind(*[
				type: \cln,
				// snd: Pwrand([\ixa, \kps, \saw, \sin], [10, 5, 1, 3].normalizeSum, inf),
				snd: \ixa,

				dur: Pxrand([0.2, 0.35, 0.45, 0.6, 0.9], inf) * Pwhite(0.5, 4.0).round(0.55),
				dur: Pn(Pdup(4, Pseries(0.125, 0.00625, 40)), inf) * Pdup(40, Pseq([0.375, 0.5, 0.625, 0.75, 0.875, 1, 1.125, 1.5], inf)),

				clump: Pseed(11, Pwhite(1, 4)),
				// clumped: (Pkey(\clump).reciprocal.trace * 2).trace(prefix: "Mrecip "), // just for following values

				// amp: Pxrand((0.4, 0.42 .. 0.85), inf),
				// amp: Pxrand((0.4, 0.42 .. 0.85), inf) * (Pkey(\clump).reciprocal * 1.5),
				// amp: (Pexprand(0.4, 0.7).trace(prefix: "expRand ") * (Pkey(\clump).reciprocal * 2).trace(prefix: "clump ")).min(0.8).trace(prefix: "amp "),
				amp: Pbrown(0.3, Pkey(\clump).reciprocal * 2, 0.01),

				degree: Pclump(Pkey(\clump), Pseq([Scale.choose(7, 12).tuning_(Tuning.choose(12)).semitones], inf) +
					Pwrand([0, -12, 12, -24, 24], [1, 1, 1, 0.5, 0.25].normalizeSum, inf)),

				pan: Pclump(Pkey(\clump), Pxrand((0.0, 0.05 .. 1.0), inf)),

				bnd: Pclump(Pkey(\clump), Pexprand(0.01, 0.7)),
				bnt: Pclump(Pkey(\clump), Plprand(0.0, 3.0)),
				bno: Pclump(Pkey(\clump), Pwhite(0.0, 2.0)),
				bnc: Pclump(Pkey(\clump), Pwhite(-5, 5)),

				sustain: Pmeanrand(0.8, 2.0),

				atk: Pclump(Pkey(\clump), Pkey(\dur) * Pwrand([0.01, 0.1, 0.5, Pkey(\sustain)], [2, 1, 0.25, 0.5].normalizeSum, inf)),
				rel: Pclump(Pkey(\clump), (Pkey(\dur) * Pkey(\sustain) + (Pwhite(0, 1) * Phprand(-1.0, 1.0))).max(0.1)),

				bes: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0, 10))),
				ber: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0, 10))),
				abs: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0, 10))),
				abr: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0, 10))),
				ths: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0, 10))),
				thr: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0, 10))),
				
				// realized i forgot the decimal points on the Pwhite values for the slope and threshold stuff above...
				// fun accident and variation!
				// bes: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0.0, 10.0))),
				// ber: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0.0, 10.0))),
				// abs: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0.0, 10.0))),
				// abr: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0.0, 10.0))),
				// ths: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0.0, 10.0))),
				// thr: Pclump(Pkey(\clump), Pdup(Pwhite(1, 7), Pwhite(0.0, 10.0))),

				dla: Pkey(\amp) * 0.8,
				dlt: Pkey(\dur) * Pkey(\sustain) + Pwhite(0.0, 1.5).round(0.15),
				dlf: Pbrown(0.2, 1.0, 0.03) + (Pkey(\clump).reciprocal * 0.25),

				cav: 4,
				cai: 0.8,
				cvt: 0.2,
				cvd: Pwhite(0.0, 1.0),
				cvl: Pwhite(0.5, 1.0),

				tnh: Pwhite(0.5, 1.0),
				tng: Prand([10, 100, 1000], inf),
				tnb: Pwhite(0.5, 0.8),
				tna: Pwhite(0.7, 0.9),

				rma: 0.5,
				rmf: 500,
				rdf: Pkey(\rmf) * Pwhite(1, 5) * Prand([-1, 1], inf),
				rdt: Pwhite(0.0, 2.5),

			])
		)
	)
).play
)
