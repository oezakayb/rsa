.global get_rsa_params_v5
.text

random32bit:
        movz x0, 0xfffe
        movk x0, 0xffff, lsl 16
        ret

.Lisprime://naive algorithm
        //x0 is n
        cmp x0, 1 //if (n <= 1) return 0;
        ble .Lfalse //generate new

        cmp x0, 3 //if (n <= 3) return 1;
        b.le .Ltrue

        mov x2, 2 //if (n % 2 == 0) return 0;
        sdiv x5, x0, x2
        msub x5, x5, x2, x0
        cbz x5, .Lfalse

        mov x2, 3 //if (n % 3 == 0) return 0;
        sdiv x5, x0, x2
        msub x5, x5, x2, x0
        cbz x5, .Lfalse

        mov x2, 5 //i = 5

        .Lprep:
	cmp x2, x0
	b.eq .Ltrue

        sdiv x5, x0, x2
        msub x5, x5, x2, x0
        cbz x5, .Lfalse

        cmp x2, 23 //squareing works after 25
        b.eq .LprepEnd

        add x2, x2, 2

	cmp x2, x0
	b.eq .Ltrue

	sdiv x5, x0, x2
	msub x5, x5, x2, x0
	cbz x5, .Lfalse

	add x2, x2, 4
        b .Lprep

//naive prime check algorithm---------------------------------
   .LprepEnd:
	cmp x0, 23
	b.eq .Ltrue

        mov x2, 5 //for (unsigned long i = 5; i * i <= n; i+=6)

   .LforStartNaive:
        mul x3, x2, x2
        cmp x3, x0
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

   .Lfalse:
        sdiv x0, x0, x2
        b .Lisprime

   .Ltrue:
        b .Lgotprime

generateprime:
	str x30, [sp, #-16]!

    //bl random32bit
    b .Lisprime
 .Lgotprime:
	//found prime
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

	b .LrechooseE

get_rsa_params_v5: //(*e, *d, *N)->--calculates and assigns the values
	str x30, [sp, #-16]!
	str x0, [sp, #-16]!
	str x1, [sp, #-16]!
        str x2, [sp, #-16]!

	//generate q
	movz x0, 0xfffd
	movk x0, 0xffff, lsl 16
        bl generateprime
	mov x13, x0 //x13 == q (move x0 to x13 because we still need to change x0 in the next function)

	//generate p
	bl random32bit
	bl generateprime
	//x0 == p

	mov x1, x13 //x1 == q
	mul x6, x0, x1 //we store N at x6 and save it later in [x2] (we cannot use x6 anymore in other functions)

	sub x0, x0, 1
	sub x1, x1, 1
	mul x5, x0, x1

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
	add x10, x10, 2
	b .Lextended_euclid