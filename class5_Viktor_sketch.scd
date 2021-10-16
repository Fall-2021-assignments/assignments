s.record
~clean.lsf("/Users/annawedin/Desktop/Viktor SC/rec/")

(
Pdef(1,
    Pbind(*[
        type: \cln,
        snd: \fmx,
		dur: 1/10000*Pseq((1..7),inf),
		freq: (Pseg([30,50,40],[4,4],\lin,inf) * (Pseq((1..100)++(100..1),inf))).round(100), // one to a hundred, wired
		amp: Pseg([0.3,0.5,0.5],[5,5],\wel,inf),
		stretch: Pseg([0.5,4,0.5],[5,5],\lin,inf),

	])
).play(quant:1);
)


(
Pdef(3,
    Pbind(*[
        type: \cln,
        snd: \drm,
		dur: Pwhite(0.9,1.1)*1/(1*Pseq((1..7),inf)),
		//stretch: Pseg([0.5,0.2,0.5],[5,5],\lin,inf),
	])
).play(quant:1);
)


//this last one was maybe a tad salty
(
Pdef(2,
    Pbind(*[
        type: \cln,
        snd: \rec,
		bgn: Pwhite(0.0, 1.0),
		legato:3,
		dur: 1 / Pwhite(5, 11),
		amp: Pseg([1,2,1],[5,5],\wel,inf),
		stretch: Pseg([2,0.4,4],[3,5],\wel,40),
		//cav:0.4,
	])
).play(quant:1);
)

