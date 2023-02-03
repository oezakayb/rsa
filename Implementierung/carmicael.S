.global carmicael
.text

carmicael:
        mov x1, x0    // x1 = n (input)
        mov x5, 1     // x5 = k(result) = 1
        mov x2, x1
        mov x4, 2     //x4 = i = 2(for loop counter)

        cmp x1, 1//if (n == 1|| n == 2)
        b.eq .Lspecialend
        cmp x1, 2
        b.eq .Lspecialend

.Lloop1:
        cmp x4, x2    //i < n
        b.ge .Lend2


        mov x0, x4      //gcd(i,n)
        mov x1, x2
        b .Lgcd      //if (gcd(i, n) != 1) go to next for loop

	mov x1, x2
        b .Lgcd      //if (gcd(i, n) != 1) go to next for loop

.Lcontinue:
        cmp x0, 1
        b.ne .LnextLoop

        mov x7, x4    //x7 = x = i

        mov x6, 1     //x6 = j = 1

.LwhileCondition:

        cmp x7, 1//while (x != 1)
        b.eq .LsetK

.LwhileLoop:
        mul x7, x7, x4
        udiv x8, x7, x2
        msub x7, x8, x2, x7


        add x6, x6, 1  //j++
        b .LwhileCondition


.LsetK:
        //setUp for gcd
        mov x0, x5
        mov x1, x6

        //k = (k*j)/gcd(k,j);
        mul x5, x5, x6

        b .Lgcd2
.Lcontinue2:
        udiv x5, x5, x0


.LnextLoop:
        add x4, x4, 1
        b .Lloop1



.Lend2:
        mov x0, x5
        ret

.Lspecialend:

        mov x0, 1
        ret



//x0 input1 : a
//x1 input2 : b
//gcd part
.Lgcd:
        cmp x0, 0
        b.eq .Lretb

        cmp x1, 0
        b.eq .Lend

        cmp x0, x1
        b.eq .Lend

        cmp x0, x1
        b.lt .Lsmaller
        sub x0, x0, x1
        b .Lgcd

.Lsmaller:
        sub x1, x1, x0
        b .Lgcd

.Lretb:
        mov x0, x1
        b .Lcontinue
.Lend:
        b .Lcontinue


.Lgcd2:
        cmp x0, 0
        b.eq .Lretb2

        cmp x1, 0
        b.eq .Lend3

        cmp x0, x1
        b.eq .Lend3

        cmp x0, x1
        b.lt .Lsmaller2
        sub x0, x0, x1
        b .Lgcd2

.Lsmaller2:
        sub x1, x1, x0
        b .Lgcd2

.Lretb2:
        mov x0, x1
        b .Lcontinue2
.Lend3:
        b .Lcontinue2
