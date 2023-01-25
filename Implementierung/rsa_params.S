.data
seed: .quad 0x12345678
mult: .quad 0x5DEECE66D
inc: .quad 0xB

.global get_rsa_params
.text

random64bit:
        ldr x0, =seed
        ldr x1, [x0]
        ldr x2, =mult
        ldr x3, =inc
        mul x1, x1, x2
        add x1, x1, x3
        mul x4, x1, x2
        add x4, x4, x3
        str x4, [x0]
        mov x0, x1
        lsl x0, x0, 32
        orr x0, x0, x4
        ret

 pow:
        cbz x1, .Lret1
        cbz x0, .Lret0

    .Lpow:
        mul x0, x0, x0
        sub x1, x1, 1
        cbnz x1, .Lpow
        ret

    .Lret1:
        mov x0, 1
        ret

    .Lret0:
        mov x0, 0
        ret

 isprime://combination of naive algorithm and miller rabin
        mov x5, x0 //n
        cmp x5, 1 //if (n <= 1) return 0;
        b.ls .Lfalse

        cmp x5, 3 //if (n <= 3) return 1;
        b.ls .Ltrue

        mov x2, 2 //if (n % 2 == 0) return 0;
        udiv x0, x5, x2
        msub x0, x2, x0, x5
        cbz x0, .Lfalse

        mov x2, 3 //if (n % 3 == 0) return 0;
        udiv x0, x5, x2
        msub x0, x2, x0, x5
        cbz x0, .Lfalse

        //if n>=2^62 miller-rabin will be used for performance
        mov x0, 0x4000000000000000
        cmp x0, x5
        b.ls .LmillerRabin

        mov x2, 5 //i = 5

        .Lprep:
        udiv x0, x5, x2
        msub x0, x2, x0, x5
        cbz x0, .Ltrue

        cmp x2, 23 //squareing works after 25
        b.eq .LprepEnd

        add x2, x2, 2
        udiv x0, x5, x2
        msub x0, x2, x0, x5
        cbz x0, .Ltrue

        add x2, x2, 4
        b .Lprep

//naive prime check algorithm---------------------------------
   .LprepEnd:
        mov x2, 5 //for (unsigned long i = 5; i * i <= n; i+=6)

   .LforStartNaive:
        mul x3, x2, x2
        cmp x3, x5
        b.hi .Ltrue

        udiv x0, x5, x2
        msub x0, x2, x0, x5
        cbz x0, .Lfalse

        add x2, x2, 2
        udiv x0, x5, x2
        msub x0, x2, x0, x5
        cbz x0, .Lfalse

        add x2, x2, 4
        b .LforStartNaive
//--------------------------------------------------------
//miller-rabin--------------------------------------------
   .LmillerRabin:
        //k = 4
        sub x10, x5, 1 //d = n - 1
        mov x11, 0 // s = 0

        .LsLoop:
        mov x0, 2
        udiv x1, x10, x0
        msub x1, x1, x0, x10
        cbnz x1, .LsLoopEnd
        udiv x10, x10, x0
        add x11, x11, 1
        b .LsLoop
        .LsLoopEnd:

        mov x12, 0 //i=0
        .LforLoop:
        cmp x12, 4
        b.eq .Ltrue

        bl random64bit
        sub x1, x5, 3 // n-3
        udiv x6, x0, x1 //x0 = rand()% n - 3
        msub x0, x6, x1, x0
        add x0, x0, 2// x0 = a
        mov x1, x10 //d
        bl pow //pow(a, d) x0=x
        udiv x1, x0, x5
        msub x0, x5, x1, x0

        mov x6, 0 //j = 0
        mov x7, 0 // y = 0
            .LforJLoop:
            cmp x11, x6
            b.ls .LforJLoopEnd
            mul x7, x0, x0
            udiv x9, x7, x1
            msub x7, x9, x1, x7

            cmp x7, 1
            b.ne .Lif
            cmp x0, 1
            b.eq .Lif
            sub x9, x1, 1
            cmp x0, x9
            b.ne .Lfalse

            .Lif:
            mov x0, x7
            add x6, x6, 1
            b .LforJLoop

        .LforJLoopEnd:
        cmp x7, 1 //y!=1 ret false
        b.ne .Lfalse

        add x2, x2, 1
        b .LforLoop
//------------------------------------------------------
   .Lfalse:
        mov x0, 0
        ret

   .Ltrue:
        mov x0, 1
        ret

 generateprimes:
   .LwhileStart1:
        bl random64bit
        mov x13, x0
        bl isprime
        cbz x0, .LwhileStart1

        mov x15, 0xffffffffffffffff //optimize 2. prime generation
        udiv x15, x15, x13

   .LwhileStart2:
        bl random64bit
        cmp x0, x15
        b.hi .LwhileStart2
        mov x14, x0
        bl isprime
        cbz x0, .LwhileStart2

        mov x0, x13 //p
        mov x1, x14 //q

        ret

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
        mov x5, 0 //loop counter
.Lloop:
        cbz x1, .Lreverse

        str x0, [sp, #-16]!

        sdiv x2, x0, x1
        msub x2, x1, x2, x0

        mov x0, x1
        mov x1, x2

        add x5, x5, 1 //increment counter
        b .Lloop
//part1 - end
//part2 - begin
.Lreverse:
        //check if w0 is 1
        //if yes, then gcd is 1 and continue to newLoop
        //if no, return 0
        cmp x0, 1
        b.ne .Lretfalse

        mov x2, 1 //s
        mov x3, 0 //t

.Lnewloop:
        mov x1, x0
        ldr x0, [sp], #16

        sdiv x4, x0, x1
        mov x1, x3 //move t to other register
        msub x3, x3, x4, x2 //calculate t
        mov x2, x1 //s = t

        subs x5, x5, 1 //loop as long as w5 > 0
        b.ne .Lnewloop

        mov x0, x3
        ret
//part2 - end
.Lretfalse:
        //set sp to initial position
        mov x0, #16
        mul x5, x5, x0
        add sp, sp, x5

        mov x0, 0
	ret

 get_rsa_params: //(*e, *d, *N)->--calculates and assigns the values
        stp x0, x1, [sp, #-16]!

        bl generateprimes
        //x0=p, x1=q
        mul x3, x0, x1 //x3 = n
        str x3, [x2] //x2 = *n
        sub x0, x0, 1
        sub x1, x1, 1
        mul x0, x0, x1 //phi(n) = (p-1)*(q-1)
        mov x6, x0
        mov x7, 2
        udiv x7, x3, x7 // x7 = e

.LchooseE:
        mov x1, x7
        bl extended_euclid
        cbnz x0, .LendChooseE // x0 = d
        add x7, x7, 1
        b .LchooseE
.LendChooseE:

        ldp x0, x1, [sp], #16
        str x0, [x7] //x0 = e
        str x1, [x0] //x1 = d
        ret

