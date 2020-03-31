<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1


#include "DistributionModels.udo"

seed(0)

  instr 1

im = 10
iM = 100

iter = 100

;kFreq = LinDiseg:k(220, 550, 1000, 3, 1)
;kFreq = TriDis:k(220, 1000, 2, 10, 1)
;kFreq = LinDis:k(220, 1000, 10, 1, 0)
;kFreq = RecDis:k(220, 1000, 10, 1)
kFreq = GausDis:k(220, 1000, 30, 2.1)

a1 = poscil(.5 * (poscil(1, kFreq + (kFreq/(.1/kFreq)))), kFreq + (poscil((kFreq/3) * 3, kFreq/(1/kFreq))))

  outs(a1, a1)

  endin



</CsInstruments>
<CsScore>

i 1 0 10

</CsScore>
</CsoundSynthesizer>
