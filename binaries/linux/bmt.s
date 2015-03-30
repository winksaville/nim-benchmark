	.file	"bmt.c"
# GNU C (Ubuntu 4.9.1-16ubuntu6) version 4.9.1 (x86_64-linux-gnu)
#	compiled by GNU C version 4.9.1, GMP version 6.0.0, MPFR version 3.1.2-p3, MPC version 1.0.2
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  -I /opt/nim/lib -imultiarch x86_64-linux-gnu bmt.c
# -mtune=generic -march=x86-64 -auxbase-strip bmt.s -O3 -w -fverbose-asm
# -fstack-protector-strong -Wformat -Wformat-security
# options enabled:  -faggressive-loop-optimizations
# -fasynchronous-unwind-tables -fauto-inc-dec -fbranch-count-reg
# -fcaller-saves -fcombine-stack-adjustments -fcommon -fcompare-elim
# -fcprop-registers -fcrossjumping -fcse-follow-jumps -fdefer-pop
# -fdelete-null-pointer-checks -fdevirtualize -fdevirtualize-speculatively
# -fdwarf2-cfi-asm -fearly-inlining -feliminate-unused-debug-types
# -fexpensive-optimizations -fforward-propagate -ffunction-cse -fgcse
# -fgcse-after-reload -fgcse-lm -fgnu-runtime -fgnu-unique
# -fguess-branch-probability -fhoist-adjacent-loads -fident -fif-conversion
# -fif-conversion2 -findirect-inlining -finline -finline-atomics
# -finline-functions -finline-functions-called-once
# -finline-small-functions -fipa-cp -fipa-cp-clone -fipa-profile
# -fipa-pure-const -fipa-reference -fipa-sra -fira-hoist-pressure
# -fira-share-save-slots -fira-share-spill-slots
# -fisolate-erroneous-paths-dereference -fivopts -fkeep-static-consts
# -fleading-underscore -fmath-errno -fmerge-constants -fmerge-debug-strings
# -fmove-loop-invariants -fomit-frame-pointer -foptimize-sibling-calls
# -foptimize-strlen -fpartial-inlining -fpeephole -fpeephole2
# -fpredictive-commoning -fprefetch-loop-arrays -free -freg-struct-return
# -freorder-blocks -freorder-blocks-and-partition -freorder-functions
# -frerun-cse-after-loop -fsched-critical-path-heuristic
# -fsched-dep-count-heuristic -fsched-group-heuristic -fsched-interblock
# -fsched-last-insn-heuristic -fsched-rank-heuristic -fsched-spec
# -fsched-spec-insn-heuristic -fsched-stalled-insns-dep -fschedule-insns2
# -fshow-column -fshrink-wrap -fsigned-zeros -fsplit-ivs-in-unroller
# -fsplit-wide-types -fstack-protector-strong -fstrict-aliasing
# -fstrict-overflow -fstrict-volatile-bitfields -fsync-libcalls
# -fthread-jumps -ftoplevel-reorder -ftrapping-math -ftree-bit-ccp
# -ftree-builtin-call-dce -ftree-ccp -ftree-ch -ftree-coalesce-vars
# -ftree-copy-prop -ftree-copyrename -ftree-cselim -ftree-dce
# -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre
# -ftree-loop-distribute-patterns -ftree-loop-if-convert -ftree-loop-im
# -ftree-loop-ivcanon -ftree-loop-optimize -ftree-loop-vectorize
# -ftree-parallelize-loops= -ftree-partial-pre -ftree-phiprop -ftree-pre
# -ftree-pta -ftree-reassoc -ftree-scev-cprop -ftree-sink
# -ftree-slp-vectorize -ftree-slsr -ftree-sra -ftree-switch-conversion
# -ftree-tail-merge -ftree-ter -ftree-vrp -funit-at-a-time -funswitch-loops
# -funwind-tables -fverbose-asm -fzero-initialized-in-bss
# -m128bit-long-double -m64 -m80387 -malign-stringops
# -mavx256-split-unaligned-load -mavx256-split-unaligned-store
# -mfancy-math-387 -mfp-ret-in-387 -mfxsr -mglibc -mieee-fp
# -mlong-double-80 -mmmx -mno-sse4 -mpush-args -mred-zone -msse -msse2
# -mtls-direct-seg-refs -mvzeroupper

	.section	.text.unlikely,"ax",@progbits
.LCOLDB0:
	.text
.LHOTB0:
	.p2align 4,,15
	.globl	PreMainInner
	.type	PreMainInner, @function
PreMainInner:
.LFB88:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
	call	systemInit	#
	call	HEX00_algorithmDatInit	#
	call	HEX00_parseutilsDatInit	#
	call	HEX00_strutilsDatInit	#
	call	HEX00_timesDatInit	#
	call	HEX00_mathDatInit	#
	call	HEX00_posixDatInit	#
	call	HEX00_osDatInit	#
	call	HEX00_algorithmInit	#
	call	HEX00_parseutilsInit	#
	call	HEX00_strutilsInit	#
	call	HEX00_timesInit	#
	call	HEX00_mathInit	#
	call	HEX00_posixInit	#
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	jmp	HEX00_osInit	#
	.cfi_endproc
.LFE88:
	.size	PreMainInner, .-PreMainInner
	.section	.text.unlikely
.LCOLDE0:
	.text
.LHOTE0:
	.section	.text.unlikely
.LCOLDB2:
	.text
.LHOTB2:
	.p2align 4,,15
	.globl	cps_139240
	.type	cps_139240, @function
cps_139240:
.LFB66:
	.cfi_startproc
	pushq	%r14	#
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13	#
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12	#
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp	#
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx	#
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp	#,
	.cfi_def_cfa_offset 64
	movsd	%xmm0, 8(%rsp)	# seconds, %sfp
	call	ntepochTime	#
	movsd	8(%rsp), %xmm2	# %sfp, endtime
	addsd	%xmm0, %xmm2	# LOC1, endtime
	movsd	%xmm2, (%rsp)	# endtime, %sfp
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 156 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	movl	%ecx, %ebp	# aux, aux
	movl	%edx, %r13d	# hi, hi
	movl	%eax, %r12d	# lo,
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	xorl	%r14d, %r14d	# ec
	jmp	.L4	#
	.p2align 4,,10
	.p2align 3
.L14:
#APP
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	salq	$32, %rdx	#, D.4292
	movl	%eax, %esi	# lo, D.4290
	movl	%ecx, %edi	# aux, aux
	orq	%rsi, %rdx	# D.4290, ec
	movq	%rdx, %r14	# ec, ec
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	cmpl	%ebp, %edi	# aux, aux
	jne	.L13	#,
.L4:
	call	ntepochTime	#
	movsd	(%rsp), %xmm1	# %sfp, endtime
	ucomisd	%xmm0, %xmm1	# LOC4, endtime
	jae	.L14	#,
.L7:
	salq	$32, %r13	#, D.4292
	pxor	%xmm0, %xmm0	# D.4291
	orq	%r12, %r13	# D.4290, start
	movq	%r14, %rsi	# ec, D.4290
	subq	%r13, %rsi	# start, D.4290
	cvtsi2sdq	%rsi, %xmm0	# D.4290, D.4291
	divsd	8(%rsp), %xmm0	# %sfp, result
	addq	$16, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx	#
	.cfi_def_cfa_offset 40
	popq	%rbp	#
	.cfi_def_cfa_offset 32
	popq	%r12	#
	.cfi_def_cfa_offset 24
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	.cfi_restore_state
	movsd	.LC1(%rip), %xmm0	#, result
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 48
	popq	%rbx	#
	.cfi_def_cfa_offset 40
	popq	%rbp	#
	.cfi_def_cfa_offset 32
	popq	%r12	#
	.cfi_def_cfa_offset 24
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE66:
	.size	cps_139240, .-cps_139240
	.section	.text.unlikely
