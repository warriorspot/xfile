;
; PROGRAM "tokenize"
;
;
; DECLARE FUNCTION  Entry ()
.data
.align 8
%%%firstStatic:
%%%entered:
.zero  8
;
.text
.globl _Entry@0
;
;
; EXPORT
;
; DECLARE FUNCTION  Tokenize (in$, @out$[], @delimiter$)
.globl _Tokenize@12
;
; END EXPORT
;
;
; FUNCTION  Entry ()
.text
.text
	jmp	%_StartLibrary_tokenize		;;; 200
PrologCode:
	ret			;;; 202
;
.globl  %_StartLibrary_tokenize
%_StartLibrary_tokenize:
	call	func1		;;; 208
	ret	0		;;; 209
;
_Entry@0:
;
;  *****
;  *****  FUNCTION  Entry ()  *****
;  *****
func1:
	push	ebp		;;; 110
	mov	ebp,esp		;;; 111
	sub	esp,256		;;; 112
	mov	[ebp-12],esi		;;; 113
	mov	[ebp-16],edi		;;; 114
	mov	[ebp-20],ebx		;;; 115
	call	%%%%initOnce		;;; 116
;
funcBody1:
;
; IF LIBRARY(0) THEN RETURN
	sub	esp,64		;;; 627
	mov	eax,0		;;; 868
	xor	eax,eax		;;; 682
	not	eax		;;; 683
	add	esp,64		;;; 809
	or	eax,eax		;;; 269
	jz	else.0001		;;; 270
	xor	eax,eax		;;; 1108
	jmp	end.func1		;;; 313
else.0001:
end.if.0001:
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func1:
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret			;;; 108
;
;
%%%%initOnce:
	mov	eax,[%%%entered]		;;; 127
	or	eax,eax		;;; 128
	jnz	%%%%initOnceDone		;;; 129
	mov	esi,%%%firstStatic		;;; 130
	mov	edi,%%%lastStatic		;;; 131
	call	%_ZeroMemory		;;; 137
	call	PrologCode		;;; 138
	call	InitSharedComposites		;;; 139
	mov	[%%%entered],-1		;;; 140
%%%%initOnceDone:
	ret			;;; 142
;
;
.globl %%%%blowback_tokenize
%%%%blowback_tokenize:
	mov	[%%%entered],0		;;; 143
	ret			;;; 144
;
;
; FUNCTION  Tokenize (@in$, @out$[], @delim$)
.text
_Tokenize@12:
;
;  *****
;  *****  FUNCTION  Tokenize ()  *****
;  *****
func2:
	push	ebp		;;; 110
	mov	ebp,esp		;;; 111
	sub	esp,256		;;; 112
	mov	[ebp-12],esi		;;; 113
	mov	[ebp-16],edi		;;; 114
	mov	[ebp-20],ebx		;;; 115
	cld			;;; 117
	lea	edi,[ebp-44]		;;; 118
	mov	ecx,6		;;; 119
	xor	eax,eax		;;; 120
	rep			;;; 121
	stosd			;;; 122
;
funcBody2:
;
; XLONG i
;
; XLONG count
;
; st$ = ""
	xor	eax,eax		;;; 3
	lea	ebx,[ebp-32]		;;; 6
	mov	esi,[ebx]		;;; 7
	mov	[ebx],eax		;;; 8
	call	%____free		;;; 9
;
;
; REDIM out$[]
	sub	esp,64		;;; 536
	mov	esi,[ebp+12]		;;; 875
	call	%_FreeArray		;;; 537
	mov	esi,0		;;; 877
	mov	[ebp+12],esi		;;; 884
	add	esp,64		;;; 539
;
; count = 0
	mov	eax,0		;;; 868
	mov	[ebp-28],eax		;;; 884
;
;
; IF(in$ == "") THEN RETURN 0
	mov	eax,[ebp+8]		;;; 875
	xor	ebx,ebx		;;; 867
	call	%_string.compare.vv		;;; 909
	jne	else.0002		;;; 268
	mov	eax,0		;;; 868
	jmp	end.func2		;;; 313
