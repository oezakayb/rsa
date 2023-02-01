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
        cmp x1, 1
        b.ne .Lpow
        ret

    .Lret1:
        mov x0, 1
        ret

    .Lret0:
        mov x0, 0
        ret

 isprime://combination of naive algorithm
        //x0 is n
        cmp x0, 1 //if (n <= 1) return 0;
        b.le .Lfalse

        cmp x0, 3 //if (n <= 3) return 1;
        b.le .Ltrue

        mov x2, 2 //if (n % 2 == 0) return 0;
        sdiv x5, x0, x2
        msub x5, x5, x2, x0
        cbz x5, .Lfalse

        mov x2, 3 //if (n % 3 == 0) return 0;
        sdiv x5, x0, x2
        msub x5, x5, x2, x0
        cbz x0, .Lfalse

        mov x2, 5 //i = 5

        .Lprep:
        sdiv x5, x0, x2
        msub x5, x5, x2, x0
        cbz x5, .Ltrue

        cmp x2, 23 //squareing works after 25
        b.eq .LprepEnd

        add x2, x2, 2
	sdiv x5, x0, x2
	msub x5, x5, x2, x0
	cbz x5, .Ltrue

	add x2, x2, 4
        b .Lprep

//naive prime check algorithm---------------------------------
   .LprepEnd:
	cmp x0, 23
	b.eq .Ltrue

        mov x2, 5 //for (unsigned long i = 5; i * i <= n; i+=6)

   .LforStartNaive:
        mul x3, x2, x2
        cmp x3, x5
        b.gt .Ltrue

        sdiv x5, x0, x2
        msub x5, x5, x2, x0
        cbz x5, .Lfalse

        add x2, x2, 2
        sdiv x5, x0, x2
        msub x5, x5, x2, x0
        cbz x5, .Lfalse

        add x2, x2, 4
        b .LforStartNaive
//--------------------------------------------------------
//miller-rabin--------------------------------------------
//------------------------------------------------------
   .Lfalse:
        mov x0, 0
        ret

   .Ltrue:
        ret

 generateprimes:
	str x30, [sp, #-16]!
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
	ldr x30, [sp], #16
        ret

//x0 is phi(N)
//x1 is e
.Lextended_euclid:
//part1 - begin
        mov x8, 0 //loop counter
	mov x0, x9
	mov x1, x10
.Lloop:
        cbz x1, .Lreverse

        str x0, [sp, #-16]!

        sdiv x2, x0, x1
        msub x2, x1, x2, x0

        mov x0, x1
        mov x1, x2

        add x8, x8, 1 //increment counter
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

        subs x8, x8, 1 //loop as long as w5 > 0
        b.ne .Lnewloop

        add x3, x9, x3
	sdiv x4, x3, x9
	msub x3, x4, x9, x3
        b .Lending
//part2 - end
.Lretfalse:
        //set sp to initial position
        mov x0, #16
        mul x8, x8, x0
        add sp, sp, x8

	add x9, x9, 1
	b .LrechooseE

 get_rsa_params: //(*e, *d, *N)->--calculates and assigns the values
        //stp x0, x1, [sp, #-16]!
	str x30, [sp, #-16]!
	str x0, [sp, #-16]!
	str x1, [sp, #-16]!
        str x2, [sp, #-16]!
        //bl generateprimes
	//bl random64bit

	//because generate primes does not work properly, we assume that p = 29, q = 47
	//therefore phi(N) is 28 * 46 = 1288

	mov x0, 11 //p
	mov x1, 23 //q
	mul x6, x0, x1 //we store N at x6 and save it later in [x2] (we cannot use x6 anymore in other functions)

	sub x0, x0, 1
	sub x1, x1, 1
	mul x5, x0, x1 //phi(N) = 1288

	b .LchooseE //choosing e


.Lending:
	ldr x2, [sp], #16
	ldr x1, [sp], #16
	ldr x0, [sp], #16

	str x10, [x0]
	str x3, [x1]
	str x6, [x2]
	ldr x30, [sp], #16
	ret

.LchooseE:
	//preparation for extended_euclid
	mov x9, x5
	movz x10, 0x0001
	movk x10, 0x0001, lsl 16
	//1.case ==> phi(N) <= 65537
	//2.case ==> pih(N) > 65537

	cmp x5, x10
	b.gt .LchooseEbig

	b .LchooseEsmall

 .LchooseEbig:
	b .Lextended_euclid

 .LchooseEsmall:
	mov x10, 3
	b .Lextended_euclid

 .LrechooseE:
	add x10, x10, 1
	b .Lextended_euclid