.LCOLDE2:
	.text
.LHOTE2:
	.section	.text.unlikely
.LCOLDB4:
	.text
.LHOTB4:
	.p2align 4,,15
	.globl	cyclespersecond_139027
	.type	cyclespersecond_139027, @function
cyclespersecond_139027:
.LFB67:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	$3, %r13d	#, D.4342
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 80
	movsd	%xmm0, 8(%rsp)	# seconds, %sfp
.L21:
	call	ntepochTime	#
	addsd	8(%rsp), %xmm0	# %sfp, endtime
	movsd	%xmm0, (%rsp)	# endtime, %sfp
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 156 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	movl	%ecx, %ebp	# aux, aux
	movl	%edx, %r14d	# hi, hi
	movl	%eax, %r12d	# lo,
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	xorl	%r15d, %r15d	# ec
	jmp	.L16	#
	.p2align 4,,10
	.p2align 3
.L28:
#APP
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	salq	$32, %rdx	#, D.4344
	movl	%eax, %esi	# lo, D.4343
	movl	%ecx, %edi	# aux, aux
	orq	%rsi, %rdx	# D.4343, ec
	movq	%rdx, %r15	# ec, ec
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	cmpl	%ebp, %edi	# aux, aux
	jne	.L19	#,
.L16:
	call	ntepochTime	#
	movsd	(%rsp), %xmm1	# %sfp, endtime
	ucomisd	%xmm0, %xmm1	# LOC4, endtime
	jae	.L28	#,
	salq	$32, %r14	#, D.4344
	pxor	%xmm0, %xmm0	# D.4345
	orq	%r12, %r14	# D.4343, start
	movq	%r15, %rsi	# ec, D.4343
	subq	%r14, %rsi	# start, D.4343
	pxor	%xmm4, %xmm4	# tmp148
	cvtsi2sdq	%rsi, %xmm0	# D.4343, D.4345
	divsd	8(%rsp), %xmm0	# %sfp, result
	ucomisd	%xmm4, %xmm0	# tmp148, result
	ja	.L22	#,
.L19:
	subq	$1, %r13	#, D.4342
	jne	.L21	#,
	movsd	.LC1(%rip), %xmm0	#, result
.L20:
.L22:
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE67:
	.size	cyclespersecond_139027, .-cyclespersecond_139027
	.section	.text.unlikely
.LCOLDE4:
	.text
.LHOTE4:
	.section	.text.unlikely
.LCOLDB5:
	.text
.LHOTB5:
	.p2align 4,,15
	.globl	HEX24_139100
	.type	HEX24_139100, @function
HEX24_139100:
.LFB85:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx	# r, r
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 64
	movq	(%rdi), %rdi	# r_2(D)->N,
	call	nimIntToStr	#
	movsd	8(%rbx), %xmm0	# r_2(D)->Sum,
	movq	%rax, %r15	#, LOC2
	call	nimFloatToStr	#
	movsd	16(%rbx), %xmm0	# r_2(D)->Min,
	movq	%rax, %r14	#, LOC3
	call	nimFloatToStr	#
	movsd	24(%rbx), %xmm0	# r_2(D)->Max,
	movq	%rax, %r13	#, LOC4
	call	nimFloatToStr	#
	movsd	32(%rbx), %xmm0	# r_2(D)->Mean, r_2(D)->Mean
	movq	%rax, %r12	#, LOC5
	call	nimFloatToStr	#
	movq	(%r14), %rdi	# LOC3_8->Sup.len, LOC3_8->Sup.len
	addq	(%r15), %rdi	# LOC2_5->Sup.len, D.4382
	movq	%rax, %rbp	#, LOC6
	addq	0(%r13), %rdi	# LOC4_11->Sup.len, D.4382
	addq	(%r12), %rdi	# LOC5_14->Sup.len, D.4382
	addq	(%rax), %rdi	# LOC6_17->Sup.len, D.4382
	addq	$25, %rdi	#, D.4382
	call	rawNewString	#
	movl	TMP52+16(%rip), %edx	# MEM[(void *)&TMP52 + 16B], MEM[(void *)&TMP52 + 16B]
	movq	%rax, %rbx	#, result
	movq	(%rax), %rax	# result_29->Sup.len, result_29->Sup.len
	leaq	16(%r15), %rsi	#, tmp189
	movl	%edx, 16(%rbx,%rax)	# MEM[(void *)&TMP52 + 16B], MEM[(void *)result_29]
	movq	(%rbx), %rax	# result_29->Sup.len, result_29->Sup.len
	leaq	3(%rax), %rdx	#, D.4382
	leaq	19(%rbx,%rax), %rdi	#, tmp186
	movq	%rdx, (%rbx)	# D.4382, result_29->Sup.len
	movq	(%r15), %rax	# LOC2_5->Sup.len, tmp275
	leaq	1(%rax), %rdx	#, D.4382
	call	memcpy	#
	movq	(%r15), %rax	# LOC2_5->Sup.len, LOC2_5->Sup.len
	addq	(%rbx), %rax	# result_29->Sup.len, D.4382
	leaq	16(%r14), %rsi	#, tmp207
	movl	TMP53+16(%rip), %edx	# MEM[(void *)&TMP53 + 16B], MEM[(void *)&TMP53 + 16B]
	movq	%rax, (%rbx)	# D.4382, result_29->Sup.len
	leaq	16(%rbx,%rax), %rax	#, tmp198
	movl	%edx, (%rax)	# MEM[(void *)&TMP53 + 16B], MEM[(void *)result_29]
	movzwl	TMP53+20(%rip), %edx	# MEM[(void *)&TMP53 + 16B], MEM[(void *)&TMP53 + 16B]
	movw	%dx, 4(%rax)	# MEM[(void *)&TMP53 + 16B], MEM[(void *)result_29]
	movq	(%rbx), %rax	# result_29->Sup.len, result_29->Sup.len
	leaq	5(%rax), %rdx	#, D.4382
	leaq	21(%rbx,%rax), %rdi	#, tmp204
	movq	%rdx, (%rbx)	# D.4382, result_29->Sup.len
	movq	(%r14), %rax	# LOC3_8->Sup.len, tmp276
	leaq	1(%rax), %rdx	#, D.4382
	call	memcpy	#
	movq	(%r14), %rax	# LOC3_8->Sup.len, LOC3_8->Sup.len
	addq	(%rbx), %rax	# result_29->Sup.len, D.4382
	leaq	16(%r13), %rsi	#, tmp225
	movl	TMP54+16(%rip), %edx	# MEM[(void *)&TMP54 + 16B], MEM[(void *)&TMP54 + 16B]
	movq	%rax, (%rbx)	# D.4382, result_29->Sup.len
	leaq	16(%rbx,%rax), %rax	#, tmp216
	movl	%edx, (%rax)	# MEM[(void *)&TMP54 + 16B], MEM[(void *)result_29]
	movzwl	TMP54+20(%rip), %edx	# MEM[(void *)&TMP54 + 16B], MEM[(void *)&TMP54 + 16B]
	movw	%dx, 4(%rax)	# MEM[(void *)&TMP54 + 16B], MEM[(void *)result_29]
	movq	(%rbx), %rax	# result_29->Sup.len, result_29->Sup.len
	leaq	5(%rax), %rdx	#, D.4382
	leaq	21(%rbx,%rax), %rdi	#, tmp222
	movq	%rdx, (%rbx)	# D.4382, result_29->Sup.len
	movq	0(%r13), %rax	# LOC4_11->Sup.len, tmp277
	leaq	1(%rax), %rdx	#, D.4382
	call	memcpy	#
	movq	0(%r13), %rax	# LOC4_11->Sup.len, LOC4_11->Sup.len
	addq	(%rbx), %rax	# result_29->Sup.len, D.4382
	leaq	16(%r12), %rsi	#, tmp243
	movl	TMP55+16(%rip), %edx	# MEM[(void *)&TMP55 + 16B], MEM[(void *)&TMP55 + 16B]
	movq	%rax, (%rbx)	# D.4382, result_29->Sup.len
	leaq	16(%rbx,%rax), %rax	#, tmp234
	movl	%edx, (%rax)	# MEM[(void *)&TMP55 + 16B], MEM[(void *)result_29]
	movzwl	TMP55+20(%rip), %edx	# MEM[(void *)&TMP55 + 16B], MEM[(void *)&TMP55 + 16B]
	movw	%dx, 4(%rax)	# MEM[(void *)&TMP55 + 16B], MEM[(void *)result_29]
	movq	(%rbx), %rax	# result_29->Sup.len, result_29->Sup.len
	leaq	5(%rax), %rdx	#, D.4382
	leaq	21(%rbx,%rax), %rdi	#, tmp240
	movq	%rdx, (%rbx)	# D.4382, result_29->Sup.len
	movq	(%r12), %rax	# LOC5_14->Sup.len, tmp278
	leaq	1(%rax), %rdx	#, D.4382
	call	memcpy	#
	movq	(%r12), %rax	# LOC5_14->Sup.len, LOC5_14->Sup.len
	addq	(%rbx), %rax	# result_29->Sup.len, D.4382
	leaq	16(%rbp), %rsi	#, tmp262
	movl	TMP56+16(%rip), %edx	# MEM[(void *)&TMP56 + 16B], MEM[(void *)&TMP56 + 16B]
	movq	%rax, (%rbx)	# D.4382, result_29->Sup.len
	leaq	16(%rbx,%rax), %rax	#, tmp252
	movl	%edx, (%rax)	# MEM[(void *)&TMP56 + 16B], MEM[(void *)result_29]
	movzwl	TMP56+20(%rip), %edx	# MEM[(void *)&TMP56 + 16B], MEM[(void *)&TMP56 + 16B]
	movw	%dx, 4(%rax)	# MEM[(void *)&TMP56 + 16B], MEM[(void *)result_29]
	movzbl	TMP56+22(%rip), %edx	# MEM[(void *)&TMP56 + 16B], MEM[(void *)&TMP56 + 16B]
	movb	%dl, 6(%rax)	# MEM[(void *)&TMP56 + 16B], MEM[(void *)result_29]
	movq	(%rbx), %rax	# result_29->Sup.len, result_29->Sup.len
	leaq	6(%rax), %rdx	#, D.4382
	leaq	22(%rbx,%rax), %rdi	#, tmp259
	movq	%rdx, (%rbx)	# D.4382, result_29->Sup.len
	movq	0(%rbp), %rax	# LOC6_17->Sup.len, tmp279
	leaq	1(%rax), %rdx	#, D.4382
	call	memcpy	#
	movq	0(%rbp), %rax	# LOC6_17->Sup.len, LOC6_17->Sup.len
	movzwl	TMP57+16(%rip), %edx	# MEM[(void *)&TMP57 + 16B], MEM[(void *)&TMP57 + 16B]
	addq	(%rbx), %rax	# result_29->Sup.len, D.4382
	movq	%rax, (%rbx)	# D.4382, result_29->Sup.len
	movw	%dx, 16(%rbx,%rax)	# MEM[(void *)&TMP57 + 16B], MEM[(void *)result_29]
	movq	%rbx, %rax	# result,
	addq	$1, (%rbx)	#, result_29->Sup.len
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE85:
	.size	HEX24_139100, .-HEX24_139100
	.section	.text.unlikely
