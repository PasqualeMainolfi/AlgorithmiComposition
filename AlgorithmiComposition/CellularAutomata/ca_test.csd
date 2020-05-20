<CsoundSynthesizer>
<CsOptions>
-n
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1

#include "ca.udo"

seed(0)

  instr simpleCA //Wolfram Rules

/*
Automa cellulare semplice con vicinato pari alle due celle adiacenti --> 2^3 = 8 configurazioni possibili
e, 2^8 = 256 regole possibili (descrizione di Wolfram)
*/

icells = 36 //numero totale di celle
irule = 30 //regola 30
imaxGeneration = 120 //numero massimo di generazioni

igrid[] = grid1d(icells) //stato iniziale generato randomicamente
;printarray(igrid, "%d", "stato al tempo zero:")

imatCa[][] simpleCa_2d igrid, irule, imaxGeneration //generazione matrice di stati
printarray(imatCa, "%d")

  endin


//---GAME OF LIFE---

  instr gameOfLife //the Game of Life

irows = 37
icols = 37

inextStateGrid[][] init irows, icols

igrid[][] grid2d irows, icols
;printarray(igrid, "%d", "generazione al tempo zero:")

imaxGeneration = 1000
ii = 0
while (ii < imaxGeneration) do
  inextStateGrid[][] gameOfLife igrid, irows, icols
  printarray(inextStateGrid, "%d")
  igrid[][] = inextStateGrid
  ii += 1
od

  endin


</CsInstruments>
<CsScore>

i "simpleCA" 0 1
i "gameOfLife" 3 1

</CsScore>
</CsoundSynthesizer>
