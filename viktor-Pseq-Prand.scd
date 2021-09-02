(
Pdef(0,
			Pbind(*[
				type: \cln,
				snd: \mmd,
				num: 4,
				tri: Prand([0.001,0,002,0.003,0.004,0.005],inf),
				dur: 1/10,
				pan: Prand([Pwhite(0.0, 0.333), Pwhite(0.666, 1.0)]),
				amp: Pseq([20|10|200],300),
				lpf: Pseq([20|5|200],30000),
			]), 1, 15,
).play(quant:1);
);