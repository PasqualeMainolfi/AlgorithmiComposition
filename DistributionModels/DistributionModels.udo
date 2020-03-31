
seed(0)

;---MODELLI DISTRIBUTIVI SEMPLICI---

  opcode LinDiseg, k, kkiii ;linear upward/downward distribution
kMin, kMax, iter, iDur, iMode xin

/*
kMin = min value
kMax = max value
iter = numero di generazioni
iMode = 0 = downward, 1 = upward
*/

kDiv = (kMax - kMin)/iter

kValue[] init iter

if(iMode = 0) then
  ki init 0
  until (ki == iter) do
    kMin = kMax - kDiv
    kx = random:k(kMin, kMax)
    kValue[ki] = kx
    kMax = kMin
    printf("x = %f\n", ki + 1, kx)
    ki += 1
  od
  elseif(iMode = 1) then
    ki init 0
    until (ki == iter) do
      kMax = kMin + kDiv
      kx = random:k(kMin, kMax)
      kValue[ki] = kx
      kMin = kMax
      printf("x = %f\n", ki + 1, kx)
      ki += 1
    od
  endif

kV = kValue[int:k(phasor:k(1/iDur) * iter)]

xout(kV)
  endop


  opcode TriDis, k, kkiii ;distribuzione triangolare
kMin, kMax, iDen, iter, iDur xin

/*
iDen = denominatore per c. Se iDen = 2 distribuzione triangolare simmetrica, caso contrario asimmetrica.
*/

kValue[] init iter

ki init 0
until (ki == iter) do
    ka = random:k(kMin, kMax)
    kb = random:k(kMin, kMax)
    kc = (ka + kb)/iDen
    kx = (ka + kb + kc)/3
    printf("x = %f\n", ki + 1, kx)
    kValue[ki] = kx

    ki += 1
od

kV = kValue[int:k(phasor:k(1/iDur) * iter)]

xout(kV)
  endop

  opcode LinDis, k, kkiii ;distribuzione lineare
kMin, kMax, iter, iDur, iMode xin

/*
kMin = min value
kMax = max value
iter = numero di generazioni
iMode = 0 = downward, 1 = upward
*/

kValue[] init iter

if(iMode = 0) then
    ki init 0
    until (ki == iter) do
        ka = random:k(kMin, kMax)
        kb = random:k(kMin, kMax)

        if(ka < kb) then
            kx = ka
            else
                kx = kb
            endif
            kValue[ki] = kx
            printf("x = %f\n", ki + 1, kx)
            ki += 1
        od
        elseif(iMode = 1) then
            ki init 0
            until (ki == iter) do
                ka = random:k(kMin, kMax)
                kb = random:k(kMin, kMax)

                if(ka > kb) then
                    kx = ka
                    else
                        kx = kb
                    endif
                    kValue[ki] = kx
                    printf("x = %f\n", ki + 1, kx)
                    ki += 1
                od
            endif

kV = kValue[int:k(phasor:k(1/iDur) * iter)]

xout(kV)
  endop

  opcode RecDis, k, kkii ;distribuzione rettangolare uniforme
kMin, kMax, iter, iDur xin

kValue[] init iter

ki init 0
until (ki == iter) do
    ka = random:k(kMin, kMax)
    kb = random:k(kMin, kMax)

    kx = (ka + kb)/2

    printf("x = %f\n", ki + 1, kx)
    kValue[ki] = kx

    ki += 1
od

kV = kValue[int:k(phasor:k(1/iDur) * iter)]

xout(kV)
  endop



  opcode Scale, k, kkkkk
kIn, kOutMin, kOutMax, kInMin, kInMax xin
kY = (((kIn - kInMin) * (kOutMax - kOutMin)) / (kInMax - kInMin)) + kOutMin
xout(kY)
  endop


  opcode GausDis, k, kkii ;distribuzione gaussiana
kMin, kMax, iter, iDur xin

kValue[] init iter
iPi = $M_PI
iSigma = 1
iMi = iPi
kE = $M_E

ki init 0
until (ki == iter) do
    ka = random:k(0, 1)
    ka = ka * (2 * iPi)

    kG = (1/(iSigma * sqrt(2 * iPi))) * kE^(-((ka - iMi)^2)/(2 * iSigma^2))
    kValoreAtteso = Scale(iMi, kMin, kMax, 0, 2 * iPi)
    kx = Scale(kG, kMin, kMax, 0, 1)

    kValue[ki] = kx
    printf("x = %f --- Valore Atteso = %f\n", ki + 1, kx, kValoreAtteso)
    ki += 1
od

kV = kValue[int:k(phasor:k(1/iDur) * iter)]

xout(kV)
  endop

;--------------------------------------------------