else.0002:
end.if.0002:
;
;
; IF(delim$ == "") THEN
	mov	eax,[ebp+16]		;;; 875
	xor	ebx,ebx		;;; 867
	call	%_string.compare.vv		;;; 909
	jne	else.0003		;;; 268
;
; REDIM out$[0] : out$[0] = in$
	sub	esp,64		;;; 536
	mov	eax,0		;;; 868
	mov	[esp+16],eax		;;; 540
	mov	esi,[ebp+12]		;;; 875
	mov	[esp],esi		;;; 541
	mov	[esp+4],1		;;; 542
	mov	[esp+8],-1072496636		;;; 543
	mov	[esp+12],0		;;; 544
	call	%_RedimArray		;;; 545
	add	esp,64		;;; 546
	mov	[ebp+12],eax		;;; 884
	mov	eax,[ebp+8]		;;; 875
	call	%_clone.a0		;;; 30
	mov	ecx,[ebp+12]		;;; 875
	lea	ebx,[ecx]		;;; 581
	mov	esi,[ebx]		;;; 36
	mov	[ebx],eax		;;; 37
	call	%____free		;;; 38
;
; RETURN 1
	mov	eax,1		;;; 868
	jmp	end.func2		;;; 313
;
; END IF
else.0003:
end.if.0003:
;
;
; FOR i = 0 TO LEN(in$)
	mov	eax,0		;;; 868
	mov	[ebp-24],eax		;;; 884
	mov	eax,[ebp+8]		;;; 875
	or	eax,eax		;;; 793
	jz	%0003		;;; 794
	mov	eax,[eax-8]		;;; 795
%0003:
	mov	[ebp-36],eax		;;; 884
for.0004:
	mov	eax,[ebp-24]		;;; 875
	mov	ebx,[ebp-36]		;;; 875
	cmp	eax,ebx		;;; 194
	jg	end.for.0004		;;; 195
;
; IFZ(INSTR(delim$, CHR$(in${i}))) THEN
	sub	esp,64		;;; 627
	mov	eax,[ebp+16]		;;; 875
	mov	[esp],eax		;;; 1130
	sub	esp,64		;;; 627
	mov	eax,[ebp-24]		;;; 875
	mov	edx,[ebp+8]		;;; 875
	movzx	eax,byte ptr [edx+eax]		;;; 581
	mov	[esp],eax		;;; 1130
	mov	[esp+4],1		;;; 757
	call	%_chr.d		;;; 758
	add	esp,64		;;; 809
	mov	[esp+4],eax		;;; 1130
	mov	[esp+8],0		;;; 749
	call	%_instr.vs		;;; 750
	add	esp,64		;;; 809
	or	eax,eax		;;; 241
	jnz	else.0005		;;; 242
;
; IF(i == LEN(in$)) THEN
	mov	eax,[ebp+8]		;;; 875
	or	eax,eax		;;; 793
	jz	%0004		;;; 794
	mov	eax,[eax-8]		;;; 795
%0004:
	mov	ebx,[ebp-24]		;;; 875
	cmp	eax,ebx		;;; 902
	jne	else.0006		;;; 268
;
; GOSUB Add
	call	%s%Add%2		;;; 211
;
; RETURN count
	mov	eax,[ebp-28]		;;; 875
	jmp	end.func2		;;; 313
;
; END IF
else.0006:
end.if.0006:
;
; st$ = st$ + CHR$(in${i})
	sub	esp,64		;;; 627
	mov	eax,[ebp-24]		;;; 875
	mov	edx,[ebp+8]		;;; 875
	movzx	eax,byte ptr [edx+eax]		;;; 581
	mov	[esp],eax		;;; 1130
	mov	[esp+4],1		;;; 757
	call	%_chr.d		;;; 758
	add	esp,64		;;; 809
	mov	ebx,[ebp-32]		;;; 875
	call	%_concat.ubyte.a0.eq.a1.plus.a0.vs		;;; 992
	lea	ebx,[ebp-32]		;;; 6
	mov	esi,[ebx]		;;; 7
	mov	[ebx],eax		;;; 8
	call	%____free		;;; 9
