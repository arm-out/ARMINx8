         000  00   0000

add	 000  00   rd	    R	
sub	 000  01   rd	    R
and	 000  10   rd	    R
xor	 000  11   rd	    R

or	 001  00   rd  	    R
not	 001  01   rd	    R
rxor     001  10   rd	    R
lsl	 001  11   rd	    R

lsr	 010  00   rd	    R
inc	 010  01   rd	    R
lwr	 010  10   rd	    R
swr	 010  11   rd	    R

set	 011  XX   XXXX	    I
movi     100  rs   0X	    R R
movo     101  0X   rd	    R
bneq	 110  00   XXXX	    B
beq      110  01   XXXX	    B
bgt      110  10   XXXX	    B         
blt      110  11   XXXX	    B

halt    111   11   1111     H