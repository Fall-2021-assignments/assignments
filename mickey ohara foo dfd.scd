// I admit to not doing too much to this script that Daniel origianlly wrote, but I really like how the dfd synth sounds in it. Also the filter pops, not sure how that's happening. Toggle nsl on at some point, let it go for a while. Adjust cav to taste.

(
Pdef(0,
	Pseed(41,
		Pbind(*[
			type: \cln,
			snd: \dfd,
			seg: Pexprand(39,299), // made up parameter name, exponential choice of floats yielding one value that gets used on many lines below
			dur: Pseg(Pexprand(1/11,1/5),Pexprand(39,299),\exp,inf), // same instruction as above for the segment time but yields a unique result
			hr1: Pseg(Pexprand(1.0,4.0),Pkey(\seg),\exp,inf), // Pkey listens to the above seg: line and uses the resultant number
			hr2: Pseg(Pexprand(1.0,4.0),Pkey(\seg),\exp,inf), // these are all using the same time for changes, but to individual values
			hr3: Pseg(Pexprand(1.0,4.0),Pkey(\seg),\exp,inf),
			hr4: Pseg(Pexprand(1.0,4.0),Pkey(\seg),\exp,inf),
			mi2: Pseg(Pexprand(1.0,4.0),Pkey(\seg),\exp,inf),
			mi3: Pseg(Pexprand(1.0,4.0),Pkey(\seg),\exp,inf),
			mi4: Pseg(Pexprand(1.0,4.0),Pkey(\seg),\exp,inf),
			en1: Pseg(Pexprand(0.001,1.0),Pkey(\seg),\exp,inf),
			en2: Pseg(Pexprand(0.001,1.0),Pkey(\seg),\exp,inf),
			en3: Pseg(Pexprand(0.001,1.0),Pkey(\seg),\wel,inf),
			en4: Pseg(Pexprand(0.001,1.0),Pkey(\seg),\exp,inf),
			cu1: Pseg(Pwhite(0.0,1.0),Pkey(\seg),\exp,inf),
			den: Pseg(Pexprand(0.001,1.0),Pkey(\seg),\exp,inf),
			res: 1,
			typ: 1,
		//	nsl: Pseg(Pwhite(0.001, 0.005),Pkey(\seg),\exp,inf),
			cu2: Pseg(Pwhite(0.0,1.0),Pkey(\seg),\wel,inf),
			cu3: Pseg(Pwhite(0.0,1.0),Pkey(\seg),\exp,inf),
			cu4: Pseg(Pwhite(0.0,1.0),Pkey(\seg),\exp,inf),
			fdb: Pseg(Pwhite(0.0001,1.0),Pkey(\seg),\exp,inf),
			lpf: 20000-Pseg(Pwhite(200,20000),Pkey(\seg),\exp,inf).trace,
			amp: Pseg(Pexprand(0.4,0.9),Pkey(\seg),\exp,inf),
			pan: Pseg(Pwhite(0.0,1.0),Pkey(\seg),\exp,inf),
			rin: Pseg(Pwhite(0.0,1.0),Pkey(\seg),\wel,inf), // here's a slight difference, linear curvature felt like a better match for this parameter
			rev: Pseg(Pwhite(0.0,1.0),Pkey(\seg),\wel,inf),
			dry: Pseg(Pwhite(0.0,1.0),Pkey(\seg),\lin,inf),
			freq: Pseg(Pexprand(50,220),Pkey(\seg),\wel,inf),
			sustain: Pseg(Pexprand(0.1,20.0),Pkey(\seg),\exp,inf),
			stretch: Pseg(Pexprand(1.0,0.25),Pkey(\seg),\exp,inf),
		//	cav: Pwhite(1/12, 5/12),

		])
	)
).play;
)


Pdef(0).stop