.global extended_euclid
.text

extended_euclid:
        mov w5, 0 //loop counter
.Lloop:
        cmp w1, 0
        b.eq .Lreverse

        str w0, [sp, #-16]!

        sdiv w2, w0, w1
        msub w2, w1, w2, w0

        mov w0, w1
        mov w1, w2

        add w5, w5, 1 //increment counter
        b .Lloop

.Lreverse:
        //check if w0 is 0
        //if yes, then gcd is 1 and continue to newLoop
        //if no, return 0
        cmp w0, 1
        b.ne .Lretfalse

        mov w2, 1 //s
        mov w3, 0 //t

.Lnewloop:
        mov w1, w0
        ldr w0, [sp], #16

        sdiv w4, w0, w1
        mov w1, w3 //move t to other register
        msub w3, w3, w4, w2 //calculate t
        mov w2, w1 //s = t

        subs w5, w5, 1 //loop as long as w5 > 0
        b.ne .Lnewloop

        mov w0, w3
        ret

.Lretfalse:
        //set sp to initial position
        mov w0, #16
        mul w5, w5, w0
        add sp, sp, w5

        mov w0, 0
	ret