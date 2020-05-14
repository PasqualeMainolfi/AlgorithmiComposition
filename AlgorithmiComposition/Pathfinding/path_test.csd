<CsoundSynthesizer>
<CsOptions>
-o dac -b512 -B2048
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 8
nchnls = 2
0dbfs = 1


#include "pathfinding.udo"
#include "adjMatrixGraph.udo"

seed(0)

gix = 30 //%2
giy = 25 //%2
gitotState = gix * giy //numero totale si stati possibili, che vengono poi convertiti in punti nel piano

	instr A //A* (A star) algorithm

inumOstacoli = 100 //numero totale di ostacoli

istartx = 0
istarty = giy - 1
iendx = gix - 1
iendy = round(giy/2) //in modo da avere int

iritStartx = gix - 1
iritStarty = round(giy/2)
iritEndx = 0
iritEndy = giy - 1

istart = xy2value(istartx, istarty, gix)
iend = xy2value(iendx, iendy, gix)

iritStart = xy2value(iritStartx, iritStarty, gix)
iritEnd = xy2value(iritEndx, iritEndx, gix)

//grafo 1
igraph1[][] dephGraph_1_i gix, giy //matrice di adiacenza (dx, sopra, diagonale) ---> percorso
igraph1[] wall igraph1, gitotState, inumOstacoli, istart, iend //aggiungo gli ostacoli randomicamente

//grafo 2
igraph2[] dephGraph_2_i gix, giy //matrice di adiacenza (dx, sx, sopra, sotto) ---> percorso
igraph2[] wall igraph2, gitotState, inumOstacoli, istart, iend

igraphRitorno[] dephGraph_2_i gix, giy //matrice di adiacenza (dx, sx, sopra, sotto) ---> percorso
igraphRitorno[] wall igraphRitorno, gitotState, inumOstacoli, iritStart, iritEnd

giroot[], gipathGrafo[][] A_star igraph2, gix, giy, istartx, istarty, iendx, iendy
girootRitorno[], gipathGrafoRitorno[][] A_star igraphRitorno, gix, giy, iritStartx, iritStarty, iritEndx, iritEndy
//printarray(igraph1, "%d") //stampa matrice con ostacoli
//printarray(iroot, "%d") //stampa valori path
//printarray(ipathGrafo, "%d") //stampa matrice con percorso ottimale

	endin

   	instr A_sound

gknote[] init gitotState
gkamp[] init gitotState
gkdur[] init gitotState
gknote2[] init gitotState
gkamp2[] init gitotState
gkdur2[] init gitotState
gkpan[] init gitotState
gkpan2[] init gitotState

ilen = lenarray(giroot)
kroot[] = giroot
ilenR = lenarray(girootRitorno)
krootR[] = girootRitorno


ktime init 1
krun init 1
kdel init .1
ktime2 init 1
krun2 init 1
kdel2 init 0


go:
ki init 0
if(ki < gitotState) then
  gknote[ki] = random:k(90, 500)
  gkamp[ki] = random:k(0.0, .5)
  gkdur[ki] = random:k(.1, 5)
  gkpan[ki] = random:k(0, 1)

  gknote2[ki] = random:k(30, 700)
  gkamp2[ki] = random:k(0.0, .5)
  gkdur2[ki] = random:k(.3, 6)
  gkpan2[ki] = random:k(0, 1)

  ki += 1
endif


; ktime init 1
; krun init 1
; kdel init .1
kj init 0
if(kj < ilen && metro(ktime) == 1) then
  kval = kroot[kj]
  event("i", "act", kdel, gkdur[kval], gknote[kval], gkdur[kval], gkamp[kval], gkpan[kval])
  ktime *= random:k(krun, 10)
  kj += 1
endif

; ktime2 init 1
; krun2 init 1
; kdel2 init 0
kn init 0
if(kn < ilenR && metro(ktime2) == 1) then
  kval2 = krootR[kn]
  event("i", "act2", kdel2, gkdur2[kval2], gknote2[kval2], gkdur2[kval2], gkamp2[kval2], gkpan2[kval])
  ktime2 = random:k(.1, krun2)
  kn += 1
endif

itime = random(.1, random(.5, 10))

  timout(0, itime, change)
  reinit go

change:
krun = random:k(.1, 1)
krun2 = random:k(1, 5)
kdel = random:k(0, 1.2)
kdel2 = random:k(0, 2.1)

    endin

    instr act

kinv = linseg:k(0, .01, 1, i(p5) * 0.75, 0, (i(p5)/4) - .01, 0)
kfreq = p4
kfmod = kfreq/(1.003/.999)
a1 = poscil(p6 * kinv, kfreq + poscil(1.6 * kfmod * kinv, kfmod))
aleft = (a1 * p7)
aright = (a1 * (1 - p7))

  outs(aleft/4, aright/4)

    endin

    instr act2

kinv = linseg:k(0, .01, 1, i(p5)/3, 0, (i(p5) - (i(p5)/3)) - .01, 0)
kfreq = p4
kfmod = kfreq/(1.001/.999)
a1 = poscil(p6 * kinv, kfreq + poscil(1.2 * kfmod * kinv, kfmod))
aleft = (a1 * p7)
aright = (a1 * (1 - p7))

  outs(aleft/2, aright/2)

    endin


</CsInstruments>
<CsScore>

i "A" 0 1
i "A_sound" 1 30

</CsScore>
</CsoundSynthesizer>
