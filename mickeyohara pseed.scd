// Play and stop the different Pdefs at different times. Play all of them simultaneously at some point.


(
Pdef(2,
	Pbind(*[
		type: \cln,
		snd: \sqr,
		scale: Pstutter( 99, Pseq([
			Scale.shang.tuning_(Tuning.wcSJ),
			Scale.minor.tuning_(Tuning.sept1),
  		    Scale.melodicMinor.tuning_(Tuning.mean4),
	], inf)),
		degree: Plprand(0, 117),
		octave: Plprand(3, 5),
		dur: 1 / Pwhite(5, 11),
		pan: Pmeanrand(0.0, 1.0),
		amp: Pwhite(0.1, 0.4),
		lpf: Plprand(20, 20000),
		rel: 16,
		tnh: Pwhite(1/5, 1),
		tnh: Pwhite(0.003, 1/2),
		tng: Pwhite(0.0, 50.0),
		legato: 24,
		stretch: Pseed(0, Prand([1, 1.01], inf)),
		atk: 17/3,
	//	cav: Plprand(1/9, 18/9),
	//	cai: Phprand(1/9, 18/9),
	//	cvt: Plprand(1/9, 8/9),
		stretch: Pseed(1, Pstutter(Pwhite(1, 19), Pseq((0 .. 11), inf))),
	])
).play
)

Pdef(2).stop;


(
Pdef(3,
	Pbind(*[
		type: \cln,
		snd: \sin,
		scale: Pstutter( 99, Pseq([
			Scale.shang.tuning_(Tuning.wcSJ),
			Scale.minor.tuning_(Tuning.sept1),
  		    Scale.melodicMinor.tuning_(Tuning.just),
	], inf)),
		degree: Plprand(1, 3),
		octave: Plprand(3, 5),
		dur: 1 / Pwhite(1/9, 2),
		pan: Pmeanrand(0.0, 1.0),
		amp: Pexprand(0.03, 0.4),
		lpf: Plprand(20, 20000),
		rel: 16,
		tnh: Pwhite(0.003, 1/9),
	//	tng: Pwhite(0.0, 50.0),
		legato: 24,
	//	atk: 7/3,
		hld: 1/93,
		cav: Plprand(1/9, 2),
		cai: Phprand(1/9, 2),
		cvt: Plprand(1/9, 2),
	])
).play
)

Pdef(3).stop;


(
Pdef(4,
	Pbind(*[
		type: \cln,
		snd: \bow,
		scale: Pstutter( 99, Pseq([
			Scale.shang.tuning_(Tuning.wcSJ),
			Scale.minor.tuning_(Tuning.just),
  		    Scale.melodicMinor.tuning_(Tuning.harrison),
	], inf)),
		degree: Plprand(0, 57),
		octave: Plprand(3, 5),
		dur: 1 / Pwhite(1/5, 11),
		pan: Pmeanrand(0.0, 1.0),
		amp: Pexprand(0.03, 0.4),
		lpf: Plprand(20, 20000),
		rel: 16,
		tnh: Pwhite(0.003, 1/4),
		tng: Pwhite(0.0, 50.0),
		legato: 2,
	//	atk: 5/3,
		cav: Plprand(1/9, 2),
		cai: Phprand(1/9, 2),
	//	cvt: Plprand(1/9, 2),
		cvl: Phprand(1/9, 2),
		stretch: Pseed(0, Prand([1, 1.01], inf)),
	])
).play
)

Pdef(4).stop;


(
Pdef(5,
	Pbind(*[
		type: \cln,
		snd: \ixa,
		scale: Pstutter( 99, Pseq([
			Scale.harmonicMinor.tuning_(Tuning.wcSJ),
			Scale.minor.tuning_(Tuning.partch),
  		    Scale.melodicMinor.tuning_(Tuning.mean4),
	], inf)),
		degree: Plprand(0, 67),
		octave: Plprand(3, 5),
		dur: 1 / Pwhite(1/12, 11),
		pan: Pmeanrand(0.0, 1.0),
		amp: Pexprand(0.03, 0.5),
		lpf: Plprand(20, 20000),
		rel: 16,
		tnh: Pwhite(0.003, 1/3),
		tng: Pwhite(0.0, 50.0),
		legato: 24,
		atk: 2/3,
		cav: Plprand(1/9, 2),
		cai: Phprand(1/9, 2),
	//	cvt: Plprand(1/9, 2),
	])
).play
)

Pdef(5).stop;


(
Pdef(6,
	Pbind(*[
		type: \cln,
		snd: \kps,
		scale: Pstutter( 99, Pseq([
			Scale.shang.tuning_(Tuning.wcSJ),
			Scale.minor.tuning_(Tuning.sept1),
  		    Scale.melodicMinor.tuning_(Tuning.just),
			Scale.chinese.tuning_(Tuning.lu),
			Scale.whole.tuning_(Tuning.sept2),
  		    Scale.romanianMinor.tuning_(Tuning.harrison),
	], inf)),
		degree: Plprand(0, 7),
		octave: Plprand(3, 5),
		dur: 1 / Pwhite(5, 11),
		pan: Pmeanrand(0.0, 1.0),
		amp: Pexprand(0.2, 0.4),
		lpf: Plprand(20, 20000),
		rel: 16,
		tnh: Pwhite(1/5, 1),
		tng: Pwhite(0.0, 50.0),
		legato: 24,
		atk: 4/3,
		cav: Plprand(1/9, 2),
		cai: Phprand(1/9, 2),
		cvt: Plprand(1/9, 2),
	])
).play
)

Pdef(6).stop;


(
Pdef(7,
	Pbind(*[
		type: \cln,
		snd: \dfd,
		scale: Pstutter( 99, Pseq([
			Scale.shang.tuning_(Tuning.wcSJ),
			Scale.minor.tuning_(Tuning.sept1),
  		    Scale.melodicMinor.tuning_(Tuning.just),
			Scale.chinese.tuning_(Tuning.lu),
			Scale.whole.tuning_(Tuning.sept2),
  		    Scale.romanianMinor.tuning_(Tuning.harrison),
	], inf)),
		degree: Plprand(0, 7),
		octave: Plprand(3, 5),
		dur: 1 / Pwhite(1/5, 111),
		pan: Pmeanrand(0.0, 1.0),
		amp: Pexprand(0.03, 0.3),
		lpf: Plprand(20, 20000),
		rel: 11,
	//	tnh: 0.3,
		tng: Pwhite(0.0, 50.0),
		legato: 14,
		atk: 7/3,
	//	cav: Phprand(1/9, 1),
	//	cai: Phprand(1/9, 1),
	//	cvt: Phprand(1/9, 1),
	])
).play
)

Pdef(7).stop;