.LCOLDE5:
	.text
.LHOTE5:
	.section	.text.unlikely
.LCOLDB6:
	.text
.LHOTB6:
	.p2align 4,,15
	.globl	bmechoresults_139639
	.type	bmechoresults_139639, @function
bmechoresults_139639:
.LFB86:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rdi, %r14	# runstat, runstat
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdx, %r12	# suitename, suitename
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rcx, %rbp	# runname, runname
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 80
	movsd	%xmm0, (%rsp)	# cyclespersec, %sfp
	movl	%esi, 12(%rsp)	# verbosity, %sfp
	movsd	16(%rdi), %xmm0	# runstat_5(D)->Min,
	call	nimFloatToStr	#
	movsd	16(%r14), %xmm0	# runstat_5(D)->Min, runstat_5(D)->Min
	movq	%rax, %r15	#, LOC2
	divsd	(%rsp), %xmm0	# %sfp, D.4427
	call	nimFloatToStr	#
	movq	(%rax), %r8	# LOC3_13->Sup.len, LOC3_13->Sup.len
	addq	(%r15), %r8	# LOC2_8->Sup.len, D.4428
	movq	%rax, %r13	#, LOC3
	addq	(%r12), %r8	# suitename_17(D)->Sup.len, D.4428
	addq	0(%rbp), %r8	# runname_20(D)->Sup.len, D.4428
	leaq	17(%r8), %rdi	#, D.4428
	call	rawNewString	#
	movq	%rax, %rbx	#, s
	movq	(%rax), %rax	# s_25->Sup.len, s_25->Sup.len
	movq	TMP48+16(%rip), %rdx	# MEM[(void *)&TMP48 + 16B], MEM[(void *)&TMP48 + 16B]
	leaq	16(%r15), %rsi	#, tmp196
	leaq	16(%rbx,%rax), %rax	#, tmp187
	movq	%rdx, (%rax)	# MEM[(void *)&TMP48 + 16B], MEM[(void *)s_25]
	movzbl	TMP48+24(%rip), %edx	# MEM[(void *)&TMP48 + 16B], MEM[(void *)&TMP48 + 16B]
	movb	%dl, 8(%rax)	# MEM[(void *)&TMP48 + 16B], MEM[(void *)s_25]
	movq	(%rbx), %rax	# s_25->Sup.len, s_25->Sup.len
	leaq	8(%rax), %rdx	#, D.4428
	leaq	24(%rbx,%rax), %rdi	#, tmp193
	movq	%rdx, (%rbx)	# D.4428, s_25->Sup.len
	movq	(%r15), %rax	# LOC2_8->Sup.len, tmp292
	leaq	1(%rax), %rdx	#, D.4428
	call	memcpy	#
	movq	(%r15), %rax	# LOC2_8->Sup.len, LOC2_8->Sup.len
	addq	(%rbx), %rax	# s_25->Sup.len, D.4428
	leaq	16(%r13), %rsi	#, tmp215
	movl	TMP49+16(%rip), %edx	# MEM[(void *)&TMP49 + 16B], MEM[(void *)&TMP49 + 16B]
	movq	%rax, (%rbx)	# D.4428, s_25->Sup.len
	leaq	16(%rbx,%rax), %rax	#, tmp205
	movl	%edx, (%rax)	# MEM[(void *)&TMP49 + 16B], MEM[(void *)s_25]
	movzwl	TMP49+20(%rip), %edx	# MEM[(void *)&TMP49 + 16B], MEM[(void *)&TMP49 + 16B]
	movw	%dx, 4(%rax)	# MEM[(void *)&TMP49 + 16B], MEM[(void *)s_25]
	movzbl	TMP49+22(%rip), %edx	# MEM[(void *)&TMP49 + 16B], MEM[(void *)&TMP49 + 16B]
	movb	%dl, 6(%rax)	# MEM[(void *)&TMP49 + 16B], MEM[(void *)s_25]
	movq	(%rbx), %rax	# s_25->Sup.len, s_25->Sup.len
	leaq	6(%rax), %rdx	#, D.4428
	leaq	22(%rbx,%rax), %rdi	#, tmp212
	movq	%rdx, (%rbx)	# D.4428, s_25->Sup.len
	movq	0(%r13), %rax	# LOC3_13->Sup.len, tmp293
	leaq	1(%rax), %rdx	#, D.4428
	call	memcpy	#
	movq	0(%r13), %rax	# LOC3_13->Sup.len, LOC3_13->Sup.len
	addq	(%rbx), %rax	# s_25->Sup.len, D.4428
	leaq	16(%r12), %rsi	#, tmp233
	movzwl	TMP50+16(%rip), %edx	# MEM[(void *)&TMP50 + 16B], MEM[(void *)&TMP50 + 16B]
	movq	%rax, (%rbx)	# D.4428, s_25->Sup.len
	leaq	16(%rbx,%rax), %rax	#, tmp224
	movw	%dx, (%rax)	# MEM[(void *)&TMP50 + 16B], MEM[(void *)s_25]
	movzbl	TMP50+18(%rip), %edx	# MEM[(void *)&TMP50 + 16B], MEM[(void *)&TMP50 + 16B]
	movb	%dl, 2(%rax)	# MEM[(void *)&TMP50 + 16B], MEM[(void *)s_25]
	movq	(%rbx), %rax	# s_25->Sup.len, s_25->Sup.len
	leaq	2(%rax), %rdx	#, D.4428
	leaq	18(%rbx,%rax), %rdi	#, tmp230
	movq	%rdx, (%rbx)	# D.4428, s_25->Sup.len
	movq	(%r12), %rax	# suitename_17(D)->Sup.len, tmp294
	leaq	1(%rax), %rdx	#, D.4428
	call	memcpy	#
	movq	(%r12), %rax	# suitename_17(D)->Sup.len, suitename_17(D)->Sup.len
	movzwl	TMP45+16(%rip), %edx	# MEM[(void *)&TMP45 + 16B], MEM[(void *)&TMP45 + 16B]
	leaq	16(%rbp), %rsi	#, tmp250
	addq	(%rbx), %rax	# s_25->Sup.len, D.4428
	movq	%rax, (%rbx)	# D.4428, s_25->Sup.len
	movw	%dx, 16(%rbx,%rax)	# MEM[(void *)&TMP45 + 16B], MEM[(void *)s_25]
	movq	(%rbx), %rax	# s_25->Sup.len, s_25->Sup.len
	leaq	1(%rax), %rdx	#, D.4428
	leaq	17(%rbx,%rax), %rdi	#, tmp247
	movq	%rdx, (%rbx)	# D.4428, s_25->Sup.len
	movq	0(%rbp), %rax	# runname_20(D)->Sup.len, tmp295
	leaq	1(%rax), %rdx	#, D.4428
	call	memcpy	#
	movl	12(%rsp), %r9d	# %sfp, verbosity
	movq	0(%rbp), %rax	# runname_20(D)->Sup.len, runname_20(D)->Sup.len
	addq	%rax, (%rbx)	# runname_20(D)->Sup.len, s_25->Sup.len
	testl	%r9d, %r9d	# verbosity
	jle	.L32	#,
	movq	%r14, %rdi	# runstat,
	call	HEX24_139100	#
	movq	(%rax), %rdi	# LOC10_36->Sup.len, LOC10_36->Sup.len
	addq	(%rbx), %rdi	# s_25->Sup.len, D.4428
	movq	%rax, %r12	#, LOC10
	addq	$9, %rdi	#, D.4428
	call	rawNewString	#
	movq	%rax, %rbp	#, s
	movq	(%rax), %rax	# s_42->Sup.len, s_42->Sup.len
	leaq	16(%rbx), %rsi	#, tmp265
	leaq	16(%rbp,%rax), %rdi	#, tmp262
	movq	(%rbx), %rax	# s_25->Sup.len, tmp296
	leaq	1(%rax), %rdx	#, D.4428
	call	memcpy	#
	movq	(%rbx), %rax	# s_25->Sup.len, s_25->Sup.len
	addq	0(%rbp), %rax	# s_42->Sup.len, D.4428
	leaq	16(%r12), %rsi	#, tmp283
	movq	TMP51+16(%rip), %rdx	# MEM[(void *)&TMP51 + 16B], MEM[(void *)&TMP51 + 16B]
	movq	%rbp, %rbx	# s, s
	movq	%rax, 0(%rbp)	# D.4428, s_42->Sup.len
	leaq	16(%rbp,%rax), %rax	#, tmp274
	movq	%rdx, (%rax)	# MEM[(void *)&TMP51 + 16B], MEM[(void *)s_42]
	movzwl	TMP51+24(%rip), %edx	# MEM[(void *)&TMP51 + 16B], MEM[(void *)&TMP51 + 16B]
	movw	%dx, 8(%rax)	# MEM[(void *)&TMP51 + 16B], MEM[(void *)s_42]
	movq	0(%rbp), %rax	# s_42->Sup.len, s_42->Sup.len
	leaq	9(%rax), %rdx	#, D.4428
	leaq	25(%rbp,%rax), %rdi	#, tmp280
	movq	%rdx, 0(%rbp)	# D.4428, s_42->Sup.len
	movq	(%r12), %rax	# LOC10_36->Sup.len, tmp297
	leaq	1(%rax), %rdx	#, D.4428
	call	memcpy	#
	movq	(%r12), %rax	# LOC10_36->Sup.len, LOC10_36->Sup.len
	addq	%rax, 0(%rbp)	# LOC10_36->Sup.len, s_42->Sup.len
