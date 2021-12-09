(
Pdef(1,
    Pseed(111,
        Pbind(*[
            type: \cln,
            snd: \dfd,
			dur: 1 * Pwrand((1 .. 2),(8 .. 1).normalizeSum, inf),
            amp: Pwhite(0.344, 0.700),
            octave: Pdup(Pwhite(1, 8, 2), Pwhite(2.0, 5.2,6.8).round(1/2)),
            sustain: 2,
            legato: 4,
			num: Pseq([1, 0, 7,4,3,2,], inf),
            atk: Pwhite(0.0, 5.0),
            rel: 9,
            cav: 2,
			pan: Pdup(Pwhite(0, 50), Pwrand([Pwhite(1.0, 0.400), Pwhite(0.506, 1.0)], [1, 1.5].normalizeSum, inf)),
			tri: 0.09,
			tri: 0.18,
			//dst: 0.1,
            cai: Pdup(Pwrand([1, 21], [1, 9].normalizeSum, inf), Pwhite(0.0, 1.0)),
            sas: Pdup(Pwrand([1, 200], [1, 11].normalizeSum, inf), Pwhite(0.0, 2.0)),
            sar: Pdup(Pwrand([1, 10], [1, 10].normalizeSum, inf), Pwhite(0.0, 0.5)),
            ths: Pdup(Pwrand([1, 8], [1, 80].normalizeSum, inf), Pwhite(0.0, 2.0)),
            thr: Pdup(Pwrand([1, 10], [1, 10].normalizeSum, inf), Pwhite(0.0, 0.5)),
            ocu: Pwhite(0.75, 1.0),
            sha: 30,
			pan: Prand([0.8, 3.0, 2.2, 1.0,0.0,], inf),

            shp: Pwhite(0.0, 1.0),
            sho: Pwhite(0.0, 10.0),
            //shi: Pwhite(0.0, 1.0),
            //lot: Pwhite(0.0, 1.0),
            //hit: Pwhite(0.0, 1.0),
            bnd: Pwhite(-0.032258064516129, 0.032258064516129),
            bnt: Pwhite(1/9, 1),
            bno: Pwhite(1/9, 1),
            bnc: Pwhite(-4.0, 4.0),
            dla: 1/8,
            dlf: 0,
            dlt: 16,
            lpf: Pwrand((20, 21 .. 20000), (20, 21 .. 20000).normalizeSum, inf).trace,
        ])
    )
).play
)




