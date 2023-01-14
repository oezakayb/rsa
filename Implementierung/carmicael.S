.global charmicael
.text

//w0 input1 : a
//w1 input2 : b

gcd:
.Lloop:
        cmp w0, 0
        b.eq .Lretb

        cmp w1, 0
        b.eq .Lend

        cmp w0, w1
        b.eq .Lend

        cmp w0, w1
        b.lt .Lsmaller
        sub w0, w0, w1
        b .Lloop

.Lsmaller:
        sub w1, w1, w0
        b .Lloop

.Lretb:
        mov w0, w1
        ret
.Lend:
        ret



carmicael:
        mov w1, w0    // w1 = n (input)
        mov w5, 1     // w5 = k(result) = 1
        mov w2, w1
        mov w4, 2     //w4 = i = 2(for loop counter)

        cmp w1, 1//if (n == 1|| n == 2)
        b.eq .Lspecialend
        cmp w1, 2
        b.eq .Lspecialend

.Lloop1:
        cmp w4, w2    //i < n
        b.ge .Lend2


        mov w0, w4      //gcd(i,n)
        bl gcd        //if (gcd(i, n) != 1) go to next for loop
        cmp w0, 1
        b.ne .LnextLoop
        mov w7, w4    //w7 = x = i
        mov w6, 1     //w6 = j = 1

.LwhileCondition:
        cmp w7, 1//while (x != 1)
        b.ne .LsetK

.LwhileLoop:
        mul w7, w7, w4
        rem w7, w7, w2   //modulo

        add w6, w6, 1  //j++
        b .LwhileCondition


.LsetK:
        //setUp for gcd
        mov w0, w5
        mov w1, w6
        //k = (k*j)/gcd(k,j);
        mul w5, w5, w6
        bl gcd
        div w5, w5, w0


.LnextLoop:
        add w4, w4, 1
        b .Lloop1



.Lend2:
        mov w0, w5
        ret

.Lspecialend:
        mov w0, 1
        ret



    