.L32:
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 56
	leaq	16(%rbx), %rdi	#, tmp290
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	jmp	puts	#
	.cfi_endproc
.LFE86:
	.size	bmechoresults_139639, .-bmechoresults_139639
	.section	.text.unlikely
.LCOLDE6:
	.text
.LHOTE6:
	.section	.text.unlikely
.LCOLDB7:
	.text
.LHOTB7:
	.p2align 4,,15
	.globl	PreMain
	.type	PreMain, @function
PreMain:
.LFB89:
	.cfi_startproc
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 32
	movq	%fs:40, %rax	#, tmp85
	movq	%rax, 8(%rsp)	# tmp85, D.4458
	xorl	%eax, %eax	# tmp85
	call	systemDatInit	#
	movq	%rsp, %rdi	#,
	movq	$PreMainInner, (%rsp)	#, inner
	call	setStackBottom	#
	xorl	%eax, %eax	#
	movq	(%rsp), %rdx	# inner, D.4457
	call	*%rdx	# D.4457
	movq	8(%rsp), %rax	# D.4458, tmp86
	xorq	%fs:40, %rax	#, tmp86
	jne	.L37	#,
	addq	$24, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L37:
	.cfi_restore_state
	call	__stack_chk_fail	#
	.cfi_endproc
.LFE89:
	.size	PreMain, .-PreMain
	.section	.text.unlikely
.LCOLDE7:
	.text
.LHOTE7:
	.section	.text.unlikely
.LCOLDB8:
	.text
.LHOTB8:
	.p2align 4,,15
	.globl	NimMain
	.type	NimMain, @function
NimMain:
.LFB91:
	.cfi_startproc
	subq	$40, %rsp	#,
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax	#, tmp87
	movq	%rax, 24(%rsp)	# tmp87, D.4465
	xorl	%eax, %eax	# tmp87
	call	systemDatInit	#
	leaq	16(%rsp), %rdi	#, tmp89
	movq	$PreMainInner, 16(%rsp)	#, inner
	call	setStackBottom	#
	xorl	%eax, %eax	#
	movq	16(%rsp), %rdx	# inner, D.4464
	call	*%rdx	# D.4464
	leaq	8(%rsp), %rdi	#, tmp90
	movq	$NimMainInner, 8(%rsp)	#, inner
	call	setStackBottom	#
	xorl	%eax, %eax	#
	movq	8(%rsp), %rdx	# inner, D.4464
	call	*%rdx	# D.4464
	movq	24(%rsp), %rax	# D.4465, tmp88
	xorq	%fs:40, %rax	#, tmp88
	jne	.L41	#,
	addq	$40, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L41:
	.cfi_restore_state
	call	__stack_chk_fail	#
	.cfi_endproc
