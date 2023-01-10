.global get_rsa_params
.text

 isprime:
        mov x1, x0 //n
        cmp x1, 1 //if (n <= 1) return 0;
        b.ls .LifRes
        mov x2, 2 //for (unsigned long i = 2; i <= sqrt(n); i++)
        bl sqrt
        mov x3, x0

        //check for 2 and all even numbers
        cmp x2, x3
        b.hi .LforEnd
        udiv x0, x1, x2
        msub x0, x2, x0, x1
        cmp x0, 0
        b.eq .LifRes
        mov x2, 1

   .LforStart:
        add x2, 2
        cmp x2, x3
        b.hi .LforEnd
        udiv x0, x1, x2
        msub x0, x2, x0, x1
        cmp x0, 0
        b.ne .LforStart

   .LifRes:
        mov x0, 0
        ret

   .LforEnd:
        mov x0, 1
        ret

 generateprimes:
        //x1 = *q
        mov x2, x0 //*p

   .LwhileStart1:
        bl arc4random
        mov x3, x0
        bl arc4random
        mov x4, x0
        lsl x3, 32
        orr x3, x3, x4 //prand
        mov x0, x3

        bl isprime
        cmp x0, 0
        b.eq .LwhileStart1

        mov x6, 0xffffffffffffffff //optimize 2. prime generation
        udiv x6, x6, x3

   .LwhileStart2:
        bl arc4random
        mov x4, x0
        bl arc4random
        mov x5, x0
        lsl x4, 32
        orr x4, x4, x5 //qrand
        mov x0, x4

        cmp x0, x6
        b.hi .LwhileStart2

        bl isprime
        cmp x0, 0
        b.eq .LwhileStart2

        str x0, x3 //p
        str x1, x4 //q

        ret

 get_rsa_params:
        mov x3, x0 //*e
        mov x4, x1 //*d

        bl generateprimes
        //x0=p, x1=q
        mul x5, x0, x1 //x5 = n
        str x5, [x2] //x2 = *n
        sub x0, 1
        sub x1, 1
        mul x0, x0, x1 //phi(n) = (p-1)*(q-1)
        //choose e, calculate d
        str x0, [x3] //x0 = e
        str x1, [x4] //x1 = d

