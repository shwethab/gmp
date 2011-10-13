dnl  S/390-64 mpn_rshift

dnl  Copyright 2011 Free Software Foundation, Inc.

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

C            cycles/limb
C z990           4.3

C FIXME
C  * Streamline feed-in code.

C INPUT PARAMETERS
define(`rp',	`%r2')
define(`up',	`%r3')
define(`n',	`%r4')
define(`cnt',	`%r5')

define(`tnc',	`%r6')

ASM_START()
PROLOGUE(mpn_rshift)
	stmg	%r6, %r9, 48(%r15)

	lg	%r9, 0(up)

	srlg	%r8, n, 2		C loop count
	lcgr	tnc, cnt

	lghi	%r7, 3
	srlg	%r0, %r9, 0(cnt)

	ngr	%r7, n			C n mod 4
	je	L(b0)
	aghi	%r8, 1
	cghi	%r7, 2
	jl	L(b1)
	je	L(b2)

L(b3):	lghi	%r1, -16
	j	L(m3)
L(b0):	lghi	%r1, -8
	j	L(m0)
L(b1):	lghi	%r1, 0
	brctg	%r8, L(top)
	j	L(end)
L(b2):	lghi	%r1, -24
	j	L(m2)

L(top):	lg	%r7, 8(%r1,up)
	sllg	%r4, %r7, 0(tnc)
	ogr	%r4, %r0
	srlg	%r0, %r7, 0(cnt)
	stg	%r4, 0(%r1,rp)
L(m0):	lg	%r7, 16(%r1,up)
	sllg	%r4, %r7, 0(tnc)
	ogr	%r4, %r0
	srlg	%r0, %r7, 0(cnt)
	stg	%r4, 8(%r1,rp)
L(m3):	lg	%r7, 24(%r1,up)
	sllg	%r4, %r7, 0(tnc)
	ogr	%r4, %r0
	srlg	%r0, %r7, 0(cnt)
	stg	%r4, 16(%r1,rp)
L(m2):	lg	%r7, 32(%r1,up)
	sllg	%r4, %r7, 0(tnc)
	ogr	%r4, %r0
	srlg	%r0, %r7, 0(cnt)
	stg	%r4, 24(%r1,rp)
	aghi	%r1, 32
	brctg	%r8, L(top)

L(end):	stg	%r0, 0(%r1,rp)
	sllg	%r2, %r9, 0(tnc)
	lmg	%r6, %r9, 48(%r15)
	br	%r14
EPILOGUE()