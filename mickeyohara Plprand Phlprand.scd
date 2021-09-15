// Toggle shp & sac & shi --- & sho & slo & tri, interchangeably, for timbre changes...
// Toggle pew for laser sounds...
// Toggle cai & cav for reverb...
// Toggle octave for more variation, although that might crash things.
// Sometimes it might stop, on a low value, that's okay. It should start again.

(
Pdef(0,
    Pbind(*[
        type: \cln,
        snd: \drm,

	//	shp: Phprand(1, 1114),
    	sac: Pwhite(1, 3333),
    //  shi: Pwhite(1/10, 5555),
     	sho: Pwhite(1, 5565),
	//	slo: Pwhite(1/5, 2219),
		tri: Pwhite(1/5, 4219),

		tun: Plprand(Pseq([1/3, 3/5, 5/7, 7/9, 9/11, 11/13, 13/15, 15/17, 17/19], inf), Pseq([4/5, 7/4, 4/7, 7/9, 9/11, 11/15, 15/13, 13/17, 17/15, 15/11, 11/19, 19/17], inf), inf),
		fed: Pwhite(1/12, 13/12),
	//	pew: Pwhite(1/17, 7/3),
        dvl: Pwhite(1/5, 219),
        drp: Pkey(\dvl).linlin(5, 19, 1, 10),
        dur: 4 / Pstutter(Pkey(\drp), Pkey(\dvl)).trace,
		sustain: Phprand(1, 4),
		rel: Phprand(1, 5),
	//	cai: Pwhite(1/100, 5/100),
	//	cav: Pwhite(1/1000, 1),
		amp: Pwhite(0.2, 8.7),
	//	octave: Pstutter(Pwhite(1, 1123), Pwhite(1/3, 6).round(1/31))

    ])
).play
) 