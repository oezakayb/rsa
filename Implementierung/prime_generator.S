.global rsa_params
 .text
 // w0 number
 // w6 is 0
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