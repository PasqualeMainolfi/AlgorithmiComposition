/*
• ALGORITMI DETERMINISTICI (RULE-BASED ALGORITHMS)
"...un algoritmo si dirà deterministico se per ogni istruzione esiste, a parità di dati d'ingresso, un solo
passo successivo; in pratica esiste uno e un solo possibile percorso dell’algoritmo e quindi a fronte
degli stessi dati di partenza produrrà gli stessi risultati."

- SUCCESSIONE DI FIBONACCI
- CONGETTURA DI COLLATZ
- SEQUENZA DI RECAMAN
*/


    opcode sFib, k, iki //SUCCESSIONE DI FIBONACCI
ix, ktime, iter xin

kprev init ix - 1
knext init ix

ki init 0
if(ki < iter && metro(1/ktime) == 1) then
    kfib = kprev + knext
    kprev = knext
    knext = kfib
    ki += 1
endif
xout(kfib)
    endop

    opcode sTrib, k, iki //SUCCESSIONE TRIBONACCI
ix, ktime, iter xin

kprim init ix - 2
kprev init ix - 1
knext init ix

ki init 0
if(ki < iter && metro(1/ktime) == 1) then
    ktrib = kprim + kprev + knext
    kprim = kprev
    kprev = knext
    knext = ktrib
    ki += 1
endif
xout(ktrib)
    endop

    opcode cCol, k, iki //CONGETTURA DI COLLATZ
ix, ktime, iter xin

ix = int(ix)
ky init ix

ki init 0
if(ki < iter && metro(1/ktime) == 1) then
    if(ky%2 = 0) then
        ky = ky/2
        else
            ky = (3 * ky) + 1
        endif
        ki += 1
    endif
xout(ky)
    endop



    opcode sRec, k, ik //SUCCESSIONE DI RECAMAN
iter, ktime xin

/*
iter = totale iterazioni
ktime = tempo generazione
*/

kseq[] init iter //array per il controllo delle ripetizioni
kseq[0] = 0
kan init 0

ki init 1
if(ki < iter && metro(1/ktime) == 1) then
    knext = kan - ki //step 1 ---> si sottrae

    kj = 0
    while (kj < ki) do //comincia il controllo dell'array
        kc = kseq[kj]
        if(kc == knext) then
            k1 = 1 //se l'elemento esiste allora genera valore 1
            kj = ki //funge da break point
            else
                k1 = 0 //se l'elemento non esiste allora genera valore 0
                kj += 1
            endif
        od

        if(kj = ki) then //è fondamentale che il contatore abbia finito di girare e solo in quel caso controlla!!!
            if(knext < 0 || k1 = 1) then //se l'elemento esiste o è inferiore a 0 si addiziona
                knext = kan + ki
                else
                    knext = knext //caso contrario si sottrae
                endif
            endif

            kan = knext
            kseq[ki] = knext
            ky = kseq[ki - 1]
            printf("%d\n", ki + 1, kseq[ki - 1])
            ki += 1
            if(ki == iter) then
                kan = 0
                ki = (ki%iter) + 1
                kseq[0] = 0
            endif
        endif

xout(ky)
    endop
