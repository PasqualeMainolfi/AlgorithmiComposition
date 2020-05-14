/*
...create a graph
*/

    opcode ajmatrixRand, k[][], io //matrice di adiacenza randomica n x n
istate, imode xin

/*
imode = default 0 ---> non orientato, 1 ---> orientato
*/

irow, icol = istate
kg[][] init irow, icol

ki init 0
while (ki < istate) do

    kj = ki
    while (kj < istate) do

        kvalue = int(random:k(0, 2))

        if(imode = 0) then
            kg[ki][kj] = kvalue
            kg[kj][ki] = kg[ki][kj]
        else
            kg[ki][kj] = kvalue
            if(kvalue = 0) then
                kg[kj][ki] = kvalue
            else
                kg[kj][ki] = -kvalue
            endif
        endif

        if(kj = ki) then
            kg[ki][kj] = 0 //in modo da non tornare a se stesso
            kg[kj][ki] = 0
        endif

        kj += 1
    od
    ki += 1
od

xout(kg)
    endop

    opcode dephGraph_1, k[][], ii //dependency graph ---> grafico aciclico diretto DAG modello 1
ix, iy xin

irow = ix * iy
icol = irow

kg[][] init irow, icol

kover init 0
kj init 0
if(kj < iy) then
    ki = 0
    while (ki < ix - 1) do
        kp = ki + kover
        kh = (ix - 1) + kover

        if(kp < irow - ix) then
            kg[kp][kp + 1] = 1 //movimento verso destra
            kg[kp][kp + ix] = 1 //movimento in alto
            kg[kp][kp + ix + 1] = 1 //movimento in diagonale (positivo)
            kg[kh][kh + ix] = 1
            else
                kg[kp][kp] = 1
            endif
        ki += 1
    od
    kover += ix
    kj += 1
endif

xout(kg)
    endop

    opcode dephGraph_1_i, i[][], ii //dependency graph ---> grafico aciclico diretto DAG modello 1
ix, iy xin

irow = ix * iy
icol = irow

ig[][] init irow, icol

iover init 0
ij = 0
while (ij < iy) do
    ii = 0
    while (ii < ix - 1) do
        ip = ii + iover
        ih = (ix - 1) + iover

        if(ip < irow - ix) then
            ig[ip][ip + 1] = 1 //movimento verso destra
            ig[ip][ip + ix] = 1 //movimento in alto
            ig[ip][ip + ix + 1] = 1 //movimento in diagonale (positivo)
            ig[ih][ih + ix] = 1
            else
                ig[ip][ip + 1] = 1
            endif
        ii += 1
    od
    iover += ix
    ij += 1
od

xout(ig)
    endop


    opcode dephGraph_2_i, i[][], ii //in tutte le direzione senza diagonale
ix, iy xin

ilen = ix * iy
irow, icol = ilen

igraph[][] init irow, icol

iover init 0
ii = 0
while (ii < iy) do
    ij = 0
    while (ij < ix - 1) do
        indx = ij + iover
        ip = (ix - 1) + iover
        im = iover

        if(indx < ilen - ix) then

            igraph[indx][indx - 1] = 1
            igraph[indx][indx + 1] = 1
            igraph[indx][indx + ix] = 1

            if(indx - ix > 0) then
                igraph[indx][indx - ix] = 1
            endif

            igraph[ip][ip + ix] = 1
            igraph[ip][ip - 1] = 1

            if(ip - ix > 0) then
                igraph[ip][ip - ix] = 1
            endif

            igraph[im][im - ix] = 1
            igraph[im][im + 1] = 1
            igraph[im][im + ix] = 1
            igraph[im][im - 1] = 0

            else

                if(indx < ilen - ix + 1) then
                    ival = 0
                    else
                        ival = 1
                    endif

                    igraph[indx][indx - 1] = ival
                    igraph[indx][indx + 1] = 1
                    igraph[indx][indx - ix] = 1
                    igraph[indx][indx - ix] = 1
                    ; igraph[ip][ip - 1] = 1 //movimento permesso ultimo stato
                    ; igraph[ip][ip - ix] = 1

             endif
        ij += 1
    od
    iover += ix
    ii += 1
od

xout(igraph)
    endop


    opcode wall, i[], i[][]iiii //inserisce zeri nel grafo, crea ostacoli
igraph[][], istate, inum, istart, iend xin

ii = 0
while (ii < inum) do
    ival = int(random(0, istate))

    if(ival = istart) then //in modo da evitare di poter piazzare un ostacolo all'arrivo
        ival = ival + 1
        elseif(ival = iend) then
            ival = ival - 1
            else
                ival = ival
            endif

    ij = 0
    while (ij < istate) do
        igraph[ival][ij] = 0
        igraph[ij][ival] = 0
        ij += 1
    od
    ii += 1
od
xout(igraph)
    endop
