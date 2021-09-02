(
Pdef(\glitch,
	Pbind(*[
		type: \cln,
/*		snd: Prand([
			\fmx,
			\saw,
			\drm,
			\kps,
			\hat,
			\sin,
			\bow,
			\ixa,
			\dfd,

		], inf),*/
		snd: Pseq(
			[
				\drm,
				Prand([\fmx,\saw,\kps,\hat,\sin,\bow,\ixa], 87),
				\drm,
				Prand([\fmx,\saw,\kps,\sin,\bow,\ixa,\dfd,\drm,], 98),
		], inf),
		freq: Prand([50,310], inf),
		dur: 1 / Pseq([Prand([7,8],1)]++(8!7),inf),
		//dur: 1 / Pseq([8,8,8,8,8],inf),

		tun: Prand([1,2,3,4,5,6,7], inf), //drm, hat
		fed: Prand([0,1,2,3, 5,12,40], inf), //drm
		pew: Prand([1, 20.0], inf), //drm

		bnd: Pwhite(1.5, 1.5), //kps
		bnt: Prand([1.0, 2, 5, 7, 10.0], inf), //kps
		bno: Prand([1.0, 2,3,4,5, 10.0], inf), //kps
		bnc: Prand([1.0, 2,3,4,5, 10.0], inf), //kps
		iph: Prand([1.0, 2,3,4,5, 5.0], inf),
		wid: Prand([1.0, 2,3,4,5, 5.0], inf),

		// ixa
		bes: Prand([0.1, 10, 20, 3, 80], inf),
		ber: Prand([0.1,2, 3,6, 45, 10.0], inf),
		abs: Prand([0.1,2,4, 7, 14, 17, 21.0], inf),
		abr: Prand([0.1, 3, 5, 10.5, 40], inf),
		ths: Prand([0.1, 5,  10.5, 20], inf),
		thr: Prand([0.1, 10.5, 20], inf),

		//dfd
		den: Pwhite(-1.5, 10.5),
		//den: 1,
		res: 3,
		typ: Pwhite(0.2, 6.0),
		nsl: Pxrand([0.0001, 0.01], inf),
		sustain: Pxrand([0.01,0.5],inf);
	])
).play(quant: 2)
)


(
Pdef(\stratos,
	Pbind(*[
		type: \cln,
		snd: \ixa,
		freq: Pexprand(70,400, inf),
		dur: Pseq([1,2,4,5,6,7,2,1], inf),
		bes: Prand([1, 4, 7, 20], inf),
		ber: Prand([1, 2, 4, 5, 15, 20], inf),
		abs: Prand([1, 2, 4, 5, 15, 20], inf),
		abr: Prand([1, 2, 4, 5, 15, 20], inf),
		bnd: Prand([0, 3,5,6,7], inf),
		bnt: Prand([0,2,5, 6, 7], inf),
		fdb: Pexprand(0.0001,100.0),
		sustain: Pexprand(2.5,5.0, inf),
		legato: Pkey(\dur)*Pexprand(16,64),
		atk: Pexprand(0.01,4.0),
		hld: Pkey(\dur)*2,
		rel: Pkey(\dur)*2,
		rts: 6,
		hal: 100,
		pan: Pexprand(0.2,0.8,inf);
	])
)
)
Pdef(\stratos).play;
Pdef(\stratos).stop;

