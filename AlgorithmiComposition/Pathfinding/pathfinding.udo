    opcode adapt, k, kkkkk
kIn, kOutMin, kOutMax, kInMin, kInMax xin
kY = (((kIn - kInMin) * (kOutMax - kOutMin)) / (kInMax - kInMin)) + kOutMin
xout(kY)
    endop

    opcode value2xy, ii, ii //calcolo coordinate per funzione di costo
ivalue, ix xin
inum = ivalue/ix
ix = round(frac(inum) * ix)
iy = int(inum)
xout(ix, iy)
    endop

    opcode value2xy_k, kk, ki //calcolo coordinate per funzione di costo
kvalue, ix xin
knum = kvalue/ix
kx = round(frac(knum) * ix)
ky = int(knum)
xout(kx, ky)
    endop

    opcode xy2value, i, iii //calcolo stato in matrice
ix, iy, ixx xin
inum = (iy + (ix/ixx)) * ixx
xout(inum)
    endop

    opcode g, i, iiii //ci serve per il calcolo di g
ix1, ix2, iy1, iy2 xin
idist = abs(ix2 - ix1) + abs(iy2 - iy1)
xout(idist + 1)
    endop

    opcode h, i, iiii //ci serve per il calcolo di h (in questo caso uguale ad g, ulteriore se si vuole modificare)
ix1, ix2, iy1, iy2 xin
idx = abs(ix2 - ix1)
idy = abs(ix2 - ix1)
idist = sqrt(idx + idy)
xout(idist)
    endop

    opcode fCost, i, ii //calcolo della funzione di costo
ig, ih xin
xout(ig + ih)
    endop

    opcode add2arr_i, i[], i[]ij //aggiungere elementi ad array
iarrIn[], ielement, ipos xin

ilen = lenarray(iarrIn) + 1
iout[] init ilen

if(ipos == -1) then
    ipos = lenarray(iarrIn)
    else
        ipos = ipos
    endif

iadd, idiff = 0
while (iadd < ilen) do
    iread = iadd - idiff
    if(iadd = ipos) then
        iout[iadd] = ielement
        idiff = 1
        else
            iout[iadd] = iarrIn[iread]
        endif
        iadd += 1
    od

xout(iout)
    endop

    opcode removeFromArray_i, i[], i[]i //rimuovere elementi da array
iarrIn[], ielement xin

ilen = lenarray(iarrIn)
iout[] init ilen

iwrite = 0
iread = 0
while (iread < ilen) do
    if(iarrIn[iread] != ielement) then
        iout[iwrite] = iarrIn[iread]
        iwrite += 1
    endif
    iread += 1
od

trim(iout, iwrite)
xout(iout)
    endop

        opcode neighbors, i[], i[][]ii //calcolo dei vicini del nodo aperto
imatrix[][], indx, istate xin

iout[] init 1

ii, ip = 0
while (ii < istate) do
    ieval = imatrix[indx][ii]
    if(ieval = 1) then
        iout[] = add2arr_i(iout, ii, ip)
        ip += 1
    endif
    ii += 1
od

trim(iout, ip)
xout(iout)
        endop

    opcode arrIn, i, i[]i //controlla se l'elemento esiste nell'array
iarr[], iel xin

ival = 0
ii = 0
while (ii < lenarray(iarr)) do
    if(iel = iarr[ii]) then
        ival = 1
        igoto break
    endif
    ii += 1
od

break:
xout(ival)
    endop

    opcode arrReplace, i[], i[]ii //sostituisce un elemento di un array con un altro dato
iarr[], ivalue, indx xin

ii = 0
while (ii < lenarray(iarr)) do
    if(ii = indx) then
        iarr[ii] = ivalue
    endif
    ii += 1
od

xout(iarr)
    endop

    opcode removeIndx, i[], i[]i
ia[], indx xin

ilen = lenarray(ia)

ii = indx
while (ii < ilen - 1) do
    ia[ii] = ia[ii + 1]
    ii += 1
od
trim(ia, ilen - 1)
xout(ia)
    endop

/*
...pathfinding A* star
*/

    opcode A_star, i[]i[][], i[][]iiiiii //A* search
igraph[][], ix, iy, istartx, istarty, iendx, iendy xin

/*
igraph[][] = matrice di adiacenza grafo
ix, iy = max value on x e max value on y
istartx, istarty = punto di partenza nel piano
iendx, iendy = punto di arrivo nel piano (goal)
*/

ilen = ix * iy

iopenSet[] init 1
iclosedSet[] init 1
icostValue[] init ilen
imaxValue = 10^7 //set +inf
icostValue[] = icostValue + imaxValue
ipath[] init 1
iroot[] init 1
ipercorso[][] init ilen, ilen

istart = xy2value(istartx, istarty, ix)
iend = xy2value(iendx, iendy, ix)

igStart = 0
ihStart = h(istartx, iendx, istarty, iendy)
ifStart = fCost(igStart, ihStart)

iopenSet[] = fillarray(istart)
icostValue[] = arrReplace(icostValue, ifStart, 0)
ipath[] = fillarray(istart)