.LFE91:
	.size	NimMain, .-NimMain
	.section	.text.unlikely
.LCOLDE8:
	.text
.LHOTE8:
	.section	.text.unlikely
.LCOLDB9:
	.section	.text.startup,"ax",@progbits
.LHOTB9:
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB92:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
	movq	%rsi, cmdLine(%rip)	# args, cmdLine
	movl	%edi, cmdCount(%rip)	# argc, cmdCount
	movq	%rdx, gEnv(%rip)	# env, gEnv
	call	NimMain	#
	movl	nim_program_result(%rip), %eax	# nim_program_result,
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE92:
	.size	main, .-main
	.section	.text.unlikely
.LCOLDE9:
	.section	.text.startup
.LHOTE9:
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC10:
	.string	"nil"
.LC14:
	.string	"%s%s\n"
.LC15:
	.string	"%s%s%s%s%s%s%s%s\n"
.LC16:
	.string	"%s%s%s%s\n"
.LC17:
	.string	"%s%s%s%s%s%s\n"
	.section	.text.unlikely
.LCOLDB18:
	.text
.LHOTB18:
	.p2align 4,,15
	.globl	benchmarkInit
	.type	benchmarkInit, @function
benchmarkInit:
.LFB93:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	$3, %r14d	#, D.4599
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$1128, %rsp	#,
	.cfi_def_cfa_offset 1184
	movq	%fs:40, %rax	#, tmp459
	movq	%rax, 1112(%rsp)	# tmp459, D.4612
	xorl	%eax, %eax	# tmp459
.L50:
	call	ntepochTime	#
	addsd	.LC11(%rip), %xmm0	#, endtime
	movsd	%xmm0, 32(%rsp)	# endtime, %sfp
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 156 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	movl	%ecx, %ebp	# aux, aux
	movl	%edx, %r13d	# hi, hi
	movl	%eax, %r12d	# lo,
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	xorl	%r15d, %r15d	# ec
	jmp	.L45	#
	.p2align 4,,10
	.p2align 3
.L138:
#APP
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	salq	$32, %rdx	#, D.4605
	movl	%eax, %esi	# lo, D.4604
	movl	%ecx, %edi	# aux, aux
	orq	%rsi, %rdx	# D.4604, ec
	movq	%rdx, %r15	# ec, ec
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	cmpl	%ebp, %edi	# aux, aux
	jne	.L48	#,
.L45:
	call	ntepochTime	#
	movsd	32(%rsp), %xmm2	# %sfp, endtime
	ucomisd	%xmm0, %xmm2	# LOC4, endtime
	jae	.L138	#,
	salq	$32, %r13	#, D.4605
	pxor	%xmm0, %xmm0	# D.4597
	orq	%r12, %r13	# D.4604, start
	movq	%r15, %rsi	# ec, D.4604
	subq	%r13, %rsi	# start, D.4604
	pxor	%xmm6, %xmm6	# tmp469
	cvtsi2sdq	%rsi, %xmm0	# D.4604, D.4597
	mulsd	.LC12(%rip), %xmm0	#, result
	ucomisd	%xmm6, %xmm0	# tmp469, result
	ja	.L51	#,
.L48:
	subq	$1, %r14	#, D.4599
	jne	.L50	#,
	movsd	.LC1(%rip), %xmm0	#, result
.L49:
.L51:
	movl	$TMP19, %edi	#,
	movsd	%xmm0, gbmcyclespersecond_139033(%rip)	# result, gbmcyclespersecond_139033
	movl	$3, %r14d	#, D.4599
	call	copyString	#
	movq	%rax, 80(%rsp)	#, %sfp
.L57:
	call	ntepochTime	#
	addsd	.LC11(%rip), %xmm0	#, endtime
	movsd	%xmm0, 40(%rsp)	# endtime, %sfp
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 156 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	movl	%ecx, %ebp	# aux, aux
	movl	%edx, %r13d	# hi, hi
	movl	%eax, %r12d	# lo,
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	xorl	%r15d, %r15d	# ec
	jmp	.L52	#
	.p2align 4,,10
	.p2align 3
.L139:
#APP
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	salq	$32, %rdx	#, D.4605
	movl	%eax, %esi	# lo, D.4604
	movl	%ecx, %edi	# aux, aux
	orq	%rsi, %rdx	# D.4604, ec
	movq	%rdx, %r15	# ec, ec
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	cmpl	%ebp, %edi	# aux, aux
	jne	.L55	#,
.L52:
	call	ntepochTime	#
	movsd	40(%rsp), %xmm3	# %sfp, endtime
	ucomisd	%xmm0, %xmm3	# LOC4, endtime
	jae	.L139	#,
	salq	$32, %r13	#, D.4605
	pxor	%xmm0, %xmm0	# D.4597
	orq	%r12, %r13	# D.4604, start
	movq	%r15, %rsi	# ec, D.4604
	subq	%r13, %rsi	# start, D.4604
	pxor	%xmm7, %xmm7	# tmp478
	cvtsi2sdq	%rsi, %xmm0	# D.4604, D.4597
	mulsd	.LC12(%rip), %xmm0	#, result
	ucomisd	%xmm7, %xmm0	# tmp478, result
	ja	.L58	#,
.L55:
	subq	$1, %r14	#, D.4599
	jne	.L57	#,
	movsd	.LC1(%rip), %xmm0	#, result
.L56:
.L58:
	leaq	400(%rsp), %rdx	#, tmp325
	xorl	%eax, %eax	# tmp327
	movl	$88, %ecx	#, tmp328
	movsd	%xmm0, 64(%rsp)	# result, %sfp
	movq	$0, 112(%rsp)	#, loops
	movq	%rdx, %rdi	# tmp325, tmp326
	rep stosq
	movl	$TMP20, %edi	#,
	call	copyString	#
	movq	exchandler_21843@gottpoff(%rip), %rdx	#, tmp329
	movq	%rax, 88(%rsp)	#, %sfp
	leaq	176(%rsp), %rdi	#, tmp334
	movb	$0, 376(%rsp)	#, TMP21.hasRaiseAction
	movq	%fs:(%rdx), %rax	# exchandler_21843, exchandler_21843
	movq	%rax, 160(%rsp)	# exchandler_21843, TMP21.prev
	leaq	160(%rsp), %rax	#, tmp332
	movq	%rax, %fs:(%rdx)	# tmp332, exchandler_21843
	call	_setjmp	#
	cltq
	testq	%rax, %rax	# D.4604
	movq	%rax, 168(%rsp)	# D.4604, TMP21.status
	jne	.L140	#,
.L62:
	movl	$11, %edi	#,
	movq	$0, 112(%rsp)	#, loops
	call	newseq_139807	#
	movq	%rax, %r12	#, durations_139786
	call	ntepochTime	#
	movsd	%xmm0, 120(%rsp)	# start_139790, cur_139792
	movsd	%xmm0, 56(%rsp)	# start_139790, %sfp
	movsd	120(%rsp), %xmm1	# cur_139792, D.4597
	subsd	%xmm0, %xmm1	# start_139790, D.4597
	movsd	.LC13(%rip), %xmm0	#, tmp340
	ucomisd	%xmm1, %xmm0	# D.4597, tmp340
	jbe	.L92	#,
	leaq	16(%r12), %rax	#, D.4608
	movsd	%xmm0, 48(%rsp)	# tmp340, %sfp
	xorl	%r14d, %r14d	# D.4600
	movl	$.LC10, %r13d	#, tmp436
	movq	%rax, 72(%rsp)	# D.4608, %sfp
	.p2align 4,,10
	.p2align 3
