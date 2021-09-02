/* assignemtn from 19. august
dirk dullmaier

goals:
1. limit to 1 pdef and only use pseq and prand
2. find a way to not only 1-shot samples, but "traverse" them
3. find a way to make a progression within the limitation

plays for around 2 minutes
samples can be found at: https://github.com/dormirj/samples/tree/main/pseq_prand_19aug
*/
(
Pdef(0,
	Pbind(*[
		type: \cln,
		snd: Pseq([
			Pseq([\pseq_prand_19aug],10),Prand([\pseq_prand_19aug,\ixa],20),Pseq([\ixa],20)
		]),
		//todo: could be fun to randomize this or modulate the playback points
		bgn: Pseq([0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9],inf),
		num: Pseq([
			Pseq([0],10),Prand([1],inf)
		]),
		dur: Pseq([
			Pseq([3,3,2,3,1],30),Prand([3,2,1],10),Pseq([1,0.5,0.25],10)
		]),
		//i dont know if this affects midinote?
		scale: Scale.dorian,
		midinote: Prand([12,14,17,7],inf),
		amp: 0.8 + Pseq([0.01,0.02,0.03,0.05,0.04,0.02,0.01],inf),
		bnd: Prand([0,3.3,0,0,4.7],inf),
		bnt: Prand([0.2,0.1,0.05,0.3],inf),

		pan: Prand([0.48,0.49,0.5,0.51,0.52],inf),
		cav: Prand([0.35,0.45,0.3,0.25],inf),

		//more or less random values, haven't really figured out how ixa functions
		bes: Pseq([Pseq([50],30),Prand([40,60,82,109,114],20)]),
		ber: Pseq([Pseq([50],26),Prand([30,63,80,99,123],20)]),
		abs: Pseq([Pseq([50],27),Prand([50,61,71,95,112],20)]),
		abr: Pseq([Pseq([50],30),Prand([70,60,83,97,121],20)]),
		ths: Pseq([Pseq([50],29),Prand([90,54,80,104,117],20)]),
		thr: Pseq([Pseq([50],30),Prand([10,55,83,101,120],20)]),

		legato: 4
	]),
).play
)