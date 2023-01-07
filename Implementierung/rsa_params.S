.global get_rsa_params
 .text
 // w0 number
 // w6 is 0

 isprime:
        mov x1, x0 //n
        cmp x1, 1 //if (n <= 1) return 0;
        bls .LifRes
        mov x2, 1 //for (unsigned long i = 2; i <= sqrt(n); i++)
        bl sqrt
        mov x3, x0

   .LforStart:
        add x2, 1
        cmp x2, x3
        bhi .LforEnd
        udiv x0, x1, x2
        msub x0, x2, x0, x1
        cmp x0, 0
        bne .LforStart

   .LifRes: mov x0, 0
        ret

   .LforEnd:
        mov x0, 1
        ret

 generateprime:
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
        beq .LwhileStart1

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
        bhi .LwhileStart2

        bl isprime
        cmp x0, 0
        beq .LwhileStart2

        str x3, [x2] //*p
        str x4, [x1] //*q

        ret


 semiprime:
         mov w6, 0
         mov w1, 2 //i
         mov w2, 0 //counter
 .Lloop:
         cmp w2 , 2
         b.ge .LendLoop
         mul w3, w1, w1
         cmp w3, w0
         b.gt .LendLoop
 .Lwhile:
         udiv w5, w0, w1
         mul w5, w5, w1
         sub w5, w0, w5
         cmp w5, 0
         b.ne .LendWhile
         udiv w0, w0, w1
         add w2, w2, 1
         b .Lwhile
 .LendWhile:
         add w1, w1, 1
        b .Lloop
 .LendLoop:
         cmp w0, 1
         b.le .Lend
         add w2, w2, 1
 .Lend:
         cmp w2, 2
         b.eq .Lequal
         mov w0, 0
         ret
 .Lequal:
         mov w0, 1
         ret