icurrent = istart
iopenCount = 1
ival, icomp = 0
while (iopenCount > 0) do //fino a che openSet.lenght > 0

    iwin, io = 0
    while (io < lenarray(iopenSet)) do
        if(icostValue[iopenSet[io]] < icostValue[iopenSet[iwin]]) then
            iwin = io
        endif
        io += 1
    od

    icurrent = iopenSet[iwin]
    icostValue[] = arrReplace(icostValue, imaxValue, iopenSet[iwin])
    ipath[] = add2arr_i(ipath, icurrent, -1) //registriamo il valore corrente

    if(icurrent = iend) goto done

    ineighbors[] = neighbors(igraph, icurrent, ilen) //calcolo i vicini dello stato corrente

    ij = 0
    while (ij < lenarray(ineighbors)) do
        ineigh = ineighbors[ij]
        if(arrIn(iclosedSet, ineigh) = 0) then

            ixcurrent, iycurrent value2xy icurrent, ix
            ixneigh, iyneigh value2xy ineigh, ix

            igopenNode = g(ixcurrent, istartx, iycurrent, istarty) //calcolo dist dal nodo aperto al nodo start
            igneighToOpen = g(ixneigh, ixcurrent, iyneigh, iycurrent) //calcolo dist dal vicino al corrente
            igneighToStart = g(ixneigh, istartx, iyneigh, istarty) //g value neighbor

            itemp_g = igopenNode + igneighToOpen

            if(arrIn(iopenSet, ineigh) = 1) then
                if(itemp_g < igneighToStart) then //controlliamo se g calcolato dal nodo vicino attraverso il nodo corrente è effettivamente minore del g del nodo vicino
                    igneighToStart = itemp_g
                endif

                else //se non esiste in openSet
                    igneighToStart = itemp_g
                    iopenSet[] = add2arr_i(iopenSet, ineigh, -1)
                    iopenCount += 1 //aggiungiamo vicini, teniamo il conto della lunghezza dell'array
                endif

                    ih = h(ixneigh, iendx, iyneigh, iendy)
                    icost = fCost(igneighToStart, ih)
                    icostValue[] = arrReplace(icostValue, icost, ineigh)

                    icomp += 1 //conteggio operazioni di visita

                    prints("STO CERCANDO... IN VALUTAZIONE:\t[%d]\r", ineigh)

            endif
            ij += 1
        od
        ival += 1 //conteggio nodi estratti

        //printarray(iopenSet, "%d")
        iopenCount -= 1 //togliamo dal conto il valore corrente, in modo da tenere sempre aggiornato il conteggio della lunghezza di openSet
        iopenSet[] = removeFromArray_i(iopenSet, icurrent)
        iclosedSet[] = add2arr_i(iclosedSet, icurrent, -1)

    if(iopenCount = 0) goto break //la ricerca fallisce quando openSet è vuoto

od

done: //label soluzione trovata
//ricotruiamo il percorso, risaliamo l'albero delle posizioni
ie = lenarray(ipath) - 1
iq = ie - 1
while (iq >= 0) do
    iprec = ipath[iq]
    isucc = ipath[ie]

    ivic[] = neighbors(igraph, iprec, ilen)
    icontrolla = arrIn(ivic, isucc)

    if(icontrolla = 1) then
        iroot[] = add2arr_i(iroot, iprec, 0)
        //prints("%d \t%d \t%d\n", lenarray(ipath) - 1, iq, ie)
        ie = iq
        iq -= 1
        else
            iq -= 1
    endif
od

iroot[] = arrReplace(iroot, iend, lenarray(iroot) - 1)

idraw = 0
while (idraw < lenarray(iroot) - 1) do
    ipercorso[iroot[idraw]][iroot[idraw + 1]] = 1
    ipercorso[istartx][istarty] = 0
    idraw += 1
od

ipercent1 = ival * 100/ilen
ipercent2 = lenarray(iroot) * 100/ival
ilenRoot = lenarray(iroot)

prints("\n")
prints("\nDONE:\nHO TROVATO LA SOLUZIONE, HO RAGGIUNTO LA DESTINAZIONE!\n---> COLLEGAMENTI CONTROLLATI = %d\n---> CITTÀ CONSIDERATE = %d di %d (%.3f%%)\n---> CITTÀ ESTRATTE DA QUELLE CONSIDERATE = %d (%.3f%%)\n", icomp, ival, ilen, ipercent1, ilenRoot, ipercent2)
prints("\n")
printarray(ipath, "%d", "NODI CONSIDERATI:")
prints("\n")
prints("\n...QUESTO È UNO DEI POSSIBILI TRAGITTI PIÙ BREVI PER ARRIVARE ALLA TUA DESTINAZIONE!\nPARTENDO DALLA CITTÀ [%d] DOVRAI ATTRAVERSARE [%d] CITTÀ PER ARRIVARE ALLA CITTÀ [%d] DI DESTINAZIONE\n\n", istart, ilenRoot, iend)
printarray(iroot, "%d", "PERCORSO MIGLIORE TROVATO:")
prints("\n")
goto esci

break: //label soluzione non trovata
prints("\nFAILURE:\nNON SONO RIUSCITO A TROVARE LA SOLUZIONE...")
prints("\n")
goto esci

esci:
xout(iroot, ipercorso)
    endop
