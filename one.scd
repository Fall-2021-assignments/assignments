(
Pdef(0,
    Pbind(*[
        type: Prand([\cln, \rest, \rest], inf),
        snd: Prand([\drm, \dfd, \sin, \saw, \hat, \fmx, \bow, \kps], inf),
        dur: 1 / Prand([1, 3, 5, 7, 9, 11, 13, 15, 17, 19], inf),
        tun: Prand([1, 2.7, 4.3, 6.7, 8.9, 10.3, 12.8, 14.6], inf) 
            / Pseq([1, 2, 4, 8, 16, 8, 4, 2], inf),
        atk: Prand([1, 3, 5, 7, 9, 11], inf),
        rel: Prand([1, 3, 5, 7, 9, 11], inf),
        sustain: Prand([1, 3, 5, 7], inf),
        cav: 4,
        cai: Pseq ([0.1, 0.2, 0.3, 0.4, 0.5, 0.4, 0.3, 0.2], inf) * 2,
        rma: Pseq([0.0, 0.25, 0.5, 0.75, 1.0], inf),
        rmf: Prand([20, 40, 80, 160, 320, 640], inf),
        lhf: Pseq([0.0, 0.05, 0.1, 0.15, 0.2, 0.25], inf) * Prand([1, 3, 5, 7], inf),
        ocq: 1 / Prand([1, 1.1, 1.2, 1.3], inf),
        tnh: 0.025,
        tng: 10 / Prand([1, 1, 1, 2, 2, 3], inf),
        amp: 1 / Prand([1, 1.25, 1.5, 2.0], inf),
    ])
).play
)
