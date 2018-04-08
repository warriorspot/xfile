;
;
; PROGRAM "tearoff"
;
; VERSION  "0.1"
;
;
; IMPORT   "xst"   ' Standard library : required by most programs
;
; IMPORT   "xgr"   ' GraphicsDesigner : required by GuiDesigner programs
;
; IMPORT   "xui"   ' GuiDesigner      : required by GuiDesigner programs
;
; 'parent and v0 together uniquely identify the tearoff
;
; TYPE TEAROFF
;
; XLONG .grid
;
; XLONG .parent
;
; XLONG .v0
;
; XLONG .wingrid
;
; FUNCADDR XLONG .callback(XLONG,XLONG,XLONG,XLONG,XLONG,XLONG, XLONG, ANY)
;
; END TYPE
;
;
; INTERNAL FUNCTION  Entry         ()
.data
.align 8
%%%firstStatic:
%%%entered:
.zero  8
;
.text
;
; EXPORT
;
; DECLARE FUNCTION  CreateTearOff (parent, kid, v0)
.globl _CreateTearOff@12
;
; DECLARE FUNCTION  GetTearoffs(@grids[])
.globl _GetTearoffs@4
;
; DECLARE FUNCTION  CloseTearoff(grid)
.globl _CloseTearoff@4
;
; DECLARE FUNCTION  CloseAllTearoffs()
.globl _CloseAllTearoffs@0
;
; DECLARE FUNCTION  HideTearoff(grid)
.globl _HideTearoff@4
;
; DECLARE FUNCTION  ShowTearoff(grid)
.globl _ShowTearoff@4
;
; END EXPORT
;
; INTERNAL FUNCTION TearOffCallback(grid, message, v0, v1, v2, v3, kid, ANY)
;
;
; SHARED TEAROFF Tearoffs[]
.text
	jmp	%_StartLibrary_tearoff		;;; 45
PrologCode:
	push	ebp		;;; 47
	mov	ebp,esp		;;; 48
	sub	esp,256		;;; 49
;
.data
.align	4
%%%Tearoffs:	.zero  4
.text
;
;
;
; FUNCTION  Entry ()
.text
	mov	esp,ebp		;;; 203
	pop	ebp		;;; 204
	ret			;;; 205
;
.globl  %_StartLibrary_tearoff
%_StartLibrary_tearoff:
	call	func1		;;; 208
	ret	0		;;; 209