.L91:
	xorl	%eax, %eax	# tmp481
	movb	$1, 111(%rsp)	#, ok_139828
	movq	$0, 128(%rsp)	#, bc_139834
	testb	%al, %al	# tmp481
	movq	$0, 136(%rsp)	#, ec_139836
	je	.L69	#,
	movl	$11, %edi	#,
	call	nimIntToStr	#
	leaq	16(%rax), %rcx	#, tmp415
	testq	%rax, %rax	# LOC19
	movl	$TMP32+16, %edx	#,
	movl	$.LC14, %esi	#,
	movl	$1, %edi	#,
	cmove	%r13, %rcx	# tmp415,, tmp436, D.4598
	xorl	%eax, %eax	#
	call	__printf_chk	#
.L69:
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 156 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	movl	%ecx, %r15d	# aux, tscauxinitial_139830
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	xorl	%ebp, %ebp	# res_141416
	movq	%r15, %r10	# tscauxinitial_139830, tscauxinitial_139830
	movq	%rbp, %r15	# res_141416, res_141416
	jmp	.L67	#
	.p2align 4,,10
	.p2align 3
.L142:
	cmpq	%r10, %rbp	# tscauxinitial_139830, tscauxnow_139832
	jne	.L141	#,
.L71:
	addq	$1, %r15	#, res_141416
	cmpq	$11, %r15	#, res_141416
	je	.L82	#,
.L67:
	movq	%r15, i_139838(%rip)	# res_141416, i_139838
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
# 145 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtsc
	
# 0 "" 2
#NO_APP
	salq	$32, %rdx	#, D.4605
	movl	%eax, %eax	# lo, D.4604
	orq	%rdx, %rax	# D.4605, result
	movq	%rax, 128(%rsp)	# result, bc_139834
	lock addq	$1, 112(%rsp)	#,,
#APP
# 170 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	rdtscp
	
# 0 "" 2
#NO_APP
	salq	$32, %rdx	#, D.4605
	movl	%eax, %eax	# lo, D.4604
	movl	%ecx, %ebp	# aux, tscauxnow_139832
	movq	%rdx, %rsi	# D.4605, result
	orq	%rax, %rsi	# D.4604, result
#APP
# 133 "/home/wink/prgs/nim/benchmark/benchmark.nim" 1
	cpuid
	
# 0 "" 2
#NO_APP
	movq	%rsi, 136(%rsp)	# result, ec_139836
	movq	136(%rsp), %rax	# ec_139836, D.4604
	movq	128(%rsp), %rdx	# bc_139834, D.4604
	pxor	%xmm0, %xmm0	# tmp368
	movq	i_139838(%rip), %rdi	# i_139838, D.4604
	subq	%rdx, %rax	# D.4604, D.4604
	testb	%r14b, %r14b	# D.4600
	cvtsi2sdq	%rax, %xmm0	# D.4604, tmp368
	movsd	%xmm0, 16(%r12,%rdi,8)	# tmp368, durations_139786_76->data
	je	.L142	#,
	movq	%r10, 24(%rsp)	# tscauxinitial_139830, %sfp
	call	nimIntToStr	#
	movq	%rax, %rbx	#, LOC30
	movq	i_139838(%rip), %rax	# i_139838, i_139838
	movsd	16(%r12,%rax,8), %xmm0	# durations_139786_76->data, tmp371
	call	nimFloatToStr	#
	pxor	%xmm0, %xmm0	# D.4597
	movq	%rax, 16(%rsp)	# LOC31, %sfp
	movq	136(%rsp), %rax	# ec_139836, D.4604
	cvtsi2sdq	%rax, %xmm0	# D.4604, D.4597
	call	nimFloatToStr	#
	pxor	%xmm0, %xmm0	# D.4597
	movq	%rax, 8(%rsp)	# LOC32, %sfp
	movq	128(%rsp), %rax	# bc_139834, D.4604
	cvtsi2sdq	%rax, %xmm0	# D.4604, D.4597
	call	nimFloatToStr	#
	movq	8(%rsp), %rdi	# %sfp, LOC32
	movq	16(%rsp), %rcx	# %sfp, LOC31
	leaq	16(%rax), %rsi	#, tmp417
	testq	%rax, %rax	# LOC33
	movl	$TMP34+16, %r8d	#,
	cmove	%r13, %rsi	# tmp417,, tmp436, D.4598
	leaq	16(%rdi), %rdx	#, tmp427
	testq	%rdi, %rdi	# LOC32
	leaq	16(%rcx), %r9	#, tmp419
	pushq	%rsi	# D.4598
	.cfi_def_cfa_offset 1192
	pushq	$TMP36+16	#
	.cfi_def_cfa_offset 1200
	movl	$.LC15, %esi	#,
	cmove	%r13, %rdx	# tmp427,, tmp436, D.4598
	testq	%rcx, %rcx	# LOC31
	leaq	16(%rbx), %rcx	#, tmp433
	pushq	%rdx	# D.4598
	.cfi_def_cfa_offset 1208
	cmove	%r13, %r9	# tmp419,, tmp436, D.4598
	pushq	$TMP35+16	#
	.cfi_def_cfa_offset 1216
	testq	%rbx, %rbx	# LOC30
	movl	$TMP33+16, %edx	#,
	movl	$1, %edi	#,
	cmove	%r13, %rcx	# tmp433,, tmp436, D.4598
	xorl	%eax, %eax	#
	call	__printf_chk	#
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 1184
	movq	24(%rsp), %r10	# %sfp, tscauxinitial_139830
	cmpq	%r10, %rbp	# tscauxinitial_139830, tscauxnow_139832
	je	.L71	#,
.L141:
.L80:
	movq	%r10, %r15	# tscauxinitial_139830, tscauxinitial_139830
	movl	$4, %esi	#,
	movq	%rbp, %rdi	# tscauxnow_139832,
	call	nsuToHex	#
	movl	$4, %esi	#,
	movq	%r15, %rdi	# tscauxinitial_139830,
	movq	%rax, %rbx	#, LOC43
	call	nsuToHex	#
	leaq	16(%rax), %r9	#, tmp421
	testq	%rax, %rax	# LOC44
	leaq	16(%rbx), %rcx	#, tmp429
	movl	$TMP39+16, %r8d	#,
	movl	$TMP37+16, %edx	#,
	movl	$.LC16, %esi	#,
	cmove	%r13, %r9	# tmp421,, tmp436, D.4598
	testq	%rbx, %rbx	# LOC43
	movl	$1, %edi	#,
	cmove	%r13, %rcx	# tmp429,, tmp436, D.4598
	xorl	%eax, %eax	#
	call	__printf_chk	#
	movb	$0, 111(%rsp)	#, ok_139828
.L81:
	.p2align 4,,10
	.p2align 3
.L82:
	movzbl	111(%rsp), %eax	# ok_139828, D.4607
	testb	%al, %al	# D.4607
	jne	.L143	#,
.L85:
.L86:
	xorl	%ebx, %ebx	# tmp483
	movzbl	111(%rsp), %eax	# ok_139828, D.4607
	testb	%bl, %bl	# tmp483
	je	.L90	#,
	testb	%al, %al	# D.4607
	je	.L87	#,
.L90:
	call	ntepochTime	#
	movsd	%xmm0, 120(%rsp)	# D.4597, cur_139792
	movsd	48(%rsp), %xmm5	# %sfp, tmp438
	movsd	120(%rsp), %xmm0	# cur_139792, D.4597
	subsd	56(%rsp), %xmm0	# %sfp, D.4597
	ucomisd	%xmm0, %xmm5	# D.4597, tmp438
	ja	.L91	#,
