# x64_multiprecision_lib
x64 multiprecision library for Windows written in assembler

## Functions done:

### Structure for multiprecision number
    long_num struct
        alloc	dd	0   ; allocated len (qword count)
        len		dd	0   ; used len (qword count)
        h		dq	0   ; qword array which contains multiprecision number
    long_num ends

### Sum function
    long_sum(x, y, z)
    [in]		x	=	rcx	:	long_num ptr	|   first term
    [in]		y	=	rdx	:	long_num ptr	|   second term
    [in/out]	z	=	r8	:	long_num ptr	|   result
    [out]		ret	=	rax	:	dd              |   error code

### Mul function (in a column only)
    long_mul(x, y, z)
    [in]		x	=	rcx	:	long_num ptr	|   first term
    [in]		y	=	rdx	:	long_num ptr	|   second term
    [in/out]	z	=	r8	:	long_num ptr	|   result
    [out]		ret	=	rax	:	dd              |   error code

### Hex string to multiprecision number
    long_from_hex_string(s, sl, z)
    [in]		s	=	rcx	:	byte ptp        |   string with hex num
    [in]		sl	=	rdx	:	dd              |   string len
    [in/out]	z	=	r8	:	long_num ptr    |   result
    [out]		ret	=	rax	:	dd              |   error code

### Multiprecision number to hex string
    long_to_hex_string(s, sa/sl, z)
    [in/out]	s	=	rcx	:	byte ptr        |   string with hex num
    [in]		sa	=	rdx	:	dd              |   string allocated len
    [out]		sl	=	rdx	:	dd              |   string len
    [in]		z	=	r8	:	long_num ptr    |   long_num
    [out]		ret	=	rax	:	dd              |   error code

## ToDo:

- CMake source for better testing experience
- Multiplication using Karatsuba algorithm
