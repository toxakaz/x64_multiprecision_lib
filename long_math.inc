.data
	long_num struct
		alloc	dd	0	;qword count
		len		dd	0	;qword count
		h		dq	0
	long_num ends

;====================================================================================================
;	long_sum(x, y, z)
;	[in]		x	=	rcx	:	long_num ptr	|	first term
;	[in]		y	=	rdx	:	long_num ptr	|	second term
;	[in/out]	z	=	r8	:	long_num ptr	|	result
;	[out]		ret	=	rax	:	dd				|	error code
;====================================================================================================
long_sum		proto

;====================================================================================================
;	long_mul(x, y, z)
;	[in]		x	=	rcx	:	long_num ptr	|	first term
;	[in]		y	=	rdx	:	long_num ptr	|	second term
;	[in/out]	z	=	r8	:	long_num ptr	|	result
;	[out]		ret	=	rax	:	dd				|	error code
;====================================================================================================
long_mul		proto

;====================================================================================================
;	long_from_hex_string(s, sl, z)
;	[in]		s	=	rcx	:	byte ptr		|	string with hex num
;	[in]		sl	=	rdx	:	dd				|	string len
;	[in/out]	z	=	r8	:	long_num ptr	|	result
;	[out]		ret	=	rax	:	dd				|	error code
;====================================================================================================
long_from_hex_string	proto

;====================================================================================================
;	long_to_hex_string(s, sa/sl, z)
;	[in/out]	s	=	rcx	:	byte ptr		|	string with hex num
;	[in]		sa	=	rdx	:	dd				|	string allocated len
;	[out]		sl	=	rdx	:	dd				|	string len
;	[in]		z	=	r8	:	long_num ptr	|	long_num
;	[out]		ret	=	rax	:	dd				|	error code
;====================================================================================================
long_to_hex_string		proto