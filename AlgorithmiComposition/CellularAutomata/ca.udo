    opcode grid1d, i[], i
ilen xin
igrid[] init ilen
ii = 0
while (ii < ilen) do
    igrid[ii] = floor(random(0, 2))
    ii += 1
od
xout(igrid)
    endop

    opcode grid2d, i[][], ii
irows, icols xin
igrid[][] init irows, icols
ii = 0
while (ii < irows) do
    ij = 0
    while (ij < icols) do
        igrid[ii][ij] = floor(random(0, 2))
        ij += 1
    od
    ii += 1
od
xout(igrid)
    endop

//AUTOMA CELLULARE MONODIMENSIONALE (CLASSIFICAZIONE DI WOLFRAM)

    opcode rule, i, ii //regola di generazione (Wolfram Rules)
irule, isum xin

/*
irule = da 0 a 255, regola di generazione da applicare
isum = valore controllo celle adiacenti
*/

iaRule[] init 8 //array che contiene la regola
ii = 0
while (irule > 0) do
    iaRule[ii] = irule%2
    irule = int(irule/2)
    ii += 1
od
ivalue = iaRule[isum] //il valore corrisponde all'indice dell'array
xout(ivalue)
    endop

    opcode simpleCa, i[], i[]i
igrid[], irule xin

//automa cellulare monodimensionale

ilen = lenarray(igrid)
inextGen[] init ilen

ii = 0
while (ii < ilen) do
    isum = 0
    ibin = 2
    ij = -1
    while (ij < 2) do
        indx = (ij + ii + ilen)%ilen //wrap around
        isum += igrid[indx] * 2^ibin //da binario a decimale, in modo da trovare la configurazione e generare lo stato successivo
        ij += 1
        ibin -= 1
    od
    inextGen[ii] = rule(irule, isum) //generazione dello stato successivo
    ii += 1
od
xout(inextGen)
    endop

    opcode simpleCa_2d, i[][], i[]ii
igrid[], irule, imaxGeneration xin

//genera una matrice a due dimensioni di righe pari al numero totale di generazioni e colonne pari al numero totale di celle

irows = imaxGeneration
icols = lenarray(igrid)
imatCa[][] init irows, icols

ii, iwRows = 0
while (ii < imaxGeneration) do
    inextState[] = simpleCa(igrid, irule)

    iwCols = 0
    while (iwCols < icols) do
        imatCa[iwRows][iwCols] = inextState[iwCols]
        iwCols += 1
    od

    igrid[] = inextState
    ii += 1
    iwRows += 1
od
xout(imatCa)
    endop



//AUTOMA CELLULARE THE GAME OF LIFE DO JOHN CONWAY

//i-rate version

    opcode neighCount, i, i[][]iiii //sommatoria vicini
igrid[][], irows, icols, iyState, ixState xin

isum = 0
ii = -1
while (ii < 2) do
    iy = (ii + iyState + irows)%irows //wrap around (quando sul bordo della griglia valuta il suo estremo opposto)
    ij = -1
    while (ij < 2) do
        ix = (ij + ixState + icols)%icols //wrap around
        isum += igrid[iy][ix]
        ij += 1
    od
    ii += 1
od
isum -= igrid[iyState][ixState] //sottraiamo il valore della cella corrente dalla sommatoria
xout(isum)
    endop


    opcode gameOfLife, i[][], i[][]ii
igrid[][], irows, icols xin

/*
automa cellulare su modello di Life o Game of Life di J. Conway
*/

inextGen[][] init irows, icols

ii = 0
while (ii < irows) do
    ij = 0
    while (ij < icols) do
        istate = igrid[ii][ij]
        iliveNeigh = neighCount(igrid, irows, icols, ii, ij)

        if(istate = 1 && (iliveNeigh < 2 || iliveNeigh > 3)) then
            inextState = 0
            elseif(istate = 0 && iliveNeigh == 3) then
                inextState = 1
            else
                inextState = istate
        endif

        inextGen[ii][ij] = inextState
        ij += 1
    od
    ii += 1
od
xout(inextGen)
    endop

//k-rate version

    opcode neighCount_k, k, k[][]iikk //sommatoria vicini
kgrid[][], irows, icols, kyState, kxState xin

ksum = 0
ki = -1
while (ki < 2) do
    ky = (ki + kyState + irows)%irows //wrap around (quando sul bordo della griglia valuta il suo estremo opposto)
    kj = -1
    while (kj < 2) do
        kx = (kj + kxState + icols)%icols //wrap around
        ksum += kgrid[ky][kx]
        kj += 1
    od
    ki += 1
od
ksum -= kgrid[kyState][kxState] //sottraiamo il valore della cella corrente dalla sommatoria
xout(ksum)
    endop

    opcode gameOfLife_k, k[][], k[][]ii
kgrid[][], irows, icols xin

knextGen[][] init irows, icols

ki = 0
while (ki < irows) do
    kj = 0
    while (kj < icols) do
        kstate = kgrid[ki][kj]
        kliveNeigh = neighCount_k(kgrid, irows, icols, ki, kj)

        if(kstate = 1 && (kliveNeigh < 2 || kliveNeigh > 3)) then
            knextState = 0
            elseif(kstate = 0 && kliveNeigh == 3) then
                knextState = 1
            else
                knextState = kstate
        endif

        knextGen[ki][kj] = knextState
        kj += 1
    od
    ki += 1
od
xout(knextGen)
    endop
