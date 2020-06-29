<CsoundSynthesizer>
<CsOptions>
;-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1

#include "StochProcesses.udo"
#include "ChaoticSystems.udo"
#include "DeterProcesses.udo"
#include "Fractals.udo"
#include "GenerativeGram.udo"

seed(0)


	instr mChain //processo markoviano

/*
esempio di utilizzo di un processo markoviano con matrici di transizione randomiche
*/


istateF = 12
istateA = 10
istateD = 7
istateP = 6
istart = 0
ktgen = 1

kDur, krnd_f, krnd_a, krnd_d, krnd_p, krnd_g init 1
ktgen *= krnd_g

change:
ichange = int(random(3, 30)) //tempo randomico per aggiornamento matrici di transizione
iter = random(5, 500) //controllo randomico del numero di iterazioni (note in sequenza)

kfrq[] = fillarray(65.406, 69.296, 73.416, 77.782, 82.407, 87.307, 92.498, 97.999, 103.826, 110.000, 116.541, 123.471)
kamp[] = fillarray(0, .1, .3, 0, .5, .7, 0, .9, 1, 0)
kdur[] = fillarray(1/8, 1/7, 1/4, 1/3, 1/2, 1, 1.5)
kpan[] = fillarray(0, .5, 1, 1, .5, 0)

//genera matrici di transizioni casuali
kp1[][] init istateF, istateF //matrice di transizione per le frequenze
kp1[][] tMatrix_rand istateF //random transition matrix

kp2[][] init istateD, istateD //matrice di transizione per le durate
kp2[][] tMatrix_rand istateD //random transition matrix

kp3[][] init istateP, istateP //matrice di transizione per il panning
kp3[][] tMatrix_rand istateP //random transition matrix

kp4[][] init istateA, istateA //matrice di transizione per il panning
kp4[][] tMatrix_rand istateA //random transition matrix

kf = mChain(kp1, istateF, istart, iter, ktgen)
ka = mChain(kp4, istateA, istart, iter, ktgen)
kd = mChain(kp2, istateD, istart, iter, ktgen)
kp = mChain(kp3, istateP, istart, iter, ktgen)


kFreq = kfrq[kf] * krnd_f

kAmp = (kamp[ka] * krnd_a) * linseg(0, 1.5, 1) //quando aggiorna le matrici genera inviluppo per entrata graduale

kDur = kdur[kd] * krnd_d
kPan = kpan[kp] * krnd_p


if(metro(1/ktgen) == 1)then
	event("i", "mPlay", 0, kDur + ktgen, kFreq, kDur + ktgen, kPan, kAmp)
	krnd_f = int(random:k(2, 5)) //termine randomico per il controllo delle ottave
	krnd_a = random:k(0, 1) //termine randomico per le ampiezze
	krnd_d = random:k(.5, 3) //termine randomico per le durate
	krnd_p = random:k(.1, 1) //termine randomico per il panning
	krnd_g = random:k(.125, .210) //in modo che la generazione non abbia lunghezza uguale alla durata della nota
endif

kinstr init 0
if(kinstr < sr * ichange) then
	kinstr += 1
	if(kinstr = sr * ichange) then

		prints("\n", 0)
		prints("...aggiorno le matrici di transizione", 0)
		prints("\n", 0)

		reinit change
		kinstr = 0
	endif
endif

	endin

	instr mPlay

kpanning = portk(p6, .001)
it = i(p5)
iamp = i(p7)
kinv = linseg:k(0, .001, iamp, it/3, iamp, it - ((it/3) + .001), 0)
kfreq = p4
kmod = kfreq/(1.03/.999)
a1 = poscil(.5 * kinv, kfreq + poscil(kinv * 3 * kmod, kmod))
a1 = (a1 * poscil(.7, kinv + poscil(kfreq, kfreq)))/1.2

	outs(a1 * kpanning, a1 * (1 - kpanning))
	endin


	instr mLog //mappa logistica e standard

/*
esempio di utilizzo di una mappa logistica o standard per la costruzione di spettri complessi
*/

klogi = mLogi(.1, linseg:k(2, p3/2, 3.999)) //mappa logistica
kx_stand, ky_stand mStand randomh:k(0, .9, randomh:k(1, 100, 7)) //mappa standard
;kx_stand, ky_stand mStand linseg(0, 7, 1.9) //mappa standard ---> il glissando produce spettri molto complessi e geometrici
;kx_stand, ky_stand mCircle linseg(0, .01, 1.9)

