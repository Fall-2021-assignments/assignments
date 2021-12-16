~degree = Pseq([-10,-10,-10,-10,6,6,6,6,5,5,5,5,-1,-1,-1,-1,-6,-6,-6,-6,7,7,7,7,1,1,1,1,0,0,0,0,1,1,1,1], inf).asStream; //
~clean.lsf("/Users/annawedin/Desktop/Viktor SC/rec/" ); //load the bln folder in 192
~clean.lsf("/Users/annawedin/Desktop/Viktor SC/recjim/192/prc/");
~duration = Pseq((1..4),inf).asStream;


(


Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \fmx,
		wid: 0.25,
		degree: Pfunc({~degree}),
		Pan: Pmeanrand(0,1),
	])
).play;

Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \drm,
		degree: Pfunc({~degree}),
		dur: 1/ Pwhite(1,2),
		Pan: Pmeanrand(0,1),
	])
).play;

Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \drm,
		degree: Pfunc({~degree}),
		tun: 4*Pwhite(1,1.1),
		dur: 1/Pshuf([1,2,4,8],inf),
		//hal: 0.4,
		//rts: 2,
		//	rel:2,
		Pan: Pmeanrand(0,1),

	])
).play;

Pdef(4,
	Pseed(1,
		Pbind(*[
			type: Pseq([\cln,\r,\r,\r,\r,\r,\r],inf),
			snd: \rec,
			num:2,
			stretch: Pwhite(2,4),
			fzv:2,
			hal:1,
			rts:5,
			pan:Pwhite(0.0,1.0),
			octave: Pdup(Pwhite(1,4),Pwhite(4.0,8.0)),
			//	bnd: Pwhite(0.1,0.5)*Pwhite(-0.5,0.5),
			//degree: Pfunc({~degree}),
			//tun: 4*Pwhite(1,1.1),
			//dur: 1/Pshuf([1,2,4,8],inf),
			//hal: 0.94,
		])
	)
).play;

Pdef(5,
	Pbind(*[
		type: \cln,
		snd: \hat,
		dur: Pwhite(1.0,1.5)/(Pseg([4,40,100,40,4],[40,40,40,40],\sin,inf)),
		amp: Pseg([0,0.5,1,0.1,1],[40,40,40,40],\wel,inf),
		legato: Pkey(\dur),
		degree: Pfunc({~degree}),
		tun: 4*Pwhite(1,1.1),
		hal: 0.4,
		//rts: 2,
		//	rel:2,
		Pan: Pmeanrand(0,1),

	])
).play;

)