.L92:
	movq	exchandler_21843@gottpoff(%rip), %rax	#, tmp341
	movq	%fs:(%rax), %rdx	# exchandler_21843, exchandler_21843
	movq	(%rdx), %rdx	# _147->prev, _147->prev
	movq	%rdx, %fs:(%rax)	# _147->prev, exchandler_21843
.L65:
	movq	80(%rsp), %r12	# %sfp, suitename
	movq	88(%rsp), %r13	# %sfp, runxname
	leaq	400(%rsp), %rbp	#, ivtmp.110
	xorl	%ebx, %ebx	# res_141430
	.p2align 4,,10
	.p2align 3
.L104:
	movsd	64(%rsp), %xmm0	# %sfp,
	movq	%rbx, i_139737(%rip)	# res_141430, i_139737
	movq	%rbp, %rdi	# ivtmp.110,
	movq	%r13, %rcx	# runxname,
	movq	%r12, %rdx	# suitename,
	movl	$1, %esi	#,
	addq	$1, %rbx	#, res_141430
	addq	$64, %rbp	#, ivtmp.110
	call	bmechoresults_139639	#
	cmpq	$11, %rbx	#, res_141430
	jne	.L104	#,
.L105:
.L106:
	cmpq	$0, 168(%rsp)	#, TMP21.status
	je	.L44	#,
	call	reraiseException	#
.L44:
	movq	1112(%rsp), %rax	# D.4612, tmp460
	xorq	%fs:40, %rax	#, tmp460
	jne	.L144	#,
	addq	$1128, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret
.L140:
	.cfi_restore_state
	movq	exchandler_21843@gottpoff(%rip), %rax	#, tmp410
	movq	%fs:(%rax), %rdx	# exchandler_21843, exchandler_21843
	movq	(%rdx), %rdx	# _325->prev, _325->prev
	movq	$0, 168(%rsp)	#, TMP21.status
	movq	%rdx, %fs:(%rax)	# _325->prev, exchandler_21843
	movq	currexception_21845@gottpoff(%rip), %rax	#, tmp414
	movq	%fs:(%rax), %rax	# currexception_21845, e
	testq	%rax, %rax	# e
	je	.L145	#,
.L94:
	movq	24(%rax), %rdi	# e_90->message, e_90->message
	call	copyString	#
.L93:
.L95:
.L99:
	testq	%rax, %rax	# LOC67
	leaq	16(%rax), %rdx	#, tmp423
	movq	88(%rsp), %rax	# %sfp, runxname
	movq	80(%rsp), %rbx	# %sfp, suitename
	movl	$.LC10, %ecx	#, tmp424
	movl	$TMP45+16, %r8d	#,
	cmove	%rcx, %rdx	# tmp423,, tmp424, D.4598
	movl	$.LC17, %esi	#,
	movl	$1, %edi	#,
	leaq	16(%rax), %r9	#, tmp431
	testq	%rax, %rax	# runxname
	pushq	%rdx	# D.4598
	.cfi_def_cfa_offset 1192
	movq	%rbx, %rax	# suitename, suitename
	pushq	$TMP46+16	#
	.cfi_def_cfa_offset 1200
	movl	$TMP44+16, %edx	#,
	cmove	%rcx, %r9	# tmp431,, tmp424, D.4598
	addq	$16, %rax	#, tmp425
	testq	%rbx, %rbx	# suitename
	cmovne	%rax, %rcx	# tmp425,, D.4598
	xorl	%eax, %eax	#
	call	__printf_chk	#
	movq	currexception_21845@gottpoff(%rip), %rbp	#, tmp383
	popq	%rax	#
	.cfi_def_cfa_offset 1192
	popq	%rdx	#
	.cfi_def_cfa_offset 1184
	movq	%fs:0(%rbp), %rdx	# currexception_21845, D.4606
	movq	8(%rdx), %rbx	# _70->parent, D.4606
	testq	%rbx, %rbx	# D.4606
	je	.L101	#,
	movq	-16(%rbx), %rax	# LOC5_294->Refcount, tmp490
	movq	-8(%rbx), %rcx	# MEM[(struct TNimType * *)LOC5_294 + 8B], MEM[(struct TNimType * *)LOC5_294 + 8B]
	leaq	-16(%rbx), %rsi	#, LOC5
	addq	$8, %rax	#, D.4604
	movq	%rax, -16(%rbx)	# D.4604, LOC5_294->Refcount
	testb	$2, 9(%rcx)	#, _302->flags
	je	.L146	#,
.L101:
	movq	-16(%rdx), %rax	# LOC10_298->Refcount, tmp492
	leaq	-16(%rdx), %rsi	#, LOC10
	subq	$8, %rax	#, D.4604
	cmpq	$7, %rax	#, D.4604
	movq	%rax, -16(%rdx)	# D.4604, LOC10_298->Refcount
	jbe	.L147	#,
.L102:
	movq	-8(%rdx), %rdx	# MEM[(struct TNimType * *)LOC10_298 + 8B], MEM[(struct TNimType * *)LOC10_298 + 8B]
	testb	$2, 9(%rdx)	#, _311->flags
	je	.L148	#,
.L103:
	movq	currexception_21845@gottpoff(%rip), %rax	#, tmp395
	movq	%rbx, %fs:(%rax)	# D.4606, currexception_21845
	jmp	.L65	#
	.p2align 4,,10
	.p2align 3
.L143:
	movq	$0, 152(%rsp)	#, MEM[(void *)&LOC49]
	movq	$cmp_139887, 144(%rsp)	#, LOC49.ClPrc
	leaq	400(%rsp), %rbp	#, ivtmp.121
	movq	144(%rsp), %rdx	# LOC49,
	movq	152(%rsp), %rcx	# LOC49,
	movl	$1, %r8d	#,
	movq	(%r12), %rsi	# durations_139786_76->Sup.len,
	movq	72(%rsp), %rdi	# %sfp,
	xorl	%ebx, %ebx	# res_141423
	call	sort_139904	#
	.p2align 4,,10
	.p2align 3
.L84:
	movsd	16(%r12,%rbx,8), %xmm0	# MEM[base: durations_139786_76, index: _163, step: 8, offset: 16B],
	movq	%rbx, i_139840(%rip)	# res_141423, i_139840
	movq	%rbp, %rdi	# ivtmp.121,
	addq	$1, %rbx	#, res_141423
	addq	$64, %rbp	#, ivtmp.121
	call	push_113861	#
	cmpq	$11, %rbx	#, res_141423
	jne	.L84	#,
	jmp	.L86	#
	.p2align 4,,10
	.p2align 3
.L87:
	movl	$TMP43+16, %edi	#,
	call	puts	#
	jmp	.L90	#
.L146:
	movq	%rax, %rcx	# D.4604, D.4604
	andl	$3, %ecx	#, D.4604
	cmpq	$3, %rcx	#, D.4604
	je	.L101	#,
	movq	gch_52844@gottpoff(%rip), %rdi	#, tmp392
	addq	%fs:0, %rdi	# tmp393
	orq	$3, %rax	#, tmp389
	movq	%rax, -16(%rbx)	# tmp389, LOC5_294->Refcount
	addq	$64, %rdi	#, tmp390
	call	incl_51667	#
	movq	%fs:0(%rbp), %rdx	# currexception_21845, D.4606
	testq	%rdx, %rdx	# D.4606
	je	.L103	#,
	jmp	.L101	#
	.p2align 4,,10
	.p2align 3
