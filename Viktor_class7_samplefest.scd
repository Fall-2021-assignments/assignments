// first download some 192 kHZ samples: https://github.com/NJVD91/Supercollider_stuff/tree/main/192

// load the samples

~clean.lsf("/Users/annawedin/Desktop/Viktor SC/recjim/192/aaa/"); //load the aaa folder in 192
~clean.lsf("/Users/annawedin/Desktop/Viktor SC/recjim/192/prc/"); //load the prc folder in 192
~clean.lsf("/Users/annawedin/Desktop/Viktor SC/recjim/192/cgh/"); //load the cgh folder in 192
~clean.lsf("/Users/annawedin/Desktop/Viktor SC/recjim/192/bln/"); //load the bln folder in 192


//get some global variables running

~lfilter = Pseq((100 .. 5000).mirror1, inf).asStream;
~hfilter = Pseq((5000 .. 100).mirror1, inf).asStream;

Pdef(1).play; //give it half a minute
(
Pdef(2).play;
Pdef(3).play;
)

(
Pdef(4).play;
Pdef(5).play;
)

Pdef(6).play;

/*( i tried using the Ptpar, but got an Out of context return value error. So it's better to use the above Pdef.play

Pdef(0,
	Ptpar([
		0.0, Pdef(1), // start Pdef(0) at beat 0
		30, Pdef(2), // start Pdef(1) at beat 30
		30, Pdef(3), // start Pdef(2) at beat 30
		60, Pdef(4), // start Pdef(4) at beat 60
		60, Pdef(5), // start Pdef(5) at beat 60
		60, Pdef(6), // start Pdef(6) at beat 60
		])
).play;
)*/


// Evaluate the Pdefs below first, then activate them one at a time above. it might be a bit subtle in the beginning

(
Pdef(1,
	Pseed(17,
		Pbind(*[
			type: \cln,
			snd: \aaa,
			num: Pseq([0,1,2,3],inf),
			spd: 1,
			degree: Pdup(Pwhite(10,40), Pwrand2([2,4,6,8,2],[8,3,2,5,2],inf)),
			scale:  Scale.mixolydian,
			lpf: Pfunc({~lfilter}),
			sustain: 7,
			rel: 8,
			pan: Pfunc({~lfilter}),
		])
	)
);


Pdef(2,
	Pseed(17,
		Pbind(*[
			type: \cln,
			snd: \bln,
			num: Pwhite(0,20),
			stretch: 0.1,
			hpf: Pfunc({~hfilter}),
			pan:Pfunc({~hfilter}),

		])
	)
);


Pdef(3,
	Pseed(17,
		Pbind(*[
			type: \cln,
			snd: \bln,
			num: Pseq([11],inf),
			spd: 0.1,
			bgn:0.1,
			amp:2,
			scale: Scale.chromatic,
			bnd: Pkey(\degree)*Pwhite(1.1,1.3),
			bnt: Pexprand(1,2),
			dur: 3,
			//legato:1,
			degree: Pseq([4,2,2,4,2,2],inf),
			sustain: 4,
			rel:4,
			hpf: Pfunc({~hfilter}),
			pan:Pfunc({~lfilter}),
			//sustain: 7,
		])
	)
);


Pdef(4,
	Pseed(17,
		Pbind(*[
			type: \cln,
			snd: \prc,
			num: Pseq([1,6,3,6],inf),
			spd: 2,
			dur: 1/(Pseg([1,15,15,1],[10,10,10],\sin,inf)),
			bnd: Pkey(\dur),
			degree: Pseq([-1,2,4,6],inf)*Pwhite(0.5,2),
			bpf: Pfunc({~lfilter}),
			pan: Pseg([0,1,1,0],[10,10,10],\sin,inf),
		])
	)
);


Pdef(5,
	Pseed(17,
		Pbind(*[
			type: \cln,
			snd: \cgh,
			num: Pseq([Pwhite(1,2),\r,Pwhite(1,2),2,\rest],inf),
			spd: Pwhite(0.5,1),
			dur:1/(Pseq([2,4,2,2,4],inf))*Pkey(\spd),
			degree: Pseq([-1,2,4,6],inf),
			tnh: 0.2,
			amp:1,
			tng: Pseg([0.0,10,600],[30,30],\sin,inf),
			tna: Pseg([0.0,10,400],[30,30],\sin,inf),
			bpf: Pfunc({~hfilter}),
			pan: Pfunc({~hfilter}),
		])
	)
);

Pdef(6,
	Pseed(17,
		Pbind(*[
			type: \cln,
			snd: \cgh,
			num: [2],
			degree:Pseq([1,2,3,4],inf)*Pwhite(1,4),
			dur: 5/(Pfunc({~lfilter})+2),
			amp: Pseg([0.2,0.5],[20],\wel,2),
			tnb: Pfunc({~hfilter}),
			tnh: 5,
			tng: Pseg([10,800],[20],\sin,inf),
			tna: Pseg([0.0,10,400],[30,30],\sin,inf),
			pan: Pmeanrand(0.0,1.0,inf),
		])
	)
);


)



Server.killAll

/*tnh:	 Wet mix of the tanh based distortion. Unlike  other distortions this is added after synths are summed. Try a fifth through this.
tnb:	Low pass filter before the tanh based distortion.
tng:	Tanh gain stage, this makes tons of ditortion. Range is 0.0 to 999.0
tna:	Low pass filter after the tanh based distortion.*/