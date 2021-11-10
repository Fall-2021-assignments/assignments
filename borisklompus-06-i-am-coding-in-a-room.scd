```


// Very much in progress.
// Just beginning to experiment with recursive recording techniques

// Pdef(0) creates a sound source, which is recorded. That recording is fed into a different Pdef. It's played back and recorded.
// Then that recording is fed into a Pdef -- can be the same one, or different -- and on and on.
// When dealing with small bits of sound, how much randomness actually changes the overarching sound? What causes things to feel
// the same, or similar?


// To use: make a new folder somewhere on your computer, and drag and drop onto line with ~folder. Evaluate block code block, and then
// evaluate Pdef(0)'s code block.
// Run the ~n = ~record line of code, then evaluate Pdef(1), and go from there.

// Note that for Pdef(1), \num doesn't automatically update: 
// You must evaluate the line: Pdef(1).map([\num: (~n - 1).value.postln]) for the newest recording to swap in.
// (Re-evaluating the actual Pdef(1, Pbind etc) block of code will also work to update to the newest sample)

// Adjust all code to taste, or drop your own patterns in place of these...


// initializer
(
~initialize = {
	// folder location for recording -- make a new folder and drop the path here
	~folder = "/Users/borisklompus/Projects/SuperCollider/Learning/SuperClean/homework/homework progressive exploration/w06/"; // <<<<<<<<< ADD FOLDER PATH HERE!!!

	// do clever things to isolate folder name and save it in a way that \snd will understand (this'll post, so verify)
	~cFol = ~folder[~folder.findRegexp("/").reverse[1][0] + 1 .. ~folder.findRegexp("/").reverse[0][0] - 1].asSymbol.postln;

	// file number
	~n = 0;

	// create clock to play Pdef(0) on:
	~clock = TempoClock(72).permanent_(true); // permanent must be on or else cmd-period clears the clock!

	// auto recorder function-
	~record = { |pdef, clock, path, file, dur|
		// wrap routine inside of a function to be able to pass it arguments
		Routine {
			file = file.value; // decode the thunk
			pdef.play(clock); // receive Pdef as arg, and .play it on a clock. if clock is nil, it'll play on default clock
			s.sync; // wait until server is ready to start recording
			s.record(path ++ file ++ ".wav", duration: dur); // begin recording for dur seconds to the specified location & give file the specified name
			(dur + 1).wait; // wait until recording is complete, plus a bit
			pdef.stop; // stop the Pdef
			~clean.lsf(path); // load the folder into ~clean!
			file = file + 1; // increment file counter to make ready for next recording
		}.value;
		{ file }.thunk // this defers evaluating the function until value is called on it, ultimately allows passing the value out of the routine...
	};
};

// make it a function to quickly reset things later
~initialize.value
)


(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: \fmx,

		dur: Pseq([3, 2].mirror2, inf) * 0.5,
		stretch: Pdup(16, Prand([0.5, 1, 1.5], inf)),

		legato: Pwrand2([1, 0.8, 0.2, 2], [8, 1, 1, 1.2], inf),

		scale: Scale.rast,
		degree: Pbrown(
			Plprand(-7, 7),
			Phprand(-7, 7),
			Pdup(Prand([16, 32, 64], inf) * 4, Pwrand2([1, 0.25, 0.5, 1.25, 1.01], [10, 1, 2, 2, 3], inf))
		).round(0.25),
		// degree: Pseq([0, 3, -7], inf),
		octave: Pdup(Prand([16, 32, 64], inf), Pxrand((2 .. 7), inf)),

		mtranspose: Pdup(Prand([16, 32, 64], inf), Pseries(0, 1)),
		stepsPerOctave: Pdup(Prand([16, 32, 64], inf), Pseq([Scale.rast.pitchesPerOctave, Scale.rast.stepsPerOctave], inf)),

		rel1: 5 + (Pkey(\stretch) * Prand([1, -1], inf)),
		rel2: Pwhite(0.5, Pkey(\rel1)),
		rel3: Pwhite(0.5, Pkey(\rel2)),
		rel4: Pwhite(0.5, Pkey(\rel3)),

		en1: Pseq((0.001, 0.005 .. 0.1), inf),
		en2: Pseq((0.001, 0.005 .. 0.1), inf, 8),
		en3: Pseq((0.001, 0.005 .. 0.1), inf, 16),
		en4: Pseq((0.001, 0.005 .. 0.1), inf, 12),

		cu1: Pmeanrand(-8, 8),
		cu2: Pxrand([Pkey(\cu1), 8, -8], inf),
		cu3: Pxrand([Pkey(\cu2), 8, -8], inf),
		cu4: Pxrand([Pkey(\cu3), 8, -8], inf),

		mi1: Pseg([0, 1], Pwhite(10, 20), \sin, inf),
		mi2: Pseg([0, 1], Pwhite(10, 20), \sin, inf),
		mi3: Pseg([0, 1], Pwhite(10, 20), \sin, inf),
		mi4: Pseg([0, 1], Pwhite(10, 20), \sin, inf),

		hr1: Prand([0.5, 1, 1.25, 1.5, 2, 3], inf),
		hr2: Prand([0.5, 1, 1.25, 1.5, 2, 3], inf),
		hr3: Prand([0.5, 1, 1.25, 1.5, 2, 3], inf),
		hr4: Prand([0.5, 1, 1.25, 1.5, 2, 3], inf),
	])
)
)


// change tempo here- (note dur is whole numbers-ish in Pdef)
~clock.tempo = 72

// test
Pdef(0).play(~clock); // listen
Pdef(0).stop; // stop


~n = ~record.(Pdef(0), ~clock, ~folder, ~n, 10); // run

// test to verify ~n has incremented
~n.value; //

// new Pattern to play recording
(
Pdef(1,
	Pbind(*[
		type: \cln,
		snd: ~cFol,
		num: (~n - 1).max(0).value.postln, // play last recorded
		// spd: Pwrand2([1, 0.5, -0.5, -0.25, 2, -3], [100, 25, 10, 9, 15, 2], inf),
		bgn: Pseq((0.001, 0.002 .. 1.0), inf),
		dur: Pseq([0.25, 0.5, 0.125, 0.375], inf) * Pdup(Prand([40, 80, 120], inf), Prand((0.1, 0.2 .. 2.0), inf)),
		atk: Pxrand([0.01, 0.05, 0.1, 0.3], inf),
		rel: Pwhite(4, 11),
		crv: Pwhite(2, 7),

		amp: 0.65,
		// amp: Pseg([0.3, 0.7], 1.5, Pwhite(-4, 4), inf),
		// amp: Pseg([0.3, 0.7], Pkey(\dur) * 0.5, Pwhite(-4, 4), inf),

		legato: Pseq([1, 7, 2, 9, 0.2], inf),
		// sustain: Prand([Pkey(\dur), 1.0, 5.0, 0.1], inf),

		spd: Pdup(Pwhite(10, 100).round(10), Pseq([Pseq((1.0, 0.9 .. 0.1)), Pseq((-0.1, -0.2 .. -1.0))], inf)),
		freq: Pkey(\spd).linexp(-1, 1, 125, 800).trace,
	])
)
)

// manually reload folder here
~clean.lsf(~folder)


// make a new clock if you want
~clock2 = TempoClock(10).permanent_(true)

// update new tempo here
~clock2.tempo = 15

a = Pseq([10, 1, 5, 25, 125, 75, 0.5], inf).trace
//doesn't work
// Pdef(\clocker, Pbind(*[clock: Pfunc { ~clock2.tempo = Pseq([10, 1, 5, 25, 125, 75, 0.5], inf) }.trace, dur: 3])).play



//
Pdef(1).play(~clock2) // on new clock
Pdef(1).play(~clock) // on original clock
Pdef(1).play // on default clock
Pdef(1).stop

~n = ~record.(Pdef(1), ~clock2, ~folder, ~n, 120); // run, on new clock
// ~n = ~record.(Pdef(1), ~clock, ~folder, ~n, 120); // run, on original clock
// ~n = ~record.(Pdef(1), TempoClock.default, ~folder, ~n, 120); // run, on default clock
// ~n = ~record.(Pdef(1), path: ~folder, file: ~n, dur: 120); // run, on default clock

// Pdef(1).map([\num: (~n - 1).value.postln]).play // then run this after completed to get new file playing (on original clock)
Pdef(1).map([\num: (~n - 1).value.postln]) // run this after completed to update to next sample, but not play




// reset count with this:
~initialize.value






// // // // notes

// break path into piece by slashes, store position of each slash as an array
// the last two slashes are the ones we want, they surround our folder name
~folder.findRegexp("/")

// make them first
~folder.findRegexp("/").reverse

// the second array entry is the slash before our folder of interest == [1][0]
// the first array entry is the slash after == [0][0]
// second bracketted 0 (eg- [x][0]) just isolates the number from the character
~folder[~folder.findRegexp("/").reverse[1][0] + 1 .. ~folder.findRegexp("/").reverse[0][0] - 1]

// \snd expects a symbol
~folder[~folder.findRegexp("/").reverse[1][0] + 1 .. ~folder.findRegexp("/").reverse[0][0] - 1].asSymbol


Thunk.help


```
