/*
• FRATTALI
"...un oggetto geometrico dotato di omotetia interna."

- TRIANGOLO, TAPPETO E CURVA DI SIERPINSKY
- FRATTALI (ESCAPE-TIME FRACTALS ---> INSIEME DI MANDELBROT E RANDOM FRACTALS ---> BROWNIAN TREE)
*/


    opcode fSierp, k, ikik //per tappeto e triangolo di sierpinsky
ia1, kratio, iter, kdt xin

/*
ia1 = area iniziale
kratio = rapporto di crescita
iter = numero totale di iterazioni
kdt = tempo di generazione
*/

ka init ia1

ki init 0
if(ki < iter && metro(1/kdt) == 1) then
    kan = ka * pow(kratio, ki)
    ka = kan
    printf("area = %.230f\n", ki + 1, ka)
    ki += 1
endif
xout(ka)
    endop

    opcode curvaSierp, k, ik //curva di sierpinsky
iter, kdt xin

ki init 0
if(ki < iter && metro(1/kdt) == 1) then
    kln = (2/3) * (1 + sqrt(2)) * pow(2, ki) - (1/3) * (2 - sqrt(2)) * (1/pow(2, ki))
    printf("area = %f\n", ki + 1, kln)
    ki += 1
endif
xout(kln)
    endop

    opcode fractals_k, kkkk, iikkiko //escape-time method (frattali) with k-value
ire, imm, kN, kpow, iter, kdt, iprint xin

/*
ire, im = c = (a + ib) ---> valori di partenza reale, immaginario
kN = norma valore limite
kpow = scelta della potenza
iter = numero totale di iterazioni
kdt = tempo di generazione
iprint = default 0 non stampare valori 1 = stampa a schermo i valori (check)
*/

ka, kb init 0 //z_0 = 0
ki init 0
if (ki < iter && metro(1/kdt) == 1) then

    kreale = pow(ka, kpow) - pow(kb, kpow)
    kimmag = kpow * ka * kb
    ka = kreale + ire
    kb = kimmag + imm
    knorma = ka + kb

    kmag = sqrt(ka * ka + kb * kb)
    kphase = taninv2(kb, ka)

    if(knorma >= kN) then //in modo da evitare boom!
        ka = 0
        kb = 0
    endif

    if(iprint = 1) then
        printf("pow = %.1f ---> \tRe = %f \tIm = %f \tmag = %f \tphase = %f\r", ki + 1, kpow, kreale, kimmag, kmag, kphase)
    endif

    ki += 1
endif

xout(kreale, kimmag, kmag, kphase)
    endop

    opcode fTree_k, kk, iiiik //fractal tree with k-value
irag, ianRotation, ifacRaggio, iter, kdt xin

kangle init 0
kraggio init irag
kx, ky, kxn, kyn init 0

ki init 0
if(ki < iter && metro(1/kdt) == 1) then
    kxn += kx
    kyn += ky
    kx = kraggio * cos(kangle)
    ky = kraggio * sin(kangle)

    kraggio *= ifacRaggio
    kangle += ianRotation

    ki += 1
endif

xout(kxn, kyn)
    endop


    opcode fTree_a, aa, iiiiiio //recursive fractal tree (addditive a-value)
ifreq1, ifreq2, ifac_freq, iamp, ifac_amp, iter, icount xin

ia = iamp * ifac_amp
ifrequenza1 = ifreq1 * ifac_freq
ifrequenza2 = ifreq2 * ifac_freq

ax = poscil(ia, ifreq1)
ay = poscil(ia, ifreq2)

if(icount < iter) then
    axn, ayn fTree_a ifrequenza1 + ifreq1, ifrequenza2 - ifreq2, ifac_freq, ia, ifac_amp, iter, icount + 1
endif

ax = ax + axn //verso destra
ay = ay + ayn //verso sinistra

xout(ax/2, ay/2)
    endop
