option	casemap:none

public	long_sum
public	long_from_hex_string

;	structs
.data
	long_num struct
		alloc	dd	0	;qword count
		len		dd	0	;qword count
		h		dq	0
	long_num ends

;	variables
.data
	xs	dq	?
	x	dq	?
	xl	dd	?
	xa	dd	?

	ys	dq	?
	y	dq	?
	yl	dd	?
	ya	dd	?

	zs	dq	?
	z	dq	?
	zl	dd	?
	za	dd	?
	
	s	dq	?
	sl	dd	?
	sa	dd	?

;	errors
.data
	;not enough memory
	not_enough_mem		dq	01b
	invalid_num			dq	10b

.code
;====================================================================================================
;	long_sum(x, y, z)
;	[in]		x	=	rcx	:	long_num ptr	|	first term
;	[in]		y	=	rdx	:	long_num ptr	|	second term
;	[in/out]	z	=	r8	:	long_num ptr	|	result
;	[out]		ret	=	rax	:	dd				|	error code
;====================================================================================================
long_sum proc
	mov		r9, rsi
	mov		r10, rdi

	mov		xs, rcx
	mov		rax, long_num.h[rcx]
	mov		x, rax
	mov		eax, long_num.len[rcx]
	mov		xl, eax

	mov		rax, long_num.h[rdx]
	mov		y, rax
	mov		eax, long_num.len[rdx]
	mov		yl, eax

	mov		rax, long_num.h[r8]
	mov		z, rax
	mov		eax, long_num.alloc[r8]
	mov		za, eax

	call	long_sum_in

	mov		ecx, zl
	mov		long_num.len[r8], ecx

	mov		rdi, r10
	mov		rsi, r9

	ret
long_sum endp
;====================================================================================================
;====================================================================================================


;====================================================================================================
;	long_sum_in(x, y, z)
;	[in]		x	:	qword ptr		|	first term array
;	[in]		xl	:	dd				|	first term array len
;	[in]		y	:	qword ptr		|	second term array
;	[in]		yl	:	dd				|	second term array len
;	[in]		z	:	qword ptr		|	result array
;	[in]		za	:	dd				|	result array allocated len
;	[out]		zl	:	dd				|	result array len
;	[out]		rax	:	dd				|	error code
;
;	used:	rax, rcx, rsi, rdi
;====================================================================================================
long_sum_in proc
	mov		ecx, za
	cmp		xl, ecx
	jge		not_enough_memory
	cmp		yl, ecx
	jge		not_enough_memory
	mov		ecx, yl
	cmp		xl, ecx
	jl		y_greater

x_greater:
	mov		rcx, 0
	mov		ecx, xl
	mov		zl, ecx
	mov		rsi, x
	mov		rdi, z
	cld
	rep		movsq
	mov		qword ptr [rdi], 0
	mov		rsi, y
	mov		rcx, 0
	mov		ecx, yl
	jmp		pre_sum_loop

y_greater:
	mov		rcx, 0
	mov		ecx, yl
	mov		zl, ecx
	mov		rsi, y
	mov		rdi, z
	cld
	rep		movsq
	mov		rsi, x
	mov		rcx, 0
	mov		ecx, xl

pre_sum_loop:
	mov		rdi, z
	clc

sum_loop:
	lodsq
	adc		rax, qword ptr [rdi]
	stosq
	dec		rcx
	jnz		sum_loop

	jnc		carry_zero

carry_flag:
	mov		rax, qword ptr [rdi]
	adc		rax, 0
	stosq
	jc		carry_flag

carry_zero:
	sub		rdi, z
	shr		rdi, 3
	cmp		edi, zl
	cmovle	edi, zl
	mov		zl, edi
	mov		rax, 0
	ret
	
not_enough_memory:
	mov		zl, 0
	mov		rax, not_enough_mem
	ret
long_sum_in endp
;====================================================================================================
;====================================================================================================

;====================================================================================================
;	long_mul(x, y, z)
;	[in]		x	=	rcx	:	long_num ptr	|	first term
;	[in]		y	=	rdx	:	long_num ptr	|	second term
;	[in/out]	z	=	r8	:	long_num ptr	|	result
;	[out]		ret	=	rax	:	dd				|	error code
;====================================================================================================
long_mul proc
	mov		r9, rsi
	mov		r10, rdi

	mov		xs, rcx
	mov		rax, long_num.h[rcx]
	mov		x, rax
	mov		eax, long_num.len[rcx]
	mov		xl, eax

	mov		rax, long_num.h[rdx]
	mov		y, rax
	mov		eax, long_num.len[rdx]
	mov		yl, eax

	mov		zs, r8
	mov		rax, long_num.h[r8]
	mov		z, rax
	mov		eax, long_num.alloc[r8]
	mov		za, eax

	call	long_mul_in

	mov		r8, zs
	mov		ecx, zl
	mov		long_num.len[r8], ecx

	mov		rdi, r10
	mov		rsi, r9

	ret
