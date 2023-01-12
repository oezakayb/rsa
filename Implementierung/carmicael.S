.global charmicael
.text

//w0 input1 : a
//w1 input2 : b

gcd:
.Lloop:
        cmp w0, 0
        b.eq .Lretb

        cmp w1, 0
        b.eq .Lretb

        cmp w0, w1
        b.eq .Lend

        cmp w0, w1
        b.lt .Lsmaller
        sub w0, w0, w1
        b .Lloop

.Lsmaller:
        sub w1, w1, w0
        b .Lloop

//if is not working than return 0      
.Lretb:
        mov w0, 0
        ret
.Lend:
        mov w0, 1
        ret


pow:
        //w0 = i
        //w1 = j
        mov w2, w0
.Lloop2:

        mov w3, 0     //as counter
        cmp w3, w1
        b.ge .Lend
        mul w0,w0,w2
        b. .Lloop2
.Lend:
        ret



charmicael:
        mov w1, w0    // w1 = n (input)
        mov w5, 1     // w5 = k(result) = 1
        mov w2, w1
        mov w4, 2     //w4 = i = 2(for loop counter)

.Lloop3:
        cmp w4, w2    //i < n
        b.ge .Lend

//need to change to w0 and w1
        bl gcd        //if (gcd(i, n) != 1) go to next for loop
        cmp w0, 0
        b.eq .LnextLoop
        mov w6, 1     //w6 = j = 1

/////////////////////////////////////////////////////

.LwhileLoop:
        //setup for pow
        mov w0, w4
        mov w1, w6
        //(pow(i, j) % n)
        bl pow
        mov w7, w0
        //%/////////////
        sdiv w8, w7, w2
        mul w9, w8, w2
        sub w10, w7, w9
        ////////////////
        cmp w10, 1
        b.eq .Lcheck
        add w6, w6, 1 //j++
        b. LwhileLoop

.Lcheck:
        cmp w6, w5//if(j < k)
        b.lt .Lupdate

.LnextLoop:
        add w4, w4, 1
        b .Lloop3


.Lupdate:
        mov w5, w6//k = j

.Lend:
        mov w0, w5
        ret



    