.L148:
	movq	%rax, %rdx	# D.4604, D.4604
	andl	$3, %edx	#, D.4604
	cmpq	$3, %rdx	#, D.4604
	je	.L103	#,
	movq	gch_52844@gottpoff(%rip), %rdi	#, tmp408
	addq	%fs:0, %rdi	# tmp409
	orq	$3, %rax	#, tmp405
	movq	%rax, (%rsi)	# tmp405, LOC10_298->Refcount
	addq	$64, %rdi	#, tmp406
	call	incl_51667	#
	jmp	.L103	#
.L147:
	movq	gch_52844@gottpoff(%rip), %rdi	#, tmp399
	addq	%fs:0, %rdi	# tmp400
	addq	$16, %rdi	#, tmp397
	call	addzct_54444	#
	jmp	.L103	#
.L145:
	movl	$TMP47, %edi	#,
	call	copyString	#
	jmp	.L95	#
.L144:
	call	__stack_chk_fail	#
	.cfi_endproc
.LFE93:
	.size	benchmarkInit, .-benchmarkInit
	.section	.text.unlikely
.LCOLDE18:
	.text
.LHOTE18:
	.section	.text.unlikely
.LCOLDB19:
	.text
.LHOTB19:
	.p2align 4,,15
	.globl	NimMainInner
	.type	NimMainInner, @function
NimMainInner:
.LFB90:
	.cfi_startproc
	jmp	benchmarkInit	#
	.cfi_endproc
.LFE90:
	.size	NimMainInner, .-NimMainInner
	.section	.text.unlikely
.LCOLDE19:
	.text
.LHOTE19:
	.section	.text.unlikely
.LCOLDB20:
	.text
.LHOTB20:
	.p2align 4,,15
	.globl	benchmarkDatInit
	.type	benchmarkDatInit, @function
benchmarkDatInit:
.LFB94:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE94:
	.size	benchmarkDatInit, .-benchmarkDatInit
	.section	.text.unlikely
.LCOLDE20:
	.text
.LHOTE20:
	.comm	gEnv,8,8
	.comm	cmdLine,8,8
	.comm	cmdCount,4,4
	.comm	i_139737,8,8
	.comm	i_139840,8,8
	.comm	i_139838,8,8
	.comm	gbmcyclespersecond_139033,8,8
	.section	.rodata
	.align 16
	.type	TMP57, @object
	.size	TMP57, 24
TMP57:
# Sup:
# len:
	.quad	1
# reserved:
	.quad	1
# data:
	.string	"}"
	.zero	6
	.align 16
	.type	TMP56, @object
	.size	TMP56, 24
TMP56:
# Sup:
# len:
	.quad	6
# reserved:
	.quad	6
# data:
	.string	" mean="
	.zero	1
	.align 16
	.type	TMP55, @object
	.size	TMP55, 24
TMP55:
# Sup:
# len:
	.quad	5
# reserved:
	.quad	5
# data:
	.string	" max="
	.zero	2
	.align 16
	.type	TMP54, @object
	.size	TMP54, 24
TMP54:
# Sup:
# len:
	.quad	5
# reserved:
	.quad	5
# data:
	.string	" min="
	.zero	2
	.align 16
	.type	TMP53, @object
	.size	TMP53, 24
TMP53:
# Sup:
# len:
	.quad	5
# reserved:
	.quad	5
# data:
	.string	" sum="
	.zero	2
	.align 16
	.type	TMP52, @object
	.size	TMP52, 24
TMP52:
# Sup:
# len:
	.quad	3
# reserved:
	.quad	3
# data:
	.string	"{n="
	.zero	4
	.align 32
	.type	TMP51, @object
	.size	TMP51, 32
TMP51:
# Sup:
# len:
	.quad	9
# reserved:
	.quad	9
# data:
	.string	" runStat="
	.zero	6
	.align 16
	.type	TMP50, @object
	.size	TMP50, 24
TMP50:
# Sup:
# len:
	.quad	2
# reserved:
	.quad	2
# data:
	.string	"] "
	.zero	5
	.align 16
	.type	TMP49, @object
	.size	TMP49, 24
TMP49:
# Sup:
# len:
	.quad	6
# reserved:
	.quad	6
# data:
	.string	" time="
	.zero	1
	.align 32
	.type	TMP48, @object
	.size	TMP48, 32
TMP48:
# Sup:
# len:
	.quad	8
# reserved:
	.quad	8
# data:
	.string	"[cycles:"
	.zero	7
	.align 16
	.type	TMP47, @object
	.size	TMP47, 24
TMP47:
	.zero	24
	.align 32
	.type	TMP46, @object
	.size	TMP46, 32
TMP46:
# Sup:
# len:
	.quad	12
# reserved:
	.quad	12
# data:
	.string	": exception="
	.zero	3
	.align 16
	.type	TMP45, @object
	.size	TMP45, 24
TMP45:
# Sup:
# len:
	.quad	1
# reserved:
	.quad	1
# data:
	.string	"."
	.zero	6
	.align 16
	.type	TMP44, @object
	.size	TMP44, 24
TMP44:
# Sup:
# len:
	.quad	6
# reserved:
	.quad	6
# data:
	.string	"bmRun "
	.zero	1
	.align 32
	.type	TMP43, @object
	.size	TMP43, 56
TMP43:
# Sup:
# len:
	.quad	33
# reserved:
	.quad	33
# data:
	.string	"echo measureForX: bad measurement"
	.zero	6
	.align 32
	.type	TMP39, @object
	.size	TMP39, 40
TMP39:
# Sup:
# len:
	.quad	20
# reserved:
	.quad	20
# data:
	.string	" != tscAuxInitial=0x"
	.zero	3
	.align 32
	.type	TMP37, @object
	.size	TMP37, 40
TMP37:
# Sup:
# len:
	.quad	16
# reserved:
	.quad	16
# data:
	.string	"bad tscAuxNow=0x"
	.zero	7
	.align 16
	.type	TMP36, @object
	.size	TMP36, 24
TMP36:
# Sup:
# len:
	.quad	4
# reserved:
	.quad	4
# data:
	.string	" bc="
	.zero	3
	.align 16
	.type	TMP35, @object
	.size	TMP35, 24
TMP35:
# Sup:
# len:
	.quad	4
# reserved:
	.quad	4
# data:
	.string	" ec="
	.zero	3
	.align 16
	.type	TMP34, @object
	.size	TMP34, 24
TMP34:
# Sup:
# len:
	.quad	2
# reserved:
	.quad	2
# data:
	.string	"]="
	.zero	5
	.align 32
	.type	TMP33, @object
	.size	TMP33, 32
TMP33:
# Sup:
# len:
	.quad	9
# reserved:
	.quad	9
# data:
	.string	"duration["
	.zero	6
	.align 32
	.type	TMP32, @object
	.size	TMP32, 40
TMP32:
# Sup:
# len:
	.quad	19
# reserved:
	.quad	19
# data:
	.string	"measurX: loopCount="
	.zero	4
	.align 32
	.type	TMP22, @object
	.size	TMP22, 40
TMP22:
# Sup:
# len:
	.quad	21
# reserved:
	.quad	21
# data:
	.string	"measureForX: seconds="
	.zero	2
	.align 32
	.type	TMP20, @object
	.size	TMP20, 32
TMP20:
# Sup:
# len:
	.quad	13
# reserved:
	.quad	13
# data:
	.string	"run 2 seconds"
	.zero	2
	.align 16
	.type	TMP19, @object
	.size	TMP19, 24
TMP19:
# Sup:
# len:
	.quad	6
# reserved:
	.quad	6
# data:
	.string	"bmRunX"
	.zero	1
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	-1074790400
	.align 8
.LC11:
	.long	0
	.long	1070596096
	.align 8
.LC12:
	.long	0
	.long	1074790400
	.align 8
.LC13:
	.long	0
	.long	1073741824
	.ident	"GCC: (Ubuntu 4.9.1-16ubuntu6) 4.9.1"
	.section	.note.GNU-stack,"",@progbits
