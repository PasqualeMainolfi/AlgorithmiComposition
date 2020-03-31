
seed(0)

/*
MATRICE ALLA POTENZA
*/

    opcode MatPow, k[][], k[][]iii
kMat1[][], iRow, iCol, iPow xin

kMat2[][] init iRow, iCol
kTemp[][] init iRow, iCol
kMat2[][] = kMat1

kY init 0
;---potenza alla 0 e alla 1---
if(iPow = 0) then
    kq init 0
    until (kq == iRow) do
        kw = 0
        until (kw == iCol) do
            kTemp[kq][kw] = 1
            kw += 1
        od
        kq += 1
    od
endif

if(iPow = 1) then
    kTemp[][] = kMat1
endif
;-----------------------------

;---potenza maggiore di 1---
if(iPow > 1) then
ki init 1
until (ki == i(iPow)) do
    ka = 0
    until (ka == iRow) do
        kb = 0
        until (kb == iCol) do
            kc = 0
            until (kc == iCol) do
                kY = kY + (kMat1[ka][kc] * kMat2[kc][kb])
                kc += 1
            od
            kTemp[ka][kb] = kY
            kY = 0
            kb += 1
        od
        ka += 1

    od
    kd = 0
    until (kd == iRow) do
        kf = 0
        until (kf == iCol) do
            kMat2[kd][kf] = kTemp[kd][kf]
            kf += 1
        od
        kd += 1
    od

    ki += 1
od
endif

kx init 0
until (kx == iRow) do
    kj = 0
    until (kj == iCol) do
        printf("[%d][%d] = %f\n", kj + 1, kx, kj, kTemp[kx][kj])
        kj += 1
    od
    kx += 1
od

xout(kTemp)
    endop

;---------------------------


/*
PRODOTTO TRA MATRICI
*/
    opcode MatProd, k[][], k[][]k[][]iii
k1[][], k2[][], iRow, iColRow, iCol xin

kY[][] init iRow, iCol
ky init 0

ki init 0
until (ki == iRow) do
    kj = 0
    until (kj == iCol) do
        kl = 0
        until (kl == iColRow) do
            ky = ky + (k1[ki][kl] * k2[kl][kj])
            kl += 1
        od
        kY[ki][kj] = ky
        ;printf("[%d][%d] = %f\n", kj + 1, ki, kj, kY[ki][kj])
        ky = 0
        kj += 1
    od
    ki += 1
od

xout(kY)
    endop

;--------------------------

/*
CALCOLO LONG-RUN PROBABILITIES

q = s(P^n)

s = stato iniziale
P = matrice di transizione alla n potenza
*/

    opcode LongRunProb, 0, k[][]k[][]iiii
kState[][], kTransitionMatrix[][], iRow, iColRow, iCol, iPow xin

kPow[][] init iColRow, iCol
kLrp[][] init iRow, iColRow

kPow[][] MatPow kTransitionMatrix, iColRow, iCol, iPow
kLrp[][] MatProd kState, kPow, iRow, iColRow, iCol

printf("\n", 1)
printf("Dopo %d volte, le probabilità sono:\n", 1, iPow)
printf("\n", 1)

ki init 0
until (ki == iRow) do
    kj = 0
    until (kj == iColRow) do
        printf("\tSTATO [%d] = \t%f %%\n", kj + 1, kj, kLrp[ki][kj] * 100)
        kj += 1
    od
    ki += 1
od
printf("\n", 1)
;turnoff
    endop


    opcode MetropolisHastings, 0, i
iN xin

kR[] init iN
kPrec = 0
kP = kPrec
kR[0] = kP

ki init 1
until (ki == iN) do
    kRn = kP + random:k(-1.0, 1.0)
    kPn = ProDenFun(kRn)
    kw = (kPn/ProDenFun(kP)) * (ProDenFun(kR[ki])/ProDenFun(kR[ki - 1])) //differenza con metropolis
    if(kw >= 1) then
        kP = kPn
        kR[ki] = kRn
        else
            ku = random:k(0.0, 1.0)
            if(ku < kw) then
                kP = kPn
                kR[ki] = kRn
                else
                    kP = kP
                    kR[ki] = kR[ki - 1]
                endif
            endif
            ki += 1
        od

printf("\n", 1)
printf("START METROPOLIS-HASTINGS...\n", 1)
printf("\n", 1)

kj init 0
until (kj == iN) do
    printf("%f\n", kj + 1, kR[kj])
    kj += 1
od

printf("\n", 1)
printf("END METROPOLIS-HASTINGS...\n", 1)
printf("\n", 1)

    endop
