.global gcd
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