long_mul endp
;====================================================================================================
;====================================================================================================

;====================================================================================================
;	long_mul_in(x, y, z)
;	[in]		x	:	qword ptr		|	first term array
;	[in]		xl	:	dd				|	first term array len
;	[in]		y	:	qword ptr		|	second term array
;	[in]		yl	:	dd				|	second term array len
;	[in]		z	:	qword ptr		|	result array
;	[in]		za	:	dd				|	result array allocated len
;	[out]		zl	:	dd				|	result array len
;	[out]		rax	:	dd				|	error code
;
;	used:	rax, rcx, rdx, r8, r11, rsi, rdi
;====================================================================================================
long_mul_in proc
	mov		rcx, 0
	mov		ecx, xl
	add		ecx, yl
	mov		rax, 0
	mov		eax, za
	cmp		rcx, rax
	jg		not_enough_memory
	
	mov		zl, ecx
	mov		rax, 0
	mov		rdi, z
	cld
	rep stosq
	
	mov		r11, 0
	mov		r11d, yl
	
loop1:

	dec		r11
	
	mov		rdi, r11
	shl		rdi, 3
	
	mov		r8, y
	mov		r8, qword ptr [r8 + rdi]
	
	add		rdi, z
	
	mov		rsi, x
	mov		rcx, 0
	mov		ecx, xl
	
loop2:
	
	lodsq
	mul		r8
	add		rax, qword ptr [rdi]
	stosq
	adc		rdx, qword ptr [rdi]
	mov		rax, rdx
	mov		rdx, rdi
	stosq
	jnc		loop_add_end
loop_add:
	mov		rax, qword ptr [rdi]
	adc		rax, 0
	stosq
	jc		loop_add
loop_add_end:
	mov		rdi, rdx
	dec		rcx
	jnz		loop2
	
	cmp		r11, 0
	jne		loop1
	
	mov		rdi, 0
	mov		edi, zl
	dec		rdi
	shl		rdi, 3
	add		rdi, z
	cmp		qword ptr [rdi], 0
	jnz		high_no_zero
	dec		zl
high_no_zero:
	
	mov		rax, 0
	ret
	
not_enough_memory:
	mov		zl, 0
	mov		rax, not_enough_mem
	ret
long_mul_in endp
;====================================================================================================
;====================================================================================================

;====================================================================================================
;	long_from_hex_string(s, sl, z)
;	[in]		s	=	rcx	:	byte ptr		|	string with hex num
;	[in]		sl	=	rdx	:	dd				|	string len
;	[in/out]	z	=	r8	:	long_num ptr	|	result long_num
;	[out]		ret	=	rax	:	dd				|	error code
;====================================================================================================
long_from_hex_string proc
	mov		r9, rsi
	mov		r10, rdi
	
	mov		s, rcx
	mov		sl, edx
	mov		rax, long_num.h[r8]
	mov		z, rax
	mov		eax, long_num.alloc[r8]
	mov		za, eax
	
	call	long_from_hex_string_in
	
	mov		rsi, r9
	mov		rdi, r10
	mov		r9d, zl
	mov		long_num.len[r8], r9d
	
	ret
long_from_hex_string endp
;====================================================================================================
;====================================================================================================


;====================================================================================================
;	long_from_hex_string_in(s, sl, z)
;	[in]		s	:	byte ptr		|	string with hex num
;	[in]		sl	:	dd				|	string len
;	[in/out]	z	:	qword ptr		|	result array
;	[in]		za	:	dd				|	result array allocated len
;	[out]		zl	:	dd				|	result array len
;	[out]		rax	:	dd				|	error code
;
;	used:		rax, rcx, rdx, rsi, rdi 
;====================================================================================================
long_from_hex_string_in proc
	mov		eax, sl
	mov		edx, eax
	and		edx, 1111b
	cmp		edx, 0
	mov		ecx, 1
	cmovne	edx, ecx
	shr		eax, 4
	add		eax, edx
	cmp		eax, za
	jg		not_enough_memory
	mov		zl, eax
	mov		rsi, 0
	mov		esi, sl
	add		rsi, s
	dec		rsi
	mov		rdi, z
	mov		qword ptr [rdi], 0
	mov		cl, 0
	std
