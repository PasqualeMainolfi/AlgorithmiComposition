/*
• SISTEMI DINAMICI NON LINEARI
SISTEMI CAOTICI ---> "...sistemi dianamici che mostrano una elevatissima sensibilità alle condizioni iniziali,
transatività topologica e un insieme di orbite periodiche. Seppur governati da leggi deterministiche, esibiscono
una evidente casualità nella evoluzione delle variabili dinamiche"

- MAPPA LOGISTICA
- MAPPA STANDARD
- ATTRATTORE/MAPPA DI HENON
- SISTEMA DI HENON-HEILES
- ATTRATTORE DI LORENZ
- ATTRATTORE DI ROSSLER
*/

    opcode mLogi, k, kk //mappa logistica
kx, kR xin

/*
kx = valore compreso tra 0 e 1
kR = numero positivo (comportamento caotico per kR > 3.56995. kR > 4 diverge)
*/

kxn init i(kx)
kxn = kR * kxn * (1 - kxn)
xout(kxn)
    endop

    opcode mStand, kk, ko //mappa standard
kk, imode xin

/*
kk = parametro K fondamentale per il comportamento caotico (K > 2 rumore)
imode = default 0 ---> chirikov standard map. 1 ---> standard map
*/
kx, ky init .01

if(imode = 0) then //---Chirikov standard map---
    kxn = kx + kk * sin(ky)
    kyn = ky + kxn
    elseif(imode = 1) then //--standard map---
        kxn = kx + ky - kk * sin(kx)
        kyn = ky - kk * sin(kx)
    endif

kx = kxn%(2 * $M_PI)
ky = kyn%(2 * $M_PI)

xout(kx, ky)
    endop

    opcode mCircle, kk, k //mappa standard circolare
kk xin

kx, ky init .01

kxn = kx + ky + kk * sin(kx)
kyn = kxn - kx

kx = kxn%(2 * $M_PI)
ky = kyn%(2 * $M_PI)

xout(kxn, kyn)
    endop

    opcode mHan, kkk, kk //attrattore/mappa di Hanon
ka, kb xin

kx, ky init 0
kx_, kx__ init 0

kxn = (1 - ka * pow(kx, 2)) + ky //2 dimensioni
kyn = (kb * kx)
kx = kxn
ky = kyn

k1dn = 1 - ka * pow(kx_, 2) + kb * kx__ //1 dimensione
kx__ = kx_
kx_ = k1dn

xout(kx, ky, k1dn)
    endop

    opcode sHenHeil, kk, iiiik //sistema Henon-Heiles
ix, iy, ipx, ipy, kdt xin

kx init ix
ky init iy
kpx init ipx
kpy init ipy

kpx += -(kx - 2 * kx * ky) * kdt
kpy += -(ky - pow(kx, 2) + pow(ky, 2)) * kdt
kx += kpx * kdt
ky += kpy * kdt

xout(kx, ky)
    endop

    opcode aLorenz, kkk, kkkkk //attrattore di Lorenz
ksigma, krho, kbeta, kdt, ktime xin

/*
ksigma, krho, kbeta = coefficienti solitamente sigma = 10 rho = 28 beta = 8/3
*/

kx init .01
ky init 0
kz init 0

if(metro(1/ktime) == 1) then
    kdx = (ksigma * (ky - kx)) * kdt
    kdy = (kx * (krho - kz) - ky) * kdt
    kdz = (kx * ky - kbeta * kz) * kdt
    kx += kdx
    ky += kdy
    kz += kdz
endif

xout(kx, ky, kz)
    endop

    opcode aRos, kkk, kkkkk //attrattore di Rossler
ka, kb, kc, kdt, ktime xin

/*
ka, kb, kc = coefficienti, solitamente a = 0.2 b = 0.2 c = 5.7
*/

kx init .01
ky init 0
kz init 0

if(metro(1/ktime) == 1) then
    kdx = (-ky - kz) * kdt
    kdy = (kx + ka * ky) * kdt
    kdz = (kb + kz * (kx - kc)) * kdt
    kx += kdx
    ky += kdy
    kz += kdz
endif

xout(kx, ky, kz)
    endop
