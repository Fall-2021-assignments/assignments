// How do your errors sound?
// Adjust the 8/9 fraction in 'stretch' with higher and lower numerators. Let it run for a while. It should slow down and get quieter, then speed up and come back with a vengeance. Watch your CPU skyrocket for a bit, don't be alarmed, it will go down again. Unless it sounds bad, then you should change it.


(
Pdef(0,
	Pseed(111,
		Pbind(*[
			type: \cln,
			snd: \drm,
			tun: Pstutter(Plprand(1/11, 3), Plprand(0.0, 55.0)),
			fed: Pstutter(Plprand(1, 11), Plprand(0.0, 555.0)),
			dur: 1 / Pstutter(Plprand(1, 1111), Plprand(5, 11)),
			pan: Pseg(Pmeanrand(0.0, 1.0), Plprand(10.0, 100.0), \wel, inf).trace,
			stretch: Pseg(Plprand(0.01, 8/9), Plprand(10.0, 100.0), \wel, inf).trace,
			sustain: Pseg(Plprand(0.001, 11.0), Plprand(11.0, 1001.0), \wel, inf).trace,
			legato: Pseg(Plprand(0.001, 111.0), Plprand(100.0, 1000.0), \wel, inf).trace,
			rel: Pseg(Plprand(0.001, 1.0), Plprand(10.0, 1000.0), \wel, inf).trace,
		//	tnh: Pseg(Phprand(0.001, 11.0), Plprand(10.0, 1000.0), \wel, inf).trace,
			amp: Pseg(Plprand(0.2, 2.0), Plprand(10.0, 100.0), \wel, inf).trace,
		//	cav: Pseg(Plprand(0.001, 1.0), Plprand(100.0, 1000.0), \wel, inf).trace,
		//	cai: Pseg(Plprand(0.001, 1.0), Plprand(100.0, 1000.0), \wel, inf).trace,
		])
	)
).play
)

Pdef(0).stop;
