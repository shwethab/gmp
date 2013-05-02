dnl  ARM mpn_copyi.

dnl  Contributed to the GNU project by Robert Harley and Torbjörn Granlund.

dnl  Copyright 2003, 2012, 2013 Free Software Foundation, Inc.

dnl  This file is part of the GNU MP Library.

dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of the GNU Lesser General Public License as published
dnl  by the Free Software Foundation; either version 3 of the License, or (at
dnl  your option) any later version.

dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
dnl  License for more details.

dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.

include(`../config.m4')

C	     cycles/limb
C StrongARM	 ?
C XScale	 ?
C Cortex-A7	 ?
C Cortex-A8	 ?
C Cortex-A9	 1.25-1.5
C Cortex-A15	 1.25

C TODO
C  * Consider wider unrolling.  Analogous 8-way code runs 10% faster on both A9
C    and A15.  But it probably slows things down for 8 <= n < a few dozen.

define(`rp', `r0')
define(`up', `r1')
define(`n',  `r2')

ASM_START()
PROLOGUE(mpn_copyi)
	tst	n, #1
	beq	L(skip1)
	ldr	r3, [up], #4
	str	r3, [rp], #4
L(skip1):
	tst	n, #2
	beq	L(skip2)
	ldmia	up!, { r3,r12 }
	stmia	rp!, { r3,r12 }
L(skip2):
	bics	n, n, #3
	beq	L(rtn)

	push	{ r4-r5 }
	subs	n, n, #4
	ldmia	up!, { r3,r4,r5,r12 }
	beq	L(end)

L(top):	subs	n, n, #4
	stmia	rp!, { r3,r4,r5,r12 }
	ldmia	up!, { r3,r4,r5,r12 }
	bne	L(top)

L(end):	stm	rp, { r3,r4,r5,r12 }
	pop	{ r4-r5 }
L(rtn):	bx	lr
EPILOGUE()