;
Entry@0:
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
; XgrMessageNameToNumber(@"Selection", @#Selection)
;
; EXTERNAL FUNCTION  XgrMessageNameToNumber       (messageName$, @messageNumber)
.globl _XgrMessageNameToNumber@8
.data
.align	4
%#Selection:	.zero  4
.text
	push	[%#Selection]		;;; 888
	push	@_string.003D		;;; 852
	call	_XgrMessageNameToNumber@8		;;; 817
	mov	esi,[esp-4]		;;; 1125
	mov	[%#Selection],esi		;;; 882
;
; XgrMessageNameToNumber(@"Callback", @#Callback)
.data
.align	4
%#Callback:	.zero  4
.text
	push	[%#Callback]		;;; 888
	push	@_string.003F		;;; 852
	call	_XgrMessageNameToNumber@8		;;; 817
	mov	esi,[esp-4]		;;; 1125
	mov	[%#Callback],esi		;;; 882
;
; XgrMessageNameToNumber(@"CloseWindow", @#CloseWindow)
.data
.align	4
%#CloseWindow:	.zero  4
.text
	push	[%#CloseWindow]		;;; 888
	push	@_string.0041		;;; 852
	call	_XgrMessageNameToNumber@8		;;; 817
	mov	esi,[esp-4]		;;; 1125
	mov	[%#CloseWindow],esi		;;; 882
;
; IF LIBRARY(0) THEN RETURN        ' main program executes message loop
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
.globl %%%%blowback_tearoff
%%%%blowback_tearoff:
	mov	[%%%entered],0		;;; 143
	ret			;;; 144
;
;
; FUNCTION ShowTearoff(grid)
.text
_ShowTearoff@4:
;
;  *****
;  *****  FUNCTION  ShowTearoff ()  *****
;  *****
func7:
	push	ebp		;;; 110
	mov	ebp,esp		;;; 111
	sub	esp,256		;;; 112
	mov	[ebp-12],esi		;;; 113
	mov	[ebp-16],edi		;;; 114
	mov	[ebp-20],ebx		;;; 115
;
funcBody7:
;
; XuiSendStringMessage(grid, @"DisplayWindow", 0,0,0,0,0,0)
;
; EXTERNAL FUNCTION  XuiSendStringMessage       (grid, message$, v0, v1, v2, v3, kid, ANY)
.globl _XuiSendStringMessage@32
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.0045		;;; 852
	push	[ebp+8]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func7:
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret	4		;;; 105
;
;
; FUNCTION HideTearoff(grid)
.text
_HideTearoff@4:
;
;  *****
;  *****  FUNCTION  HideTearoff ()  *****
;  *****
func6:
	push	ebp		;;; 110
	mov	ebp,esp		;;; 111
	sub	esp,256		;;; 112
	mov	[ebp-12],esi		;;; 113
	mov	[ebp-16],edi		;;; 114
	mov	[ebp-20],ebx		;;; 115
;
funcBody6:
;
; XuiSendStringMessage(grid, @"HideWindow", 0,0,0,0,0,0)
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.0047		;;; 852
	push	[ebp+8]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func6:
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret	4		;;; 105
;
;
; FUNCTION GetTearoffs(@grids[])
.text
_GetTearoffs@4:
;
;  *****
;  *****  FUNCTION  GetTearoffs ()  *****
;  *****
func3:
	push	ebp		;;; 110
	mov	ebp,esp		;;; 111
	sub	esp,256		;;; 112
	mov	[ebp-12],esi		;;; 113
	mov	[ebp-16],edi		;;; 114
	mov	[ebp-20],ebx		;;; 115
	cld			;;; 117
	lea	edi,[ebp-28]		;;; 118
	mov	ecx,2		;;; 119
	xor	eax,eax		;;; 120
	rep			;;; 121
	stosd			;;; 122
;
funcBody3:
;
; SHARED TEAROFF Tearoffs[]
;
;
; REDIM grids[]
	sub	esp,64		;;; 536
	mov	esi,[ebp+8]		;;; 875
	call	%_FreeArray		;;; 537
	mov	esi,0		;;; 877
	mov	[ebp+8],esi		;;; 884
	add	esp,64		;;; 539
;
; FOR i = 0 TO UBOUND(Tearoffs[])
	mov	eax,0		;;; 868
	mov	[ebp-24],eax		;;; 884
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%0007		;;; 794
	mov	eax,[eax-8]		;;; 795
%0007:
	dec	eax		;;; 792
	mov	[ebp-28],eax		;;; 884
for.0002:
	mov	eax,[ebp-24]		;;; 875
	mov	ebx,[ebp-28]		;;; 875
	cmp	eax,ebx		;;; 194
	jg	end.for.0002		;;; 195
;
; REDIM grids[i]
	sub	esp,64		;;; 536
	mov	eax,[ebp-24]		;;; 875
	mov	[esp+16],eax		;;; 540
	mov	esi,[ebp+8]		;;; 875
	mov	[esp],esi		;;; 541
	mov	[esp+4],1		;;; 542
	mov	[esp+8],-1073217532		;;; 543
	mov	[esp+12],0		;;; 544
	call	%_RedimArray		;;; 545
	add	esp,64		;;; 546
	mov	[ebp+8],eax		;;; 884
;
; grids[i] = Tearoffs[i].grid
	mov	eax,[ebp-24]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	eax,[eax]		;;; 421
	mov	ebx,[ebp-24]		;;; 875
	mov	ecx,[ebp+8]		;;; 875
	lea	ebx,[ecx+ebx*4]		;;; 581
	mov	[ebx],eax		;;; 40
;
; NEXT i
do.next.0002:
	inc	[ebp-24]		;;; 278
	jmp	for.0002		;;; 280
end.for.0002:
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func3:
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret	4		;;; 105
;
;
; FUNCTION CloseAllTearoffs()
.text
_CloseAllTearoffs@0:
;
;  *****
;  *****  FUNCTION  CloseAllTearoffs ()  *****
;  *****
func5:
	push	ebp		;;; 110
	mov	ebp,esp		;;; 111
	sub	esp,256		;;; 112
	mov	[ebp-12],esi		;;; 113
	mov	[ebp-16],edi		;;; 114
	mov	[ebp-20],ebx		;;; 115
	cld			;;; 117
	lea	edi,[ebp-36]		;;; 118
	mov	ecx,4		;;; 119
	xor	eax,eax		;;; 120
	rep			;;; 121
	stosd			;;; 122
;
funcBody5:
;
; SHARED TEAROFF Tearoffs[]
;
;
; FOR i = 0 TO UBOUND(Tearoffs[])
	mov	eax,0		;;; 868
	mov	[ebp-24],eax		;;; 884
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%000B		;;; 794
	mov	eax,[eax-8]		;;; 795
%000B:
	dec	eax		;;; 792
	mov	[ebp-28],eax		;;; 884
for.0003:
	mov	eax,[ebp-24]		;;; 875
	mov	ebx,[ebp-28]		;;; 875
	cmp	eax,ebx		;;; 194
	jg	end.for.0003		;;; 195
;
; XuiSendStringMessage(Tearoffs[i].grid, @"DestroyWindow", 0,0,0,0,0,0)
	mov	eax,[ebp-24]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	eax,[eax]		;;; 421
	mov	[ebp-36],eax		;;; 884
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.004D		;;; 852
	push	[ebp-36]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; NEXT i
do.next.0003:
	inc	[ebp-24]		;;; 278
	jmp	for.0003		;;; 280
end.for.0003:
;
;
; REDIM Tearoffs[]
	sub	esp,64		;;; 536
	mov	esi,[%%%Tearoffs]		;;; 873
	call	%_FreeArray		;;; 537
	mov	esi,0		;;; 877
	mov	[%%%Tearoffs],esi		;;; 882
	add	esp,64		;;; 539
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func5:
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret			;;; 108
;
;
; FUNCTION  CreateTearOff (wingrid, kid, v0)
.text
_CreateTearOff@12:
;
;  *****
;  *****  FUNCTION  CreateTearOff ()  *****
;  *****
func2:
	push	ebp		;;; 110
	mov	ebp,esp		;;; 111
	sub	esp,256		;;; 112
	mov	[ebp-12],esi		;;; 113
	mov	[ebp-16],edi		;;; 114
	mov	[ebp-20],ebx		;;; 115
	cld			;;; 117
	lea	edi,[ebp-100]		;;; 118
	mov	ecx,20		;;; 119
	xor	eax,eax		;;; 120
	rep			;;; 121
	stosd			;;; 122
;
funcBody2:
;
; SHARED TEAROFF Tearoffs[]
;
;
; XuiSendStringMessage(wingrid, @"GetGridNumber", @grid, 0,0,0, kid, 0)
	push	0		;;; 865
	push	[ebp+12]		;;; 891
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	[ebp-24]		;;; 891
	push	@_string.0052		;;; 852
	push	[ebp+8]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
	mov	esi,[esp-24]		;;; 1125
	mov	[ebp-24],esi		;;; 884
;
; 'Disallow multiple tearoffs
;
; FOR i = 0 TO UBOUND(Tearoffs[])
	mov	eax,0		;;; 868
	mov	[ebp-28],eax		;;; 884
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%000F		;;; 794
	mov	eax,[eax-8]		;;; 795
%000F:
	dec	eax		;;; 792
	mov	[ebp-32],eax		;;; 884
for.0004:
	mov	eax,[ebp-28]		;;; 875
	mov	ebx,[ebp-32]		;;; 875
	cmp	eax,ebx		;;; 194
	jg	end.for.0004		;;; 195
;
; IF(Tearoffs[i].parent == grid && Tearoffs[i].v0 == v0) THEN
	mov	eax,[ebp-28]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	eax,[eax+4]		;;; 421
	mov	ebx,[ebp-24]		;;; 875
	cmp	eax,ebx		;;; 902
	mov	eax,0		;;; 585
	jne	%0010		;;; 586
	not	eax		;;; 587
%0010:
	mov	ebx,[ebp-28]		;;; 875
	mov	ecx,[%%%Tearoffs]		;;; 873
	imul	ebx,20		;;; 584
	lea	ebx,[ecx+ebx]		;;; 581
	mov	ebx,[ebx+8]		;;; 421
	mov	[ebp-40],eax		;;; 884
	mov	eax,[ebp+16]		;;; 875
	cmp	eax,ebx		;;; 902
	mov	eax,0		;;; 585
	jne	%0011		;;; 586
	not	eax		;;; 587
%0011:
	mov	ebx,[ebp-40]		;;; 875
	neg	eax		;;; 965
	rcr	eax,1		;;; 966
	sar	eax,31		;;; 967
	mov	edx,ebx		;;; 968
	neg	edx		;;; 969
	rcr	edx,1		;;; 970
	sar	edx,31		;;; 971
	and	eax,edx		;;; 955
	or	eax,eax		;;; 269
	jz	else.0005		;;; 270
;
; RETURN $$FALSE
	mov	eax,0		;;; 868
	jmp	end.func2		;;; 313
;
; END IF
else.0005:
end.if.0005:
;
; NEXT i
do.next.0004:
	inc	[ebp-28]		;;; 278
	jmp	for.0004		;;; 280
end.for.0004:
;
; upper = UBOUND(Tearoffs[]) + 1
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%0013		;;; 794
	mov	eax,[eax-8]		;;; 795
%0013:
	dec	eax		;;; 792
	add	eax,1		;;; 986
	mov	[ebp-44],eax		;;; 884
;
; REDIM Tearoffs[upper]
	sub	esp,64		;;; 536
	mov	eax,[ebp-44]		;;; 875
	mov	[esp+16],eax		;;; 540
	mov	esi,[%%%Tearoffs]		;;; 873
	mov	[esp],esi		;;; 541
	mov	[esp+4],1		;;; 542
	mov	[esp+8],-1071251436		;;; 543
	mov	[esp+12],0		;;; 544
	call	%_RedimArray		;;; 545
	add	esp,64		;;; 546
	mov	[%%%Tearoffs],eax		;;; 882
;
;
; XuiSendStringMessage(grid, @"GetTextArray", 0,0,0,0,1, @text$[])
	push	[ebp-48]		;;; 891
	push	1		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.0057		;;; 852
	push	[ebp-24]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
	mov	esi,[esp-4]		;;; 1125
	mov	[ebp-48],esi		;;; 884
;
; XuiSendStringMessage(grid, @"GetFontNumber", @font, 0,0,0,1,0)
	push	0		;;; 865
	push	1		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	[ebp-52]		;;; 891
	push	@_string.0059		;;; 852
	push	[ebp-24]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
	mov	esi,[esp-24]		;;; 1125
	mov	[ebp-52],esi		;;; 884
;
; DO
do.0006:
;
; XstReplaceArray($$FindForward, @text$[], "_", "", @line, @pos, @match)
;
; EXTERNAL FUNCTION  XstReplaceArray                (mode, text$[], find$, replace$, line, pos, match)
.globl _XstReplaceArray@28
	mov	eax,@_string.005C		;;; 872
	call	%_clone.a0		;;; 821
	mov	[ebp-40],eax		;;; 884
	push	[ebp-64]		;;; 891
	push	[ebp-60]		;;; 891
	push	[ebp-56]		;;; 891
	push	0		;;; 876
	push	[ebp-40]		;;; 891
	push	[ebp-48]		;;; 891
	push	0		;;; 865
	call	_XstReplaceArray@28		;;; 817
	sub	esp,28		;;; 819
	mov	esi,[esp+4]		;;; 1125
	mov	[ebp-48],esi		;;; 884
	mov	esi,[esp+8]		;;; 1119
	call	%____free		;;; 1120
	mov	esi,[esp+16]		;;; 1125
	mov	[ebp-56],esi		;;; 884
	mov	esi,[esp+20]		;;; 1125
	mov	[ebp-60],esi		;;; 884
	mov	esi,[esp+24]		;;; 1125
	mov	[ebp-64],esi		;;; 884
	add	esp,28		;;; 820
;
; LOOP WHILE match
do.loop.0006:
	mov	eax,[ebp-64]		;;; 875
	or	eax,eax		;;; 241
	jnz	do.0006		;;; 242
end.do.0006:
;
; XuiSendStringMessage(wingrid, @"GetCallback", @foo, @callback, 0,0,0,0)
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	[ebp-72]		;;; 891
	push	[ebp-68]		;;; 891
	push	@_string.0060		;;; 852
	push	[ebp+8]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
	mov	esi,[esp-24]		;;; 1125
	mov	[ebp-68],esi		;;; 884
	mov	esi,[esp-20]		;;; 1125
	mov	[ebp-72],esi		;;; 884
;
; XgrGetGridWindow(grid, @window)
;
; EXTERNAL FUNCTION  XgrGetGridWindow             (grid, @window)
.globl _XgrGetGridWindow@8
	push	[ebp-76]		;;; 891
	push	[ebp-24]		;;; 891
	call	_XgrGetGridWindow@8		;;; 817
	mov	esi,[esp-4]		;;; 1125
	mov	[ebp-76],esi		;;; 884
;
; XgrGetWindowPositionAndSize(window, @x, @y, @w, @h)
;
; EXTERNAL FUNCTION  XgrGetWindowPositionAndSize  (window, @xDisp, @yDisp, @width, @height)
.globl _XgrGetWindowPositionAndSize@20
	push	[ebp-92]		;;; 891
	push	[ebp-88]		;;; 891
	push	[ebp-84]		;;; 891
	push	[ebp-80]		;;; 891
	push	[ebp-76]		;;; 891
	call	_XgrGetWindowPositionAndSize@20		;;; 817
	mov	esi,[esp-16]		;;; 1125
	mov	[ebp-80],esi		;;; 884
	mov	esi,[esp-12]		;;; 1125
	mov	[ebp-84],esi		;;; 884
	mov	esi,[esp-8]		;;; 1125
	mov	[ebp-88],esi		;;; 884
	mov	esi,[esp-4]		;;; 1125
	mov	[ebp-92],esi		;;; 884
;
;
; XuiCreateWindow(@g, @"XuiPullDown", x, y, 0, 0, $$WindowTypeTopMost | $$WindowTypeSystemMenu | $$WindowTypeTitleBar, "")
;
; EXTERNAL FUNCTION  XuiCreateWindow            (grid, gridType$, xDisp, yDisp, width, height, winType, display$)
.globl _XuiCreateWindow@32
	mov	eax,-2147483648		;;; 866
	or	eax,67108864		;;; 974
	or	eax,134217728		;;; 974
	mov	[ebp-40],eax		;;; 884
	push	0		;;; 876
	push	[ebp-40]		;;; 891
	push	0		;;; 865
	push	0		;;; 865
	push	[ebp-84]		;;; 891
	push	[ebp-80]		;;; 891
	push	@_string.0069		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiCreateWindow@32		;;; 817
	mov	esi,[esp-32]		;;; 1125
	mov	[ebp-96],esi		;;; 884
;
; XuiSendStringMessage ( g, @"SetCallback", g, &TearOffCallback(), v0, upper, kid, -1)
	mov	eax,func8		;;; 808
	mov	[ebp-40],eax		;;; 884
	mov	eax,1		;;; 868
	neg	eax		;;; 1197
	push	eax		;;; 881
	push	[ebp+12]		;;; 891
	push	[ebp-44]		;;; 891
	push	[ebp+16]		;;; 891
	push	[ebp-40]		;;; 891
	push	[ebp-96]		;;; 891
	push	@_string.006D		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; XuiSendStringMessage ( g, @"SetWindowTitle", 0, 0, 0, 0, 0, @"Tearoff")
	push	@_string.006F		;;; 852
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.006E		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; XuiSendStringMessage ( g, @"SetGridName", 0, 0, 0, 0, 0, @"Tearoff")
	push	@_string.006F		;;; 852
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.0070		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; XuiSendStringMessage ( g, @"SetTextArray", 0,0,0,0, 0, @text$[])
	push	[ebp-48]		;;; 891
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.0071		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
	mov	esi,[esp-4]		;;; 1125
	mov	[ebp-48],esi		;;; 884
;
; XuiSendStringMessage(g, @"SetBorder", $$BorderNone, $$BorderNone, $$BorderNone, $$BorderNone,0,0)
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.0072		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; XuiSendStringMessage(g, @"SetFontNumber", font, 0,0,0,0,0)
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	[ebp-52]		;;; 891
	push	@_string.0074		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; XuiSendStringMessage(g, @"GetGridType", @gridType,0,0,0,0,0)
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	[ebp-100]		;;; 891
	push	@_string.0075		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
	mov	esi,[esp-24]		;;; 1125
	mov	[ebp-100],esi		;;; 884
;
; XuiSetGridTypeProperty (gridType, @"can",              $$Respond OR $$Callback)
;
; EXTERNAL FUNCTION  XuiSetGridTypeProperty     (gridType, @property$, ANY)
.globl _XuiSetGridTypeProperty@12
	mov	eax,2		;;; 868
	or	eax,4		;;; 974
	push	eax		;;; 881
	push	@_string.0077		;;; 852
	push	[ebp-100]		;;; 891
	call	_XuiSetGridTypeProperty@12		;;; 817
;
; XuiSendStringMessage ( g, @"DisplayWindow", 0, 0, 0, 0, 0, 0)
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.0045		;;; 852
	push	[ebp-96]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; XgrGetGridWindow(g, @window)
	push	[ebp-76]		;;; 891
	push	[ebp-96]		;;; 891
	call	_XgrGetGridWindow@8		;;; 817
	mov	esi,[esp-4]		;;; 1125
	mov	[ebp-76],esi		;;; 884
;
; XgrGetWindowPositionAndSize(window, 0, 0, @w, 0)
	push	0		;;; 865
	push	[ebp-88]		;;; 891
	push	0		;;; 865
	push	0		;;; 865
	push	[ebp-76]		;;; 891
	call	_XgrGetWindowPositionAndSize@20		;;; 817
	mov	esi,[esp-8]		;;; 1125
	mov	[ebp-88],esi		;;; 884
;
; XgrGetGridPositionAndSize(g, @x, @y, 0, @h)
;
; EXTERNAL FUNCTION  XgrGetGridPositionAndSize    (grid, @x, @y, @width, @height)
.globl _XgrGetGridPositionAndSize@20
	push	[ebp-92]		;;; 891
	push	0		;;; 865
	push	[ebp-84]		;;; 891
	push	[ebp-80]		;;; 891
	push	[ebp-96]		;;; 891
	call	_XgrGetGridPositionAndSize@20		;;; 817
	mov	esi,[esp-16]		;;; 1125
	mov	[ebp-80],esi		;;; 884
	mov	esi,[esp-12]		;;; 1125
	mov	[ebp-84],esi		;;; 884
	mov	esi,[esp-4]		;;; 1125
	mov	[ebp-92],esi		;;; 884
;
; XgrSetGridPositionAndSize(g, x, y, w, h)
;
; EXTERNAL FUNCTION  XgrSetGridPositionAndSize    (grid, x, y, width, height)
.globl _XgrSetGridPositionAndSize@20
	push	[ebp-92]		;;; 891
	push	[ebp-88]		;;; 891
	push	[ebp-84]		;;; 891
	push	[ebp-80]		;;; 891
	push	[ebp-96]		;;; 891
	call	_XgrSetGridPositionAndSize@20		;;; 817
;
;
; Tearoffs[upper].grid = g
	mov	eax,[ebp-44]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	ebx,[ebp-96]		;;; 875
	mov	[eax],ebx		;;; 19
;
; Tearoffs[upper].parent = grid
	mov	eax,[ebp-44]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	ebx,[ebp-24]		;;; 875
	mov	[eax+4],ebx		;;; 19
;
; Tearoffs[upper].v0 = v0
	mov	eax,[ebp-44]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	ebx,[ebp+16]		;;; 875
	mov	[eax+8],ebx		;;; 19
;
; Tearoffs[upper].wingrid = wingrid
	mov	eax,[ebp-44]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	ebx,[ebp+8]		;;; 875
	mov	[eax+12],ebx		;;; 19
;
; Tearoffs[upper].callback = callback
	mov	eax,[ebp-44]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	ebx,[ebp-72]		;;; 875
	mov	[eax+16],ebx		;;; 19
;
;
; RETURN $$TRUE
	mov	eax,-1		;;; 868
	jmp	end.func2		;;; 313
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func2:
	mov	esi,[ebp-48]		;;; 875
	call	%_FreeArray		;;; 533
	xor	edx,edx		;;; 534
	mov	[ebp-48],edx		;;; 884
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret	12		;;; 105
;
;
; FUNCTION TearOffCallback(grid, message, v0, v1, v2, v3, kid, r1)
.text
TearOffCallback@32:
;
;  *****
;  *****  FUNCTION  TearOffCallback ()  *****
;  *****
func8:
	push	ebp		;;; 110
	mov	ebp,esp		;;; 111
	sub	esp,256		;;; 112
	mov	[ebp-12],esi		;;; 113
	mov	[ebp-16],edi		;;; 114
	mov	[ebp-20],ebx		;;; 115
	cld			;;; 117
	lea	edi,[ebp-56]		;;; 118
	mov	ecx,9		;;; 119
	xor	eax,eax		;;; 120
	rep			;;; 121
	stosd			;;; 122
	mov	esi,20		;;; 123
	call	%____calloc		;;; 124
	mov	[ebp-24],esi		;;; 884
	lea	edi,[esi]		;;; 125
	mov	[ebp-28],edi		;;; 884
;
funcBody8:
;
; SHARED TEAROFF Tearoffs[]
;
; TEAROFF temp
;
;
; FOR i = 0 TO UBOUND(Tearoffs[])
	mov	eax,0		;;; 868
	mov	[ebp-32],eax		;;; 884
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%0016		;;; 794
	mov	eax,[eax-8]		;;; 795
%0016:
	dec	eax		;;; 792
	mov	[ebp-36],eax		;;; 884
for.0007:
	mov	eax,[ebp-32]		;;; 875
	mov	ebx,[ebp-36]		;;; 875
	cmp	eax,ebx		;;; 194
	jg	end.for.0007		;;; 195
;
; IF(Tearoffs[i].grid == grid) THEN
	mov	eax,[ebp-32]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	eax,[eax]		;;; 421
	mov	ebx,[ebp+8]		;;; 875
	cmp	eax,ebx		;;; 902
	jne	else.0008		;;; 268
;
; temp = Tearoffs[i]
	mov	eax,[ebp-32]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	ebx,[ebp-28]		;;; 875
	mov	edi,ebx		;;; 20
	mov	esi,eax		;;; 10
	mov	ecx,20		;;; 1
	call	%_AssignComposite		;;; 2
;
; EXIT FOR
	jmp	end.for.0007		;;; 165
;
; END IF
else.0008:
end.if.0008:
;
; NEXT i
do.next.0007:
	inc	[ebp-32]		;;; 278
	jmp	for.0007		;;; 280
end.for.0007:
;
;
; IF(message == #Callback) THEN message = r1
	mov	eax,[ebp+12]		;;; 875
	mov	ebx,[%#Callback]		;;; 873
	cmp	eax,ebx		;;; 902
	jne	else.0009		;;; 268
	mov	eax,[ebp+36]		;;; 875
	mov	[ebp+12],eax		;;; 884
else.0009:
end.if.0009:
;
;
; SELECT CASE message
	mov	eax,[ebp+12]		;;; 875
	mov	[ebp-40],eax		;;; 884
;
; CASE #Selection:
	mov	eax,[%#Selection]		;;; 873
	mov	ebx,[ebp-40]		;;; 875
	cmp	eax,ebx		;;; 902
	jne	case.000A.0001		;;; 52
;
; IF(v0 == 0) THEN RETURN
	mov	eax,[ebp+16]		;;; 875
	cmp	eax,0		;;; 902
	jne	else.000B		;;; 268
	xor	eax,eax		;;; 1108
	jmp	end.func8		;;; 313
else.000B:
end.if.000B:
;
; @temp.callback(temp.wingrid, #Callback, v2, v0, 0, 0, kid, #Selection)
	mov	eax,[ebp-28]		;;; 875
	mov	eax,[eax+16]		;;; 421
	xor	edx,edx		;;; 810
	or	eax,eax		;;; 811
	jz	%0018		;;; 812
	mov	[ebp-48],eax		;;; 884
	mov	eax,[ebp-28]		;;; 875
	mov	eax,[eax+12]		;;; 421
	mov	[ebp-56],eax		;;; 884
	push	[%#Selection]		;;; 888
	push	[ebp+32]		;;; 891
	push	0		;;; 865
	push	0		;;; 865
	push	[ebp+16]		;;; 891
	push	[ebp+24]		;;; 891
	push	[%#Callback]		;;; 888
	push	[ebp-56]		;;; 891
	mov	eax,[ebp-48]		;;; 875
	call	eax		;;; 818
%0018:
;
; CASE #CloseWindow:
	jmp	end.select.000A		;;; 50
case.000A.0001:
	mov	eax,[%#CloseWindow]		;;; 873
	mov	ebx,[ebp-40]		;;; 875
	cmp	eax,ebx		;;; 902
	jne	case.000A.0002		;;; 52
;
; CloseTearoff(temp.grid)
	mov	eax,[ebp-28]		;;; 875
	mov	eax,[eax]		;;; 421
	push	eax		;;; 881
	call	func4		;;; 817
;
; END SELECT
case.000A.0002:
end.select.000A:
;
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func8:
	mov	esi,[ebp-24]		;;; 875
	call	%____free		;;; 531
	xor	edx,edx		;;; 532
	mov	[ebp-24],edx		;;; 884
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret	32		;;; 105
;
;
; FUNCTION CloseTearoff(grid)
.text
_CloseTearoff@4:
;
;  *****
;  *****  FUNCTION  CloseTearoff ()  *****
;  *****
func4:
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
funcBody4:
;
; SHARED TEAROFF Tearoffs[]
;
;
; XuiSendStringMessage(grid, @"DestroyWindow", 0,0,0,0,0, 0)
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	0		;;; 865
	push	@_string.004D		;;; 852
	push	[ebp+8]		;;; 891
	call	_XuiSendStringMessage@32		;;; 817
;
; upper = UBOUND(Tearoffs[])
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%001B		;;; 794
	mov	eax,[eax-8]		;;; 795
%001B:
	dec	eax		;;; 792
	mov	[ebp-24],eax		;;; 884
;
; IF(v3 == upper) THEN
	mov	eax,[ebp-28]		;;; 875
	mov	ebx,[ebp-24]		;;; 875
	cmp	eax,ebx		;;; 902
	jne	else.000C		;;; 268
;
; REDIM Tearoffs[upper - 1]
	sub	esp,64		;;; 536
	mov	eax,[ebp-24]		;;; 875
	sub	eax,1		;;; 1001
	mov	[esp+16],eax		;;; 540
	mov	esi,[%%%Tearoffs]		;;; 873
	mov	[esp],esi		;;; 541
	mov	[esp+4],1		;;; 542
	mov	[esp+8],-1071251436		;;; 543
	mov	[esp+12],0		;;; 544
	call	%_RedimArray		;;; 545
	add	esp,64		;;; 546
	mov	[%%%Tearoffs],eax		;;; 882
;
; RETURN
	xor	eax,eax		;;; 1108
	jmp	end.func4		;;; 313
;
; END IF
else.000C:
end.if.000C:
;
;
; FOR i = 0 TO UBOUND(Tearoffs[])
	mov	eax,0		;;; 868
	mov	[ebp-32],eax		;;; 884
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%001C		;;; 794
	mov	eax,[eax-8]		;;; 795
%001C:
	dec	eax		;;; 792
	mov	[ebp-36],eax		;;; 884
for.000D:
	mov	eax,[ebp-32]		;;; 875
	mov	ebx,[ebp-36]		;;; 875
	cmp	eax,ebx		;;; 194
	jg	end.for.000D		;;; 195
;
; IF(Tearoffs[i].grid == grid) THEN
	mov	eax,[ebp-32]		;;; 875
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	eax,[eax]		;;; 421
	mov	ebx,[ebp+8]		;;; 875
	cmp	eax,ebx		;;; 902
	jne	else.000E		;;; 268
;
; FOR z = i TO UBOUND(Tearoffs[]) - 1
	mov	eax,[ebp-32]		;;; 875
	mov	[ebp-40],eax		;;; 884
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%001D		;;; 794
	mov	eax,[eax-8]		;;; 795
%001D:
	dec	eax		;;; 792
	sub	eax,1		;;; 1001
	mov	[ebp-44],eax		;;; 884
for.000F:
	mov	eax,[ebp-40]		;;; 875
	mov	ebx,[ebp-44]		;;; 875
	cmp	eax,ebx		;;; 194
	jg	end.for.000F		;;; 195
;
; Tearoffs[z] = Tearoffs[z + 1]
	mov	eax,[ebp-40]		;;; 875
	add	eax,1		;;; 986
	mov	edx,[%%%Tearoffs]		;;; 873
	imul	eax,20		;;; 584
	lea	eax,[edx+eax]		;;; 581
	mov	ebx,[ebp-40]		;;; 875
	mov	ecx,[%%%Tearoffs]		;;; 873
	imul	ebx,20		;;; 584
	lea	ebx,[ecx+ebx]		;;; 581
	mov	edi,ebx		;;; 20
	mov	esi,eax		;;; 10
	mov	ecx,20		;;; 1
	call	%_AssignComposite		;;; 2
;
; NEXT z
do.next.000F:
	inc	[ebp-40]		;;; 278
	jmp	for.000F		;;; 280
end.for.000F:
;
; REDIM Tearoffs[UBOUND(Tearoffs[]) - 1]
	sub	esp,64		;;; 536
	mov	eax,[%%%Tearoffs]		;;; 873
	or	eax,eax		;;; 793
	jz	%001F		;;; 794
	mov	eax,[eax-8]		;;; 795
%001F:
	dec	eax		;;; 792
	sub	eax,1		;;; 1001
	mov	[esp+16],eax		;;; 540
	mov	esi,[%%%Tearoffs]		;;; 873
	mov	[esp],esi		;;; 541
	mov	[esp+4],1		;;; 542
	mov	[esp+8],-1071251436		;;; 543
	mov	[esp+12],0		;;; 544
	call	%_RedimArray		;;; 545
	add	esp,64		;;; 546
	mov	[%%%Tearoffs],eax		;;; 882
;
; RETURN
	xor	eax,eax		;;; 1108
	jmp	end.func4		;;; 313
;
; END IF
else.000E:
end.if.000E:
;
; NEXT i
do.next.000D:
	inc	[ebp-32]		;;; 278
	jmp	for.000D		;;; 280
end.for.000D:
;
;
; END FUNCTION
	xor	eax,eax		;;; 1108
;;
end.func4:
	mov	esi,[ebp-12]		;;; 100
	mov	edi,[ebp-16]		;;; 101
	mov	ebx,[ebp-20]		;;; 102
	mov	esp,ebp		;;; 103
	pop	ebp		;;; 104
	ret	4		;;; 105
;
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
	mov	esi,[%%%Tearoffs]		;;; 873
	call	%_FreeArray		;;; 533
	xor	edx,edx		;;; 534
	mov	[%%%Tearoffs],edx		;;; 882
	mov	esi,[%%%Tearoffs]		;;; 873
	call	%_FreeArray		;;; 533
	xor	edx,edx		;;; 534
	mov	[%%%Tearoffs],edx		;;; 882
	mov	esi,[%%%Tearoffs]		;;; 873
	call	%_FreeArray		;;; 533
	xor	edx,edx		;;; 534
	mov	[%%%Tearoffs],edx		;;; 882
	mov	esi,[%%%Tearoffs]		;;; 873
	call	%_FreeArray		;;; 533
	xor	edx,edx		;;; 534
	mov	[%%%Tearoffs],edx		;;; 882
	mov	esi,[%%%Tearoffs]		;;; 873
	call	%_FreeArray		;;; 533
	xor	edx,edx		;;; 534
	mov	[%%%Tearoffs],edx		;;; 882
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
.dword	32, 0, 7, 0x80130001
@_string.0029:
.byte	"tearoff"
.zero	9
.dword	32, 0, 3, 0x80130001
@_string.002A:
.byte	"0.1"
.zero	13
.dword	32, 0, 3, 0x80130001
@_string.002B:
.byte	"xst"
.zero	13
.dword	32, 0, 3, 0x80130001
@_string.002C:
.byte	"xgr"
.zero	13
.dword	32, 0, 3, 0x80130001
@_string.002D:
.byte	"xui"
.zero	13
.dword	32, 0, 9, 0x80130001
@_string.003D:
.byte	"Selection"
.zero	7
.dword	32, 0, 8, 0x80130001
@_string.003F:
.byte	"Callback"
.zero	8
.dword	32, 0, 11, 0x80130001
@_string.0041:
.byte	"CloseWindow"
.zero	5
.dword	32, 0, 13, 0x80130001
@_string.0045:
.byte	"DisplayWindow"
.zero	3
.dword	32, 0, 10, 0x80130001
@_string.0047:
.byte	"HideWindow"
.zero	6
.dword	32, 0, 13, 0x80130001
@_string.004D:
.byte	"DestroyWindow"
.zero	3
.dword	32, 0, 13, 0x80130001
@_string.0052:
.byte	"GetGridNumber"
.zero	3
.dword	32, 0, 12, 0x80130001
@_string.0057:
.byte	"GetTextArray"
.zero	4
.dword	32, 0, 13, 0x80130001
@_string.0059:
.byte	"GetFontNumber"
.zero	3
.dword	32, 0, 1, 0x80130001
@_string.005C:
.byte	"_"
.zero	15
.dword	32, 0, 11, 0x80130001
@_string.0060:
.byte	"GetCallback"
.zero	5
.dword	32, 0, 11, 0x80130001
@_string.0069:
.byte	"XuiPullDown"
.zero	5
.dword	32, 0, 11, 0x80130001
@_string.006D:
.byte	"SetCallback"
.zero	5
.dword	32, 0, 14, 0x80130001
@_string.006E:
.byte	"SetWindowTitle"
.zero	2
.dword	32, 0, 7, 0x80130001
@_string.006F:
.byte	"Tearoff"
.zero	9
.dword	32, 0, 11, 0x80130001
@_string.0070:
.byte	"SetGridName"
.zero	5
.dword	32, 0, 12, 0x80130001
@_string.0071:
.byte	"SetTextArray"
.zero	4
.dword	32, 0, 9, 0x80130001
@_string.0072:
.byte	"SetBorder"
.zero	7
.dword	32, 0, 13, 0x80130001
@_string.0074:
.byte	"SetFontNumber"
.zero	3
.dword	32, 0, 11, 0x80130001
@_string.0075:
.byte	"GetGridType"
.zero	5
.dword	32, 0, 3, 0x80130001
@_string.0077:
.byte	"can"
.zero	13
.dword	32, 0, 1, 0x80130001
@_string.00C2:
.byte	"\012"
.zero	15
.dword	32, 0, 1, 0x80130001
@_string.00C4:
.byte	"\134"
.zero	15
.dword	32, 0, 1, 0x80130001
@_string.00CA:
.byte	";"
.zero	15
.dword	32, 0, 5, 0x80130001
@_string.Entry:
.byte	"Entry"
.zero	11
.dword	32, 0, 15, 0x80130001
@_string.StartLibrary:
.byte	"%_StartLibrary_"
.zero	1