lp1:
	cmp		rsi, s
	jl		lp1_end
lp1_no_check:
	mov		rax, 0
	lodsb
	sub		al, '0'
	cmp		al, 10
	jl		num_ok
	add		al, '0' - 'A' + 10
	cmp		al, 16
	jl		num_ok
	add		al, 'A' - 'a'
	cmp		al, 16
	jl		num_ok
	jmp		invalid_number
num_ok:
	cmp		al, 0
	jl		invalid_number
	shl		rax, cl
	or		qword ptr [rdi], rax
	add		cl, 4
	cmp		cl, 64
	jl		lp1
	cmp		rsi, s
	jl		lp1_end
	mov		cl, 0
	add		rdi, sizeof qword
	mov		qword ptr [rdi], 0
	jmp		lp1_no_check
lp1_end:
	mov		rax, 0
	ret
not_enough_memory:
	mov		zl, 0
	mov		rax, not_enough_mem
	ret
invalid_number:
	mov		zl, 0
	mov		rax, invalid_num
	ret
long_from_hex_string_in endp
;====================================================================================================
;====================================================================================================


;====================================================================================================
;	long_to_hex_string(s, sa, sl, z)
;	[in/out]	s	=	rcx	:	byte ptr		|	string with hex num
;	[in]		sa	=	rdx	:	dd				|	string allocated len
;	[out]		sl	=	rdx	:	dd				|	string len
;	[in]		z	=	r8	:	long_num ptr	|	long_num
;	[out]		ret	=	rax	:	dd				|	error code
;====================================================================================================
long_to_hex_string proc
	mov		r9, rsi
	mov		r10, rdi
	
	mov		s, rcx
	mov		sa, edx
	mov		rax, long_num.h[r8]
	mov		z, rax
	mov		eax, long_num.len[r8]
	mov		zl, eax
	
	call	long_to_hex_string_in
	
	mov		rdx, 0
	mov		edx, sl
	
	mov		rsi, r9
	mov		rdi, r10
	ret
long_to_hex_string endp
;====================================================================================================
;====================================================================================================


;====================================================================================================
;	long_to_hex_string_in(s, sa, sl, z)
;	[in/out]	s	:	byte ptr		|	string with hex num
;	[in]		sa	:	dd				|	string allocated len
;	[out]		sl	:	dd				|	string len
;	[in]		z	:	qword ptr		|	result array
;	[in]		zl	:	dd				|	result array len
;	[out]		rax	:	dd				|	error code
;
;	used:		rax, rcx, rdx, rsi, rdi
;====================================================================================================
long_to_hex_string_in proc
	cmp		zl, 0
	jne		not_empty_num
	mov		sl, 0
	mov		rax, 0
	ret
not_empty_num:
	mov		rsi, 0
	mov		esi, zl
	shl		rsi, 3
	add		rsi, z
	sub		rsi, sizeof qword
	mov		rax, qword ptr [rsi]
	mov		rcx, 16
lp1:
	shr		rax, 4
	dec		rcx
	cmp		rax, 0
	jne		lp1
lp1_end:
	mov		rax, rcx
	mov		rcx, 16
	sub		rcx, rax
	mov		rax, 0
	mov		eax, zl
	dec		rax
	shl		rax, 4
	add		rax, rcx
	cmp		eax, sa
	jg		not_enough_memory
	mov		sl, eax
	
	mov		rdi, s
	dec		rcx
	shl		rcx, 2
	cld
	
lp2:
	mov		rdx, qword ptr [rsi]
lp3:
	cmp		rcx, 0
	jl		lp3_end
	mov		rax, rdx
	shr		rax, cl
	and		rax, 0Fh
	cmp		al, 10
	jge		hex_num
	add		al, '0'
	jmp		rax_ready
hex_num:
	add		al, 'A' - 10
rax_ready:
	stosb
	sub		rcx, 4
	jmp		lp3
lp3_end:
	sub		rsi, sizeof qword
	cmp		rsi, z
	jl		lp2_end
	mov		rcx, 60
	jmp		lp2
lp2_end:
	mov		rax, 0
	ret
	
	
not_enough_memory:
	mov		sl, 0
	mov		rax, not_enough_mem
	ret
long_to_hex_string_in endp
;====================================================================================================
;====================================================================================================


end