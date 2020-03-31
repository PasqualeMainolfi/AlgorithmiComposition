/*
• ALGORITMI PROBABILISTICI
PROCESSI STOCASTICI ---> "modello matematico adatto a studiare l'andamento di quei fenomeni che seguono leggi casuali, probabilistiche.
È una forma di rappresentazione di tutte quelle grandezze che variano nel tempo in modo casuale... la versione probabilistica
di un sistema dimanico"

- CATENE DI MARKOV
- METODO MONTE CARLO ---> ALGORITMO DI METROPOLIS E METROPOLIS HASTINGS
- RANDOM WALK
- LEVY FLIGHT
*/

//---ALCUNE FUNZIONI DI DENSITÀ---
    opcode normale, k, kii ;funzione di densità
kx, isigma, imu xin
knormal = (1/(sqrt(2 * $M_PI * (isigma^2)))) * exp(-0.5 * ((kx - imu)/isigma)^2)
xout(knormal)
    endop

    opcode pdf, k, k ;Standard Normal pdf (probability Density Function)
kx xin
i2pi = 2 * $M_PI
kpdf = exp(-kx * kx/2)/sqrt(i2pi)
xout(kpdf)
    endop

    opcode ca, k, k //distribuzione di Cauchy
kx xin
kcauchy = 1/(1 + kx^2)
xout(kcauchy)
    endop
//--------------------------------


    opcode tMatrix_rand, k[][], i //fill random transition matrix
istate xin
seed(0)
//istate = numero di stati possibili

kp[][] init istate, istate

kx init 0
if(kx < istate) then
    ki = 0
    until (ki == istate) do
        ksum = 0
        kj = 0
        until (kj == istate) do
            kp[ki][kj] = random:k(0, 1)
            ksum = ksum + kp[ki][kj]
            kj += 1
        od
        ksum = ksum/istate
        ksum = (1 - ksum)/istate
        kn = 0
        until (kn == istate) do
            kp[ki][kn] = (kp[ki][kn]/istate) + ksum
            kn += 1
        od
        ki += 1
    od
    kx += 1
endif
xout(kp)
    endop

    opcode mChain, k, k[][]iiik //markov chain
kp[][], inState, istart, iter, ktgen xin
seed(0)

knext init istart
itime = 1

ki init 0
if(ki < iter && metro:k(1/ktgen) == 1) then

    krnd = random:k(0, 1)
    kstate = 0
    kc = kp[knext][kstate]

    while (kc < krnd) do
        kstate += 1
        kc += kp[knext][kstate]
    od

    knext = kstate
    ki += 1
endif

xout(knext)
    endop

    opcode mcMetropolis_h, k, iiko //metropolis and metropolis-hastings with cauchy distribution
istart, iter, ktime, imode xin
seed(0)

/*
istart = x_0
iter = numero iterazioni
imode = optional default = 0 metropolis, 1 = metropolis-hastings
*/

kxt init istart //start value in modo da evitare zero

ki init 0
if(ki < iter && metro:k(1/ktime) == 1) then
    kx_star = unirand:k(random:k(-1, 1)) //candidato ---> x*

    kx = ca(kx_star) //target function n_proposed
    ky = ca(kxt) //target function n - 1

    if(imode = 0) then
        kw = (kx/ky) //metropolis
        elseif(imode = 1) then
            kw = (kx/ky) * (pdf(kxt)/pdf(kx_star)) //metropolis-haastings
        endif

    if(kw >= 1) then
        kxt = kx_star //si accetta il valore proposto
        else
            ku = random:k(0, 1) //si accetta con una data percentuale di probabilità
            if(ku <= kw) then
                kxt = kx_star
                else
                    kxt = kxt //si rigetta e si accetta il precedente
                endif
            endif
            ;printf("%f\n", ki + 1, kxt)
            ki += 1
        endif

xout(kxt)
    endop



    opcode rWalk, kk, ii //RANDOM WALK WITH VECTOR
iter, itime xin
seed(0)

kx, ky init 0

if(metro(1/itime) == 1) then
ki init 0
if(ki < iter) then
    kstepx = random:k(-2, 2)
    kstepy = random:k(-2, 2)

    kx += int(kstepx)
    ky += int(kstepy)

    ki += 1
endif
endif

xout(kx, ky)
    endop


    opcode rWalk_levy, kk, ikikkk //LEVY FLIGHT WITH VECTOR
iter, ktime, iprob, kminRag, kmin, kmax xin
seed(0)

/*
iter = numero totale di iterazioni
ktime = tempo di iterazione
iprob = probabilità di moltiplicazione raggio levy flight
kminRag = lunghezza minima raggio (unitario)
kmin, kmax = range mag raggio levy flight
*/

kx, ky, kposx, kposy init 0

ki init 0
if(metro:k(1/ktime) == 1) then
if(ki < iter) then
    kraggio = int(random:k(-2, 2)) //unity vec
    ka = random:k(0, 2 * $M_PI)
    kw = random:k(0, 100)

    if(kw < iprob) then
        kmag = random:k(kmin, kmax)
        kraggio *= kmag
        else
            kraggio *= kminRag
        endif

    kposx += kx
    kposy += ky
    kx = kraggio * cos(ka)
    ky = kraggio * sin(ka)

    ki += 1
endif
endif

xout(kposx, kposy)
    endop
