.global extended_euclid
.text
//you can delete this explanation later
//for example : N = 40 and e = 17
// part1
// N   e
// 40  17
// 17  6 = 40 mod 17
// 6   5 = 17 mod 6
// 5   1 = 6 mod 5
// 1   0 = 5 mod 1
// we want to save the number 40, 17, 6, 5, 1 in the stack
// because we will need it later in part2

//part2
//we calculate s and t
//t is the output we want (it is d according to Aufgabe)
// to calculate s and t :
// the value of current s is the value of previous t
// the value of t is (previous s) - stack[current]/stack[current+1] * (previous t)
// s   t
// 1   0
// 0   1
// 1   -1
extended_euclid:
//part1 - begin
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
//part1 - end
//part2 - begin
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
//part2 - end
.Lretfalse:
        //set sp to initial position
        mov w0, #16
        mul w5, w5, w0
        add sp, sp, w5

        mov w0, 0
	ret