;
; ELSE
	jmp	end.if.0005		;;; 98
else.0005:
;
; GOSUB Add
	call	%s%Add%2		;;; 211
;
; END IF
end.if.0005:
;
; NEXT i
do.next.0004:
	inc	[ebp-24]		;;; 278
	jmp	for.0004		;;; 280
end.for.0004:
;
; RETURN count
	mov	eax,[ebp-28]		;;; 875
	jmp	end.func2		;;; 313
;
;
; SUB Add
	jmp	out.sub2.0		;;; 317
%s%Add%2:
;
; IF(st$ != "") THEN
	mov	eax,[ebp-32]		;;; 875
	xor	ebx,ebx		;;; 867
	call	%_string.compare.vv		;;; 909
	je	else.0007		;;; 268
;
; size = UBOUND(out$[])
	mov	eax,[ebp+12]		;;; 875
	or	eax,eax		;;; 793
	jz	%0006		;;; 794
	mov	eax,[eax-8]		;;; 795
%0006:
	dec	eax		;;; 792
	mov	[ebp-44],eax		;;; 884
;
; REDIM out$[size + 1]
	sub	esp,64		;;; 536
	mov	eax,[ebp-44]		;;; 875
	add	eax,1		;;; 986
	mov	[esp+16],eax		;;; 540
	mov	esi,[ebp+12]		;;; 875
	mov	[esp],esi		;;; 541
	mov	[esp+4],1		;;; 542
	mov	[esp+8],-1072496636		;;; 543
	mov	[esp+12],0		;;; 544
	call	%_RedimArray		;;; 545
	add	esp,64		;;; 546
	mov	[ebp+12],eax		;;; 884
;
; out$[UBOUND(out$[])] = st$
	mov	eax,[ebp-32]		;;; 875
	call	%_clone.a0		;;; 30
	mov	ebx,[ebp+12]		;;; 875
	or	ebx,ebx		;;; 793
	jz	%0007		;;; 794
	mov	ebx,[ebx-8]		;;; 795
%0007:
	dec	ebx		;;; 792
	mov	ecx,[ebp+12]		;;; 875
	lea	ebx,[ecx+ebx*4]		;;; 581
	mov	esi,[ebx]		;;; 36
	mov	[ebx],eax		;;; 37
	call	%____free		;;; 38
;
; INC count
	inc	[ebp-28]		;;; 67
;
; st$ = ""
	xor	eax,eax		;;; 3
	lea	ebx,[ebp-32]		;;; 6
	mov	esi,[ebx]		;;; 7
	mov	[ebx],eax		;;; 8
	call	%____free		;;; 9
;
; END IF
else.0007:
end.if.0007:
;
; END SUB
end.sub2.0:
	ret			;;; 145
out.sub2.0:
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func2:
	mov	esi,[ebp-32]		;;; 875
	call	%____free		;;; 531
	xor	edx,edx		;;; 532
	mov	[ebp-32],edx		;;; 884
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret	12		;;; 105
;
; END PROGRAM
end_program:
.data
.zero  8
%%%lastStatic:
.zero  8
.text
	push	ebp		;;; 146
	mov	ebp,esp		;;; 147
	sub	esp,128		;;; 148
;
;
;
;
	mov	esp,ebp		;;; 151
	pop	ebp		;;; 152
	ret			;;; 153
;
;
InitSharedComposites:
	ret			;;; 163
;
;
; *****  DEFINE LITERAL STRINGS  *****
;
.text
.align 8
.dword	32, 0, 8, 0x80130001
@_string.0029:
.byte	"tokenize"
.zero	8
.dword	32, 0, 5, 0x80130001
@_string.Entry:
.byte	"Entry"
.zero	11
.dword	32, 0, 15, 0x80130001
@_string.StartLibrary:
.byte	"%_StartLibrary_"
.zero	1