kx = sqrt(kx_stand)/($M_PI)
ky = ky_stand ;+ portk(randomh:k(-500, 100, randomh:k(0, 100, 510)), .1)

kxx = kx_stand
kyy = sqrt(ky_stand)/($M_PI)

krag = sqrt(kx_stand * kx_stand + ky_stand * ky_stand)/$M_PI
kangle = taninv2(ky, kx)


a1 = kx * cos(ky * 2 * $M_PI)
a2 = kx * sin(ky * 2 * $M_PI)

aout = (a1 + a2)

outs(aout, aout)

	endin

	instr fTreeAdditive //additiva mediante albero frattale

ifreq = 220
iamp = .9
ifac_freq = .1 //strettamente collegato al numero di iterazioni (al crescere del numero di iterazioni deve diminuire)
ifac_amp = .91
iter = 1/(ifac_freq/10)

ax, ay fTree_a ifreq, ifreq, ifac_freq, iamp, ifac_amp, iter

	outs(ax, ay)

	endin
//--------------

//---Grammatiche generative---

	instr lsystem //L-system (esempio di generazione)

/*
alcuni esempi di grammatica generativa

ALGAE:

variables : A B
constants : none
axiom : A
rules : A → AB, B → A


KOCH CURVE:

variables : F
constants : + −
start : F
rules : F → F+F−F−F+F

F = draw forward, + = turn left 90°, - = turn right 90°


FRACTAL PLANT:

variables : X F
constants : + − [ ]
start : X
rules : X → F+[[X]-X]-F[-FX]+X, F → FF

F = draw forward, + = turn left 25°, - = turn right 25°, X = nothing, [ = push, ] = pop
*/

Salfabeto[] init 2

Salfabeto[] = fillarray("A", "B")
iasciiAlfabeto[] = sToAscii(Salfabeto) //converte stringa in array valori ascii
Sassioma = "A"

Scondizione1 = Salfabeto[0] //(se, allora vai alla regola)
Sregola1 = "AB"

Scondizione2 = Salfabeto[1]
Sregola2 = "A"

imaxIter = 7
iter = 0
while (iter < imaxIter) do
	Stringa = lSystem_encode(Sassioma, Scondizione1, Sregola1, Scondizione2, Sregola2, iter) //codifica della stringa L-system
	prints("\n generazione[%d] = %s ---> [lunghezza = %d]\n\n", iter, Stringa, strlen(Stringa))

	ilen = strlen(Stringa)
	ii = 0
	while (ii < ilen) do
		icarCorrente = strchar(Stringa, ii) //decodifica della stringa L-system

		ifreq = random(30, 1000)
		iamp = random(0, 1/ilen)
		idur = random(1, 3)
		it = random(.01, .5)
		idel = random(0, 30)

		if(icarCorrente == iasciiAlfabeto[0]) then
			event_i("i", "ls1", idel, idur, ifreq, iamp, it)
			elseif(icarCorrente == iasciiAlfabeto[1]) then
				event_i("i", "ls2", idel, idur, ifreq, iamp, it)
			endif
		ii += 1
	od

	iter += 1
od
	endin

	instr ls1
itime = p6
ifreq = p4
iamp = p5
imod = ifreq
kamp = p5 * linseg(0, itime, 1, p3 - itime, 0)

a1 = poscil(.707, ifreq + poscil((poscil(.707, iamp * 5) * imod) * kamp, imod))
	outs(a1 * kamp, a1 * kamp)
	endin

	instr ls2
itime = p6
ifreq = p4
iamp = p5
imod = ifreq
kamp = p5 * linseg(0, itime, 1, p3 - itime, 0)

a1 = poscil(.707, ifreq + poscil((poscil(.707, iamp * 5) * imod) * kamp, imod))
	outs(a1 * kamp, a1 * kamp)
	endin

//----------------------------



</CsInstruments>
<CsScore>

;i "mChain" 0 100

;i "mLog" 0 10

;i "fTreeAdditive" 0 100

i "lsystem" 0 30


</CsScore>
</CsoundSynthesizer>
