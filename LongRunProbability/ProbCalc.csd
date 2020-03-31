<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1


#include "ProbCalc.udo"

seed(0)

  instr 1 ;long-run probability

iRow = 1
iColRow, iCol = 4
iPow = 100

kState[][] init iRow, iColRow
kTransitionMatrix[][] init iColRow, iCol

kState[][] = fillarray(0, 1, 0, 0) ;stato iniziale partenza

kTransitionMatrix[][] = fillarray(1,  0,  0,  0,
                                 .5,  0, .5,  0,
                                  0, .5,  0, .5,
                                  0,  0,  0,  1) ;matrice di transizione


LongRunProb(kState, kTransitionMatrix, iRow, iColRow, iCol, iPow)

endin


</CsInstruments>
<CsScore>
i 1 0 10
</CsScore>
</CsoundSynthesizer>
