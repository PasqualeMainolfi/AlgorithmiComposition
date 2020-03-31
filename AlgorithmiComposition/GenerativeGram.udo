/*
• GRAMMATICHE GENERATIVE
"...un insieme di regole che generano in modo ricorsivo le formule di un linguaggio"

- L-SYSTEM
*/

    opcode lSystem_encode, S, SSSSSi //genera la sequenza (stringa)
Saxi, Scondizione1, Srule1, Scondizione2, Srule2, iter xin

/*
Saxi = assioma
Scondizione1, Scondizione2 = condizioni
Srule1, Srule2 = regole di generazione collegate alle condizioni
iter = iterazione corrente
*/

icondizione1 = strchar(Scondizione1, 0)
icondizione2 = strchar(Scondizione2, 0)

Sout = Saxi

;prints("\n generazione[0] = %s (assioma di partenza) ------> [lenght = %d]\n", Saxi, strlen(Saxi))

ii = 0
while (ii < iter) do
    Snew = ""
    ilen = strlen(Sout) //aggiorna il valore di lunghezza stringa
    ij = 0
    while (ij < ilen) do
        icar = strchar(Sout, ij) //conversione da carattere a valore ASCII per confronto
        if(icar = icondizione1) then
            Snew = strcat(Snew, Srule1)
            elseif(icar == icondizione2) then
                Snew = strcat(Snew, Srule2)
            endif
            ij += 1
        od
        Sout = Snew
        ;printf_i("\n generazione[%d] = %s ------> [lenght = %d]\n\n", ii + 1, ii + 1, Sout, strlen(Sout))
        ii += 1
    od

xout(Sout)
    endop


    opcode sToAscii, i[], S[] //converte alfabeto in ascii
Salfabeto[] xin

ilen = lenarray(Salfabeto)
icar[] init ilen + 1

ii = 0
until (ii == ilen) do
    icar[ii] = strchar(Salfabeto[ii], 0)
    ii += 1
od

xout(icar)
    endop
