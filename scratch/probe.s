	.att_syntax
	.file	"probe.mojo"
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
	.type	.LCPI0_0,@object
.LCPI0_0:
	.long	0x3f800000
	.size	.LCPI0_0, 4
	.type	.LCPI0_1,@object
.LCPI0_1:
	.long	0x7f7fffff
	.size	.LCPI0_1, 4
	.type	.LCPI0_2,@object
.LCPI0_2:
	.long	0x80000000
	.size	.LCPI0_2, 4
	.type	.LCPI0_3,@object
.LCPI0_3:
	.long	0x42b0c0a6
	.size	.LCPI0_3, 4
	.type	.LCPI0_4,@object
.LCPI0_4:
	.long	0xc2b0c0a5
	.size	.LCPI0_4, 4
	.type	.LCPI0_5,@object
.LCPI0_5:
	.long	0x3f000000
	.size	.LCPI0_5, 4
	.type	.LCPI0_6,@object
.LCPI0_6:
	.long	0x3fb8aa3b
	.size	.LCPI0_6, 4
	.type	.LCPI0_7,@object
.LCPI0_7:
	.long	0xbf317218
	.size	.LCPI0_7, 4
	.type	.LCPI0_8,@object
.LCPI0_8:
	.long	0x3ab60b61
	.size	.LCPI0_8, 4
	.type	.LCPI0_9,@object
.LCPI0_9:
	.long	0x39500d01
	.size	.LCPI0_9, 4
	.type	.LCPI0_10,@object
.LCPI0_10:
	.long	0x3c088889
	.size	.LCPI0_10, 4
	.type	.LCPI0_11,@object
.LCPI0_11:
	.long	0x3d2aaaab
	.size	.LCPI0_11, 4
	.type	.LCPI0_12,@object
.LCPI0_12:
	.long	0x3e2aaaab
	.size	.LCPI0_12, 4
	.type	.LCPI0_13,@object
.LCPI0_13:
	.long	0x7fffffff
	.size	.LCPI0_13, 4
	.type	.LCPI0_14,@object
.LCPI0_14:
	.long	0x3727c5ac
	.size	.LCPI0_14, 4
	.text
	.globl	probe_exp
	.prefalign	4, .Lfunc_end0, nop
	.type	probe_exp,@function
probe_exp:
.Lprobe_exp$local:
	.type	.Lprobe_exp$local,@function
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$112, %rsp
	.cfi_def_cfa_offset 128
	.cfi_offset %rbx, -16
	testq	%rsi, %rsi
	jle	.LBB0_1
	testq	%rcx, %rcx
	jle	.LBB0_3
	vmovaps	%xmm0, %xmm7
	leaq	(,%rdx,4), %rax
	vpxor	%xmm15, %xmm15, %xmm15
	xorl	%r8d, %r8d
	vmovss	.LCPI0_0(%rip), %xmm3
	vbroadcastss	.LCPI0_13(%rip), %xmm0
	vmovaps	%xmm0, 96(%rsp)
	vxorps	%xmm6, %xmm6, %xmm6
	movq	%rdi, %r9
	vbroadcastss	.LCPI0_3(%rip), %xmm0
	vbroadcastss	.LCPI0_4(%rip), %xmm11
	vbroadcastss	.LCPI0_7(%rip), %xmm8
	vbroadcastss	.LCPI0_8(%rip), %xmm10
	vbroadcastss	.LCPI0_10(%rip), %xmm9
	vbroadcastss	.LCPI0_0(%rip), %xmm4
	vxorps	%xmm1, %xmm1, %xmm1
	vmovss	%xmm7, 24(%rsp)
	jmp	.LBB0_6
	.p2align	4
.LBB0_17:
	vmovaps	32(%rsp), %xmm1
	vxorps	%xmm6, %xmm6, %xmm6
.LBB0_24:
	vmovss	20(%rsp), %xmm2
	vaddss	%xmm1, %xmm2, %xmm1
	addq	%rax, %r9
	cmpq	%rsi, %r8
	je	.LBB0_25
.LBB0_6:
	vmovss	%xmm1, 20(%rsp)
	movq	%r8, %r10
	incq	%r8
	imulq	%rdx, %r10
	vbroadcastss	4(%rdi,%r10,4), %xmm14
	xorl	%r10d, %r10d
	vmovaps	%xmm3, 32(%rsp)
	vmovss	.LCPI0_1(%rip), %xmm13
	vxorps	%xmm12, %xmm12, %xmm12
	jmp	.LBB0_7
	.p2align	4
.LBB0_22:
	vaddss	%xmm6, %xmm13, %xmm1
	vmovaps	%xmm13, %xmm0
	vmovaps	%xmm6, %xmm13
	vaddss	%xmm6, %xmm6, %xmm6
	vmulss	.LCPI0_5(%rip), %xmm1, %xmm1
	vmovss	.LCPI0_1(%rip), %xmm9
	vcmpless	%xmm0, %xmm9, %xmm9
	vblendvps	%xmm9, %xmm6, %xmm1, %xmm1
	vbroadcastss	.LCPI0_10(%rip), %xmm9
	vbroadcastss	.LCPI0_3(%rip), %xmm0
	vxorps	%xmm6, %xmm6, %xmm6
	vmovaps	80(%rsp), %xmm12
.LBB0_23:
	vcmpltss	%xmm2, %xmm5, %xmm2
	vblendvps	%xmm2, %xmm12, %xmm13, %xmm12
	vmovaps	%xmm1, 32(%rsp)
	vmovaps	%xmm7, %xmm13
	vmovaps	%xmm5, %xmm7
	cmpq	%rcx, %r10
	je	.LBB0_24
.LBB0_7:
	vmovaps	%xmm12, 80(%rsp)
	cmpq	$5, %rdx
	jge	.LBB0_9
	vmovaps	%xmm7, %xmm5
	movl	$1, %r11d
	vxorps	%xmm2, %xmm2, %xmm2
	cmpq	%rdx, %r11
	jl	.LBB0_13
	jmp	.LBB0_16
	.p2align	4
.LBB0_9:
	vmovss	%xmm13, 28(%rsp)
	vbroadcastss	32(%rsp), %xmm7
	vxorps	%xmm2, %xmm2, %xmm2
	movl	$5, %r11d
	vmovaps	%xmm9, %xmm3
	vbroadcastss	.LCPI0_12(%rip), %xmm12
	vbroadcastss	.LCPI0_5(%rip), %xmm13
	vbroadcastss	.LCPI0_11(%rip), %xmm5
	.p2align	4
.LBB0_10:
	vmovups	-16(%r9,%r11,4), %xmm1
	vsubps	%xmm14, %xmm1, %xmm1
	vbroadcastss	.LCPI0_2(%rip), %xmm15
	vmaxps	%xmm6, %xmm1, %xmm1
	vxorps	%xmm1, %xmm15, %xmm1
	vdivps	%xmm7, %xmm1, %xmm1
	vminps	%xmm0, %xmm1, %xmm1
	vmaxps	%xmm11, %xmm1, %xmm1
	vbroadcastss	.LCPI0_6(%rip), %xmm15
	vfmadd213ps	%xmm13, %xmm1, %xmm15
	vroundps	$9, %xmm15, %xmm15
	vmovaps	%xmm8, %xmm6
	vfmadd213ps	%xmm1, %xmm15, %xmm6
	vbroadcastss	.LCPI0_9(%rip), %xmm9
	vfmadd213ps	%xmm10, %xmm6, %xmm9
	vfmadd213ps	%xmm3, %xmm6, %xmm9
	vfmadd213ps	%xmm5, %xmm6, %xmm9
	vfmadd213ps	%xmm12, %xmm6, %xmm9
	vfmadd213ps	%xmm13, %xmm6, %xmm9
	vfmadd213ps	%xmm4, %xmm6, %xmm9
	vcvttps2dq	%xmm15, %xmm15
	vfmadd213ps	%xmm4, %xmm6, %xmm9
	vpslld	$23, %xmm15, %xmm6
	vpbroadcastd	.LCPI0_0(%rip), %xmm15
	vpaddd	%xmm6, %xmm15, %xmm6
	vmulps	%xmm6, %xmm9, %xmm6
	vbroadcastss	.LCPI0_3(%rip), %xmm0
	vmaxps	%xmm1, %xmm6, %xmm1
	vshufpd	$1, %xmm1, %xmm1, %xmm6
	vaddps	%xmm6, %xmm1, %xmm1
	vmovshdup	%xmm1, %xmm6
	vaddss	%xmm6, %xmm1, %xmm1
	vxorps	%xmm6, %xmm6, %xmm6
	vaddss	%xmm1, %xmm2, %xmm2
	addq	$4, %r11
	cmpq	%rdx, %r11
	jle	.LBB0_10
	addq	$-4, %r11
	vmovss	24(%rsp), %xmm5
	vpxor	%xmm15, %xmm15, %xmm15
	vmovaps	%xmm3, %xmm9
	vmovss	.LCPI0_0(%rip), %xmm3
	vmovss	28(%rsp), %xmm13
	cmpq	%rdx, %r11
	jl	.LBB0_13
.LBB0_16:
	vmovaps	%xmm5, %xmm7
	vsubss	%xmm5, %xmm2, %xmm1
	vandps	96(%rsp), %xmm1, %xmm1
	vmovss	.LCPI0_14(%rip), %xmm6
	vucomiss	%xmm1, %xmm6
	ja	.LBB0_17
	incq	%r10
	vucomiss	%xmm7, %xmm2
	vmovaps	32(%rsp), %xmm6
	vmovaps	%xmm6, %xmm7
	ja	.LBB0_20
	vmovaps	%xmm13, %xmm7
.LBB0_20:
	jbe	.LBB0_22
	vmovaps	80(%rsp), %xmm12
	vaddss	%xmm6, %xmm12, %xmm1
	vmulss	.LCPI0_5(%rip), %xmm1, %xmm1
	vmovaps	%xmm6, %xmm13
	vxorps	%xmm6, %xmm6, %xmm6
	jmp	.LBB0_23
	.p2align	4
.LBB0_15:
	vaddss	%xmm7, %xmm2, %xmm2
	incq	%r11
	cmpq	%r11, %rdx
	je	.LBB0_16
.LBB0_13:
	vmovss	(%r9,%r11,4), %xmm1
	vsubss	%xmm14, %xmm1, %xmm1
	vucomiss	%xmm15, %xmm1
	vmovaps	%xmm3, %xmm7
	jbe	.LBB0_15
	vbroadcastss	.LCPI0_2(%rip), %xmm6
	vxorps	%xmm6, %xmm1, %xmm1
	vdivss	32(%rsp), %xmm1, %xmm1
	vminss	.LCPI0_3(%rip), %xmm1, %xmm1
	vmaxss	.LCPI0_4(%rip), %xmm1, %xmm1
	vmovaps	%xmm11, %xmm12
	vmovss	.LCPI0_5(%rip), %xmm11
	vmovaps	%xmm11, %xmm6
	vfmadd231ss	.LCPI0_6(%rip), %xmm1, %xmm6
	vroundss	$9, %xmm6, %xmm6, %xmm6
	vmovaps	%xmm1, %xmm7
	vfmadd231ss	.LCPI0_7(%rip), %xmm6, %xmm7
	vmovss	.LCPI0_9(%rip), %xmm9
	vfmadd213ss	.LCPI0_8(%rip), %xmm7, %xmm9
	vfmadd213ss	.LCPI0_10(%rip), %xmm7, %xmm9
	vfmadd213ss	.LCPI0_11(%rip), %xmm7, %xmm9
	vfmadd213ss	.LCPI0_12(%rip), %xmm7, %xmm9
	vfmadd213ss	%xmm11, %xmm7, %xmm9
	vmovaps	%xmm12, %xmm11
	vfmadd213ss	%xmm3, %xmm7, %xmm9
	vfmadd213ss	%xmm3, %xmm7, %xmm9
	vcvttss2si	%xmm6, %ebx
	shll	$23, %ebx
	addl	$1065353216, %ebx
	vmovd	%ebx, %xmm6
	vmulss	%xmm6, %xmm9, %xmm6
	vbroadcastss	.LCPI0_10(%rip), %xmm9
	vbroadcastss	.LCPI0_3(%rip), %xmm0
	vmaxss	%xmm1, %xmm6, %xmm7
	jmp	.LBB0_15
.LBB0_1:
	vxorps	%xmm1, %xmm1, %xmm1
	jmp	.LBB0_25
.LBB0_3:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovss	.LCPI0_0(%rip), %xmm0
	.p2align	4
.LBB0_4:
	vaddss	%xmm0, %xmm1, %xmm1
	decq	%rsi
	jne	.LBB0_4
.LBB0_25:
	movq	$12, 64(%rsp)
	leaq	static_string_b59cc01792da92e9(%rip), %rax
	movq	%rax, 56(%rsp)
	movabsq	$2305843009213693952, %rax
	movq	%rax, 72(%rsp)
	movq	$1, (%rsp)
	leaq	static_string_a8d4ace0dc8d360e(%rip), %rsi
	leaq	static_string_bbe01a6a523daf15(%rip), %rcx
	leaq	56(%rsp), %rdi
	movl	$1, %edx
	movl	$1, %r8d
	vmovaps	%xmm1, %xmm0
	xorl	%r9d, %r9d
	callq	"std::io::io::print[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2],LITImmOrigin,::Origin[False, $4],LITImmOrigin,::Origin[False, $6]](*$0,sep:::StringSpan[$4, $5],end:::StringSpan[$6, $7],flush:::Bool,file:::FileDescriptor$),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=f32,length=1>>, scalar<f32>]]"@PLT
	testb	$64, 79(%rsp)
	je	.LBB0_28
	movq	56(%rsp), %rdi
	lock		decq	-8(%rdi)
	jne	.LBB0_28
	addq	$-8, %rdi
	#MEMBARRIER
	callq	KGEN_CompilerRT_AlignedFree@PLT
.LBB0_28:
	addq	$112, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	probe_exp, .Lfunc_end0-probe_exp
	.size	.Lprobe_exp$local, .Lfunc_end0-probe_exp
	.cfi_endproc

	.prefalign	4, .Lfunc_end1, nop
	.type	"std::collections::string::string::String::write_to[::Writer & ::AnyType](::String,$0),writer.T`2x1=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]",@function
"std::collections::string::string::String::write_to[::Writer & ::AnyType](::String,$0),writer.T`2x1=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]":
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	16(%rdi), %r12
	testq	%r12, %r12
	js	.LBB1_1
	movq	8(%rdi), %r12
	movq	(%rdi), %rdi
	movq	2048(%rsi), %rbx
	leaq	(%rbx,%r12), %rax
	cmpq	$2049, %rax
	jge	.LBB1_17
.LBB1_4:
	movq	%r12, %rax
	subq	$1, %rax
	jae	.LBB1_5
.LBB1_16:
	addq	%r12, 2048(%rsi)
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.LBB1_5:
	.cfi_def_cfa_offset 48
	addq	%rsi, %rbx
	cmpq	$4, %r12
	jg	.LBB1_8
	movzbl	(%rdi), %ecx
	movb	%cl, (%rbx)
	movzbl	(%rdi,%rax), %ecx
	movb	%cl, (%rbx,%rax)
	cmpq	$3, %r12
	jl	.LBB1_16
	movzbl	1(%rdi), %eax
	movb	%al, 1(%rbx)
	movzbl	-2(%rdi,%r12), %eax
	movb	%al, -2(%rbx,%r12)
	jmp	.LBB1_16
.LBB1_1:
	shrq	$56, %r12
	andl	$31, %r12d
	movq	2048(%rsi), %rbx
	leaq	(%rbx,%r12), %rax
	cmpq	$2049, %rax
	jl	.LBB1_4
.LBB1_17:
	callq	"std::format::_utils::_fixed_buffer_exceeded()"@PLT
.LBB1_8:
	cmpq	$16, %r12
	ja	.LBB1_12
	cmpq	$8, %r12
	jb	.LBB1_11
	movq	(%rdi), %rax
	movq	%rax, (%rbx)
	movq	-8(%rdi,%r12), %rax
	movq	%rax, -8(%rbx,%r12)
	jmp	.LBB1_16
.LBB1_12:
	movabsq	$9223372036854775776, %r14
	andq	%r12, %r14
	je	.LBB1_14
	movq	%rdi, %r15
	movq	%rbx, %rdi
	movq	%rsi, %r13
	movq	%r15, %rsi
	movq	%r14, %rdx
	callq	memcpy@PLT
	movq	%r15, %rdi
	movq	%r13, %rsi
.LBB1_14:
	cmpq	%r12, %r14
	je	.LBB1_16
	addq	%r14, %rbx
	addq	%r14, %rdi
	movl	%r12d, %edx
	andl	$31, %edx
	movq	%rdi, %rax
	movq	%rbx, %rdi
	movq	%rsi, %rbx
	movq	%rax, %rsi
	callq	memcpy@PLT
	movq	%rbx, %rsi
	jmp	.LBB1_16
.LBB1_11:
	movl	(%rdi), %eax
	movl	%eax, (%rbx)
	movl	-4(%rdi,%r12), %eax
	movl	%eax, -4(%rbx,%r12)
	jmp	.LBB1_16
.Lfunc_end1:
	.size	"std::collections::string::string::String::write_to[::Writer & ::AnyType](::String,$0),writer.T`2x1=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]", .Lfunc_end1-"std::collections::string::string::String::write_to[::Writer & ::AnyType](::String,$0),writer.T`2x1=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]"
	.cfi_endproc

	.prefalign	4, .Lfunc_end2, nop
	.type	"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096",@function
"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096":
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdx, %rbx
	movq	%rsi, %r15
	movq	%rdi, %r14
	cmpq	$4097, %rdx
	jl	.LBB2_1
	movq	4096(%r14), %rdx
	movq	4104(%r14), %rax
	movq	(%rax), %rdi
	movq	%r14, %rsi
	callq	write@PLT
	movq	$0, 4096(%r14)
	movq	4104(%r14), %rax
	movq	(%rax), %rdi
	movq	%r15, %rsi
	movq	%rbx, %rdx
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	write@PLT
.LBB2_1:
	.cfi_def_cfa_offset 48
	movq	4096(%r14), %rdx
	leaq	(%rdx,%rbx), %rax
	cmpq	$4097, %rax
	jl	.LBB2_3
	movq	4104(%r14), %rax
	movq	(%rax), %rdi
	movq	%r14, %rsi
	callq	write@PLT
	movq	$0, 4096(%r14)
	xorl	%edx, %edx
.LBB2_3:
	movq	%rbx, %rax
	subq	$1, %rax
	jae	.LBB2_4
.LBB2_15:
	addq	%rbx, 4096(%r14)
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.LBB2_4:
	.cfi_def_cfa_offset 48
	addq	%r14, %rdx
	cmpq	$4, %rbx
	jg	.LBB2_7
	movzbl	(%r15), %ecx
	movb	%cl, (%rdx)
	movzbl	(%r15,%rax), %ecx
	movb	%cl, (%rdx,%rax)
	cmpq	$3, %rbx
	jl	.LBB2_15
	movzbl	1(%r15), %eax
	movb	%al, 1(%rdx)
	movzbl	-2(%r15,%rbx), %eax
	movb	%al, -2(%rdx,%rbx)
	jmp	.LBB2_15
.LBB2_7:
	cmpq	$16, %rbx
	ja	.LBB2_11
	cmpq	$8, %rbx
	jb	.LBB2_10
	movq	(%r15), %rax
	movq	%rax, (%rdx)
	movq	-8(%r15,%rbx), %rax
	movq	%rax, -8(%rdx,%rbx)
	jmp	.LBB2_15
.LBB2_11:
	movabsq	$9223372036854775776, %r12
	andq	%rbx, %r12
	je	.LBB2_13
	movq	%rdx, %rdi
	movq	%r15, %rsi
	movq	%rdx, %r13
	movq	%r12, %rdx
	callq	memcpy@PLT
	movq	%r13, %rdx
.LBB2_13:
	cmpq	%rbx, %r12
	je	.LBB2_15
	addq	%r12, %rdx
	addq	%r12, %r15
	movl	%ebx, %eax
	andl	$31, %eax
	movq	%rdx, %rdi
	movq	%r15, %rsi
	movq	%rax, %rdx
	callq	memcpy@PLT
	jmp	.LBB2_15
.LBB2_10:
	movl	(%r15), %eax
	movl	%eax, (%rdx)
	movl	-4(%r15,%rbx), %eax
	movl	%eax, -4(%rdx,%rbx)
	jmp	.LBB2_15
.Lfunc_end2:
	.size	"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096", .Lfunc_end2-"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096"
	.cfi_endproc

	.prefalign	4, .Lfunc_end3, nop
	.type	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=f32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]",@function
"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=f32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]":
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rdi, 8(%rsp)
	vmovd	%xmm0, %eax
	movl	%eax, %ecx
	andl	$8388607, %ecx
	movl	%eax, %edx
	shrl	$23, %edx
	movzbl	%dl, %r12d
	movl	%eax, %esi
	andl	$2147483647, %esi
	testl	%ecx, %ecx
	setne	%r14b
	leaq	-150(%r12), %rdi
	leal	(%rcx,%rcx), %r8d
	testl	%r12d, %r12d
	sete	%dl
	movq	$-149, %r13
	cmovneq	%rdi, %r13
	leal	16777216(%rcx,%rcx), %r15d
	cmovel	%r8d, %r15d
	leal	-154(%r12), %edi
	xorl	%ebx, %ebx
	cmpl	$-2, %edi
	setb	%dil
	cmpl	$2139095040, %esi
	jne	.LBB3_8
	testl	%eax, %eax
	js	.LBB3_2
	movq	8(%rsp), %rbx
	movq	4096(%rbx), %rdx
	leaq	3(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_7
	movq	4104(%rbx), %rax
	movq	(%rax), %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	$0, 4096(%rbx)
	xorl	%edx, %edx
.LBB3_7:
	movw	$28265, (%rbx,%rdx)
	movb	$102, 2(%rbx,%rdx)
	addq	$3, 4096(%rbx)
	jmp	.LBB3_112
.LBB3_8:
	vucomiss	%xmm0, %xmm0
	jp	.LBB3_113
	movl	%r12d, %esi
	orl	%ecx, %esi
	je	.LBB3_10
	orb	%dl, %r14b
	testl	%eax, %eax
	js	.LBB3_19
	leaq	global_constant(%rip), %rax
	testb	%r14b, %r14b
	je	.LBB3_23
.LBB3_26:
	imulq	$315653, %r13, %r14
	sarq	$20, %r14
	movl	$1, %r8d
	movl	$1, %ecx
	subq	%r14, %rcx
	imulq	$1741647, %rcx, %rsi
	sarq	$19, %rsi
	addq	%r13, %rsi
	movl	$32, %edx
	movq	%rsi, %rbx
	negq	%rbx
	subq	%r14, %rdx
	leal	1(%r15), %ecx
	shlxl	%esi, %ecx, %ecx
	leal	-1(%r15), %r11d
	movl	$63, %edi
	movq	(%rax,%rdx,8), %r10
	movq	%rdx, %rax
	shlq	$4, %rax
	leaq	global_constant_0(%rip), %rdx
	addq	%rax, %rdx
	movl	$64, %r9d
	leaq	1(%r14), %rax
	subq	%rsi, %rdi
	subq	%rsi, %r9
	shrxq	%rdi, %r10, %rdi
	movl	%r10d, %r12d
	shrq	$32, %r10
	imulq	%rcx, %r10
	imulq	%rcx, %r12
	shrq	$32, %r12
	addq	%r10, %r12
	shrq	$32, %r12
	imulq	$1374389535, %r12, %r10
	shrq	$37, %r10
	imull	$-100, %r10d, %ecx
	addl	%r12d, %ecx
	cmpl	%edi, %ecx
	jae	.LBB3_28
.LBB3_27:
	imull	$184254097, %r10d, %ecx
	shrdl	$4, %r10d, %ecx
	xorl	%edx, %edx
	cmpl	$429497, %ecx
	setb	%dl
	cmovael	%r10d, %ecx
	imull	$42949673, %ecx, %esi
	shrdl	$2, %ecx, %esi
	xorl	%r8d, %r8d
	cmpl	$42949673, %esi
	setb	%r8b
	cmovael	%ecx, %esi
	imull	$1288490189, %esi, %edi
	shrdl	$1, %esi, %edi
	addl	%r8d, %r8d
	cmpl	$429496730, %edi
	leal	(%r8,%rdx,4), %r14d
	cmovael	%esi, %edi
	adcq	%rax, %r14
	movq	8(%rsp), %r13
	jmp	.LBB3_33
.LBB3_2:
	movq	8(%rsp), %rbx
	movq	4096(%rbx), %rdx
	leaq	4(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_4
	movq	4104(%rbx), %rax
	movq	(%rax), %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	$0, 4096(%rbx)
	xorl	%edx, %edx
.LBB3_4:
	movl	$1718511917, (%rbx,%rdx)
	addq	$4, 4096(%rbx)
	jmp	.LBB3_112
.LBB3_10:
	testl	%eax, %eax
	js	.LBB3_11
	movq	8(%rsp), %rbx
	movq	4096(%rbx), %rdx
	leaq	3(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_16
.LBB3_15:
	movq	4104(%rbx), %rax
	movq	(%rax), %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	$0, 4096(%rbx)
	xorl	%edx, %edx
.LBB3_16:
	movw	$11824, (%rbx,%rdx)
	movb	$48, 2(%rbx,%rdx)
	addq	$3, 4096(%rbx)
	jmp	.LBB3_112
.LBB3_19:
	movq	8(%rsp), %rbp
	movq	4096(%rbp), %rdx
	leaq	1(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_21
	movq	4104(%rbp), %rax
	movb	%dil, 64(%rsp)
	movq	(%rax), %rdi
	movq	%rbp, %rsi
	callq	write@PLT
	movzbl	64(%rsp), %edi
	movq	$0, 4096(%rbp)
	xorl	%edx, %edx
.LBB3_21:
	movb	$45, (%rbp,%rdx)
	incq	4096(%rbp)
	leaq	global_constant(%rip), %rax
	testb	%r14b, %r14b
	jne	.LBB3_26
.LBB3_23:
	imulq	$631305, %r12, %r14
	addq	$-94957413, %r14
	sarq	$21, %r14
	imulq	$-1741647, %r14, %rcx
	sarq	$19, %rcx
	addq	%r12, %rcx
	addq	$-150, %rcx
	movl	$31, %edx
	movl	$40, %esi
	subq	%r14, %rdx
	subq	%rcx, %rsi
	movb	%dil, %bl
	movq	(%rax,%rdx,8), %rax
	movq	%rax, %rdx
	shrq	$25, %rdx
	movq	%rax, %rdi
	subq	%rdx, %rdi
	shrxq	%rsi, %rdi, %rdx
	movq	%rax, %rdi
	shrq	$24, %rdi
	addq	%rax, %rdi
	shrxq	%rsi, %rdi, %rsi
	addl	%ebx, %edx
	movl	%esi, %esi
	imulq	$429496730, %rsi, %rsi
	shrq	$32, %rsi
	leal	(%rsi,%rsi), %edi
	leal	(%rdi,%rdi,4), %edi
	cmpl	%edx, %edi
	movq	8(%rsp), %r13
	jae	.LBB3_24
	movl	$39, %esi
	subq	%rcx, %rsi
	shrxq	%rsi, %rax, %rdi
	incl	%edi
	shrl	%edi
	cmpl	%edx, %edi
	adcl	$0, %edi
	jmp	.LBB3_33
.LBB3_28:
	shlxq	%rbx, %r8, %r8
	jne	.LBB3_31
	movq	(%rdx), %rbx
	movq	8(%rdx), %r13
	imulq	%r11, %r13
	movl	%ebx, %r12d
	shrq	$32, %rbx
	imulq	%r11, %rbx
	imulq	%r11, %r12
	movq	%r12, %rbp
	shrq	$32, %rbp
	movl	%ebx, %r11d
	addq	%rbp, %r11
	movq	%r11, %rbp
	shrq	$32, %rbp
	shrq	$32, %rbx
	addq	%r13, %rbx
	addq	%rbp, %rbx
	testq	%r8, %rbx
	jne	.LBB3_27
	shlq	$32, %r11
	movl	%r12d, %r12d
	orq	%r11, %r12
	shlxq	%rsi, %rbx, %rsi
	shrxq	%r9, %r12, %r9
	orq	%rsi, %r9
	testq	%r9, %r9
	je	.LBB3_27
.LBB3_31:
	leal	(%r10,%r10,4), %eax
	shrl	%edi
	subl	%edi, %ecx
	imull	$6554, %ecx, %esi
	addl	$32770, %esi
	movzwl	%si, %r9d
	shrl	$16, %esi
	leal	(%rsi,%rax,2), %edi
	cmpl	$6553, %r9d
	movq	8(%rsp), %r13
	ja	.LBB3_33
	movq	(%rdx), %rax
	movq	8(%rdx), %rdx
	imulq	%r15, %rdx
	movl	%eax, %esi
	shrq	$32, %rax
	imulq	%r15, %rax
	imulq	%r15, %rsi
	shrq	$32, %rsi
	movl	%eax, %r9d
	andl	$-2, %r9d
	addq	%rsi, %r9
	shrq	$32, %r9
	shrq	$32, %rax
	addq	%rdx, %rax
	addq	%r9, %rax
	testq	%r8, %rax
	setne	%al
	xorb	%cl, %al
	movzbl	%al, %eax
	andl	$1, %eax
	subl	%eax, %edi
	jmp	.LBB3_33
.LBB3_24:
	incq	%r14
	imull	$184254097, %esi, %eax
	shrdl	$4, %esi, %eax
	xorl	%ecx, %ecx
	cmpl	$429497, %eax
	setb	%cl
	cmovael	%esi, %eax
	imull	$42949673, %eax, %edx
	shrdl	$2, %eax, %edx
	xorl	%esi, %esi
	cmpl	$42949673, %edx
	setb	%sil
	cmovael	%eax, %edx
	imull	$1288490189, %edx, %edi
	shrdl	$1, %edx, %edi
	addl	%esi, %esi
	cmpl	$429496730, %edi
	leal	(%rsi,%rcx,4), %eax
	cmovael	%edx, %edi
	adcq	%rax, %r14
.LBB3_33:
	movabsq	$2305843009213693952, %r11
	movq	%r14, %r15
	negq	%r15
	cmovsq	%r14, %r15
	xorl	%ebp, %ebp
	testl	%edi, %edi
	je	.LBB3_38
	leaq	static_string_ffe5c571af8dd3fc(%rip), %rax
	leaq	static_string_a0fcf35b7349c924(%rip), %rcx
	movl	$3435973837, %edx
	movl	%edi, %esi
	.p2align	4
.LBB3_35:
	movq	$6, 24(%rsp)
	movq	%rax, 16(%rsp)
	movq	%r11, 32(%rsp)
	movq	$39, 48(%rsp)
	movq	%rcx, 40(%rsp)
	movq	%r11, 56(%rsp)
	cmpq	$21, %rbp
	je	.LBB3_36
	movl	%esi, %r8d
	imulq	%rdx, %r8
	shrq	$35, %r8
	leal	(%r8,%r8), %r9d
	leal	(%r9,%r9,4), %r9d
	movl	%esi, %r10d
	subl	%r9d, %r10d
	movb	%r10b, 83(%rsp,%rbp)
	incq	%rbp
	cmpl	$10, %esi
	sbbq	$-1, %r14
	cmpl	$9, %esi
	movl	%r8d, %esi
	ja	.LBB3_35
.LBB3_38:
	leaq	-1(%rbp), %r12
	movq	%r15, %rcx
	subq	%rbp, %rcx
	testq	%r14, %r14
	sets	%al
	movq	%rcx, 72(%rsp)
	cmpq	$4, %rcx
	setge	%cl
	cmpq	$15, %r14
	jg	.LBB3_40
	andb	%cl, %al
	jne	.LBB3_40
	testq	%r14, %r14
	sets	%al
	cmpq	$0, 72(%rsp)
	setg	%cl
	testb	%cl, %al
	je	.LBB3_97
	movq	4096(%r13), %rdx
	leaq	2(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_102
	movq	4104(%r13), %rax
	movq	(%rax), %rdi
	movq	%r13, %rsi
	callq	write@PLT
	movq	$0, 4096(%r13)
	xorl	%edx, %edx
.LBB3_102:
	movw	$11824, (%r13,%rdx)
	movq	4096(%r13), %rdx
	addq	$2, %rdx
	movq	%rdx, 4096(%r13)
	jmp	.LBB3_103
	.p2align	4
.LBB3_105:
	movb	$48, (%r13,%rdx)
	movq	4096(%r13), %rdx
	incq	%rdx
	movq	%rdx, 4096(%r13)
	decq	%r15
	cmpq	%r15, %rbp
	je	.LBB3_106
.LBB3_103:
	leaq	1(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_105
	movq	4104(%r13), %rax
	movq	(%rax), %rdi
	movq	%r13, %rsi
	callq	write@PLT
	movq	$0, 4096(%r13)
	xorl	%edx, %edx
	jmp	.LBB3_105
.LBB3_40:
	cmpl	$9, %edi
	ja	.LBB3_42
	movq	%r12, %rbx
	movq	%r13, %rsi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"@PLT
	cmpq	$2, %rbp
	jae	.LBB3_49
	jmp	.LBB3_55
.LBB3_42:
	movq	$6, 24(%rsp)
	leaq	static_string_ffe5c571af8dd3fc(%rip), %rax
	movq	%rax, 16(%rsp)
	movq	%r11, 32(%rsp)
	movq	$39, 48(%rsp)
	leaq	static_string_a0fcf35b7349c924(%rip), %rax
	movq	%rax, 40(%rsp)
	movq	%r11, 56(%rsp)
	cmpq	$21, %r12
	jae	.LBB3_43
	movq	%r12, %rbx
	movzbl	83(%rsp,%r12), %edi
	movq	%r13, %rsi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"@PLT
	movq	4096(%r13), %rdx
	leaq	1(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_47
	movq	4104(%r13), %rax
	movq	(%rax), %rdi
	movq	%r13, %rsi
	callq	write@PLT
	movq	$0, 4096(%r13)
	xorl	%edx, %edx
.LBB3_47:
	movb	$46, (%r13,%rdx)
	incq	4096(%r13)
	cmpq	$2, %rbp
	jb	.LBB3_55
.LBB3_49:
	movq	%rbx, %rax
	sarq	$63, %rax
	andnq	%rbx, %rax, %r9
	decq	%r9
	xorl	%ebx, %ebx
	cmpq	$3, %rbp
	setge	%bl
	movq	%r9, %rax
	subq	%rbx, %rax
	leaq	static_string_ffe5c571af8dd3fc(%rip), %r15
	leaq	static_string_a0fcf35b7349c924(%rip), %r12
	.p2align	4
.LBB3_50:
	movq	%rax, %r13
	movq	$6, 24(%rsp)
	movq	%r15, 16(%rsp)
	movabsq	$2305843009213693952, %rax
	movq	%rax, 32(%rsp)
	movq	$39, 48(%rsp)
	movq	%r12, 40(%rsp)
	movq	%rax, 56(%rsp)
	cmpq	$21, %r9
	jae	.LBB3_51
	movzbl	83(%rsp,%r9), %edi
	movq	8(%rsp), %rsi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"@PLT
	testq	%r13, %r13
	setg	%cl
	movl	%ebx, %eax
	andb	%cl, %al
	movzbl	%al, %edx
	movq	%r13, %rax
	subq	%rdx, %rax
	movq	%r13, %r9
	testb	$1, %bl
	movl	%ecx, %ebx
	jne	.LBB3_50
.LBB3_55:
	testq	%r14, %r14
	js	.LBB3_56
	movq	8(%rsp), %r13
	movq	4096(%r13), %rdx
	leaq	2(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_61
	movq	4104(%r13), %rax
	movq	(%rax), %rdi
	movq	%r13, %rsi
	callq	write@PLT
	movq	$0, 4096(%r13)
	xorl	%edx, %edx
.LBB3_61:
	movw	$11109, (%r13,%rdx)
	movq	4096(%r13), %rdx
	addq	$2, %rdx
	movq	%rdx, 4096(%r13)
	cmpq	$10, %r14
	jl	.LBB3_63
	jmp	.LBB3_66
.LBB3_97:
	testq	%rbp, %rbp
	je	.LBB3_98
	xorl	%ebx, %ebx
	movq	%rbp, %rax
	subq	$2, %rax
	movq	%rax, 112(%rsp)
	setge	%bl
	movq	%r12, %rax
	subq	%rbx, %rax
	xorl	%r13d, %r13d
	.p2align	4
.LBB3_84:
	movq	%rax, 64(%rsp)
	cmpq	$0, 72(%rsp)
	setle	%al
	movq	112(%rsp), %rcx
	subq	%r12, %rcx
	cmpq	%rcx, %r14
	sete	%r15b
	andb	%al, %r15b
	cmpb	$1, %r15b
	jne	.LBB3_94
	movq	8(%rsp), %rax
	movq	4096(%rax), %rdx
	leaq	-1(%rbp), %rax
	cmpq	%rax, %r12
	movq	%r13, 104(%rsp)
	jne	.LBB3_90
	leaq	1(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_87
	movq	8(%rsp), %r13
	movq	4104(%r13), %rax
	movq	(%rax), %rdi
	movq	%r13, %rsi
	callq	write@PLT
	movq	$0, 4096(%r13)
	xorl	%edx, %edx
	jmp	.LBB3_89
.LBB3_87:
	movq	8(%rsp), %r13
.LBB3_89:
	movb	$48, (%r13,%rdx)
	movq	4096(%r13), %rdx
	incq	%rdx
	movq	%rdx, 4096(%r13)
.LBB3_90:
	leaq	1(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_91
	movq	8(%rsp), %r13
	movq	4104(%r13), %rax
	movq	(%rax), %rdi
	movq	%r13, %rsi
	callq	write@PLT
	movq	$0, 4096(%r13)
	xorl	%edx, %edx
	jmp	.LBB3_93
	.p2align	4
.LBB3_91:
	movq	8(%rsp), %r13
.LBB3_93:
	movb	$46, (%r13,%rdx)
	incq	4096(%r13)
	movq	104(%rsp), %r13
.LBB3_94:
	movq	$6, 24(%rsp)
	leaq	static_string_ffe5c571af8dd3fc(%rip), %rax
	movq	%rax, 16(%rsp)
	movabsq	$2305843009213693952, %rax
	movq	%rax, 32(%rsp)
	movq	$39, 48(%rsp)
	leaq	static_string_a0fcf35b7349c924(%rip), %rcx
	movq	%rcx, 40(%rsp)
	movq	%rax, 56(%rsp)
	cmpq	$21, %r12
	jae	.LBB3_95
	orb	%r15b, %r13b
	movzbl	83(%rsp,%r12), %edi
	movq	8(%rsp), %rsi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"@PLT
	movq	64(%rsp), %r12
	testq	%r12, %r12
	setg	%cl
	movl	%ebx, %eax
	andb	%cl, %al
	movzbl	%al, %edx
	movq	%r12, %rax
	subq	%rdx, %rax
	testb	$1, %bl
	movl	%ecx, %ebx
	jne	.LBB3_84
	jmp	.LBB3_74
.LBB3_106:
	testq	%rbp, %rbp
	je	.LBB3_112
	movq	%r12, %rdx
	xorl	%ebx, %ebx
	cmpq	$2, %rbp
	setge	%bl
	movq	%r12, %rax
	subq	%rbx, %rax
	leaq	static_string_ffe5c571af8dd3fc(%rip), %r14
	leaq	static_string_a0fcf35b7349c924(%rip), %r15
	.p2align	4
.LBB3_108:
	movq	%rax, %r12
	movq	$6, 24(%rsp)
	movq	%r14, 16(%rsp)
	movabsq	$2305843009213693952, %rax
	movq	%rax, 32(%rsp)
	movq	$39, 48(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 56(%rsp)
	cmpq	$21, %rdx
	jae	.LBB3_109
	movzbl	83(%rsp,%rdx), %edi
	movq	%r13, %rsi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"@PLT
	testq	%r12, %r12
	setg	%cl
	movl	%ebx, %eax
	andb	%cl, %al
	movzbl	%al, %edx
	movq	%r12, %rax
	subq	%rdx, %rax
	movq	%r12, %rdx
	testb	$1, %bl
	movl	%ecx, %ebx
	jne	.LBB3_108
	jmp	.LBB3_112
.LBB3_11:
	movq	8(%rsp), %rbx
	movq	4096(%rbx), %rdx
	leaq	1(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_13
	movq	4104(%rbx), %rax
	movq	(%rax), %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	$0, 4096(%rbx)
	xorl	%edx, %edx
.LBB3_13:
	movb	$45, (%rbx,%rdx)
	movq	4096(%rbx), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, 4096(%rbx)
	addq	$4, %rax
	cmpq	$4097, %rax
	jge	.LBB3_15
	jmp	.LBB3_16
.LBB3_56:
	movq	8(%rsp), %r13
	movq	4096(%r13), %rdx
	leaq	2(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_58
	movq	4104(%r13), %rax
	movq	(%rax), %rdi
	movq	%r13, %rsi
	callq	write@PLT
	movq	$0, 4096(%r13)
	xorl	%edx, %edx
.LBB3_58:
	movw	$11621, (%r13,%rdx)
	movq	4096(%r13), %rdx
	addq	$2, %rdx
	movq	%rdx, 4096(%r13)
	negq	%r14
	cmpq	$10, %r14
	jge	.LBB3_66
.LBB3_63:
	leaq	1(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_65
	movq	4104(%r13), %rax
	movq	(%rax), %rdi
	movq	%r13, %rsi
	callq	write@PLT
	movq	$0, 4096(%r13)
	xorl	%edx, %edx
.LBB3_65:
	movb	$48, (%r13,%rdx)
	incq	4096(%r13)
	testq	%r14, %r14
	jle	.LBB3_112
.LBB3_66:
	movq	$-1, %r9
	leaq	static_string_ffe5c571af8dd3fc(%rip), %rbx
	leaq	static_string_a0fcf35b7349c924(%rip), %r15
	movabsq	$-3689348814741910323, %rax
	movabsq	$2305843009213693952, %rsi
	.p2align	4
.LBB3_67:
	movq	$6, 24(%rsp)
	movq	%rbx, 16(%rsp)
	movq	%rsi, 32(%rsp)
	movq	$39, 48(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rsi, 56(%rsp)
	cmpq	$9, %r9
	je	.LBB3_68
	movq	%r14, %rdx
	mulxq	%rax, %rcx, %rcx
	shrq	$3, %rcx
	imull	$246, %ecx, %edx
	addl	%r14d, %edx
	movb	%dl, 84(%rsp,%r9)
	incq	%r9
	cmpq	$9, %r14
	movq	%rcx, %r14
	ja	.LBB3_67
	xorl	%r14d, %r14d
	testq	%r9, %r9
	setne	%r14b
	movq	%r9, %rax
	subq	%r14, %rax
	.p2align	4
.LBB3_71:
	movq	%rax, %r12
	movq	$6, 24(%rsp)
	movq	%rbx, 16(%rsp)
	movabsq	$2305843009213693952, %rax
	movq	%rax, 32(%rsp)
	movq	$39, 48(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 56(%rsp)
	cmpq	$10, %r9
	jae	.LBB3_72
	movzbl	83(%rsp,%r9), %edi
	movq	%r13, %rsi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"@PLT
	testq	%r12, %r12
	setg	%cl
	movl	%r14d, %eax
	andb	%cl, %al
	movzbl	%al, %edx
	movq	%r12, %rax
	subq	%rdx, %rax
	movq	%r12, %r9
	testb	$1, %r14b
	movl	%ecx, %r14d
	jne	.LBB3_71
	jmp	.LBB3_112
.LBB3_98:
	xorl	%r13d, %r13d
.LBB3_74:
	subq	%rbp, %r14
	movabsq	$9223372036854775806, %rax
	cmpq	%rax, %r14
	movq	8(%rsp), %rbx
	ja	.LBB3_79
	movq	4096(%rbx), %rdx
	incq	%r14
	jmp	.LBB3_76
	.p2align	4
.LBB3_78:
	movb	$48, (%rbx,%rdx)
	movq	4096(%rbx), %rdx
	incq	%rdx
	movq	%rdx, 4096(%rbx)
	decq	%r14
	je	.LBB3_79
.LBB3_76:
	leaq	1(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_78
	movq	4104(%rbx), %rax
	movq	(%rax), %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	$0, 4096(%rbx)
	xorl	%edx, %edx
	jmp	.LBB3_78
.LBB3_79:
	testb	$1, %r13b
	jne	.LBB3_112
	movq	4096(%rbx), %rdx
	leaq	2(%rdx), %rax
	cmpq	$4097, %rax
	jl	.LBB3_82
	movq	4104(%rbx), %rax
	movq	(%rax), %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	$0, 4096(%rbx)
	xorl	%edx, %edx
.LBB3_82:
	movw	$12334, (%rbx,%rdx)
	addq	$2, 4096(%rbx)
.LBB3_112:
	addq	$120, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB3_36:
	.cfi_def_cfa_offset 176
	leaq	40(%rsp), %rax
	leaq	static_string_422d2414495ed121(%rip), %rdx
	leaq	16(%rsp), %r8
	movl	$257, %edi
	movl	$19, %esi
	movl	$42, %ecx
	movl	$21, %r9d
	pushq	$20
	.cfi_adjust_cfa_offset 8
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	callq	"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]"@PLT
.LBB3_68:
	.cfi_def_cfa_offset 176
	leaq	40(%rsp), %rax
	leaq	static_string_422d2414495ed121(%rip), %rdx
	leaq	16(%rsp), %r8
	movl	$288, %edi
	movl	$27, %esi
	movl	$42, %ecx
	movl	$10, %r9d
	pushq	$9
	.cfi_adjust_cfa_offset 8
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	callq	"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]"@PLT
.LBB3_72:
	.cfi_def_cfa_offset 176
	leaq	40(%rsp), %rax
	leaq	static_string_422d2414495ed121(%rip), %rdx
	leaq	16(%rsp), %r8
	movl	$292, %edi
	movl	$40, %esi
	movl	$42, %ecx
	pushq	$9
	.cfi_adjust_cfa_offset 8
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	callq	"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]"@PLT
.LBB3_51:
	.cfi_def_cfa_offset 176
	leaq	40(%rsp), %rax
	leaq	static_string_422d2414495ed121(%rip), %rdx
	leaq	16(%rsp), %r8
	movl	$275, %edi
	jmp	.LBB3_52
.LBB3_95:
	leaq	40(%rsp), %rax
	leaq	static_string_422d2414495ed121(%rip), %rdx
	leaq	16(%rsp), %r8
	movl	$310, %edi
.LBB3_44:
	movl	$36, %esi
	movl	$42, %ecx
	movq	%r12, %r9
	pushq	$20
	.cfi_adjust_cfa_offset 8
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	callq	"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]"@PLT
.LBB3_109:
	.cfi_def_cfa_offset 176
	leaq	40(%rsp), %rax
	movq	%rdx, %r9
	leaq	static_string_422d2414495ed121(%rip), %rdx
	leaq	16(%rsp), %r8
	movl	$299, %edi
.LBB3_52:
	movl	$36, %esi
	movl	$42, %ecx
	pushq	$20
	.cfi_adjust_cfa_offset 8
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	callq	"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]"@PLT
.LBB3_113:
	.cfi_def_cfa_offset 176
	leaq	static_string_e5411518d45eb182(%rip), %rsi
	movl	$3, %edx
	movq	8(%rsp), %rdi
	addq	$120, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096"@PLT
.LBB3_43:
	.cfi_def_cfa_offset 176
	leaq	40(%rsp), %rax
	leaq	static_string_422d2414495ed121(%rip), %rdx
	leaq	16(%rsp), %r8
	movl	$271, %edi
	jmp	.LBB3_44
.Lfunc_end3:
	.size	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=f32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]", .Lfunc_end3-"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=f32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"
	.cfi_endproc

	.prefalign	4, .Lfunc_end4, nop
	.type	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=index,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]",@function
"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=index,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]":
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	subq	$80, %rsp
	.cfi_def_cfa_offset 128
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	testq	%rdi, %rdi
	je	.LBB4_1
	movq	2048(%rsi), %rbx
	jns	.LBB4_7
	leaq	1(%rbx), %rax
	cmpq	$2049, %rax
	jge	.LBB4_28
	movb	$45, (%rsi,%rbx)
	movq	2048(%rsi), %rbx
	incq	%rbx
	movq	%rbx, 2048(%rsi)
.LBB4_7:
	cmpq	$2049, %rbx
	jge	.LBB4_28
	movb	$0, 79(%rsp)
	movl	$63, %ecx
	testq	%rdi, %rdi
	js	.LBB4_9
	leaq	static_string_978d8d34847e5196(%rip), %rax
	movabsq	$-3689348814741910323, %r8
	.p2align	4
.LBB4_12:
	movq	%rdi, %rdx
	mulxq	%r8, %rdx, %rdx
	shrq	$3, %rdx
	leaq	(%rdx,%rdx), %r9
	leaq	(%r9,%r9,4), %r9
	movq	%rdi, %r10
	subq	%r9, %r10
	movzbl	(%rax,%r10), %r9d
	movb	%r9b, 15(%rsp,%rcx)
	decq	%rcx
	cmpq	$10, %rdi
	movq	%rdx, %rdi
	jae	.LBB4_12
	jmp	.LBB4_13
.LBB4_1:
	movq	2048(%rsi), %rax
	cmpq	$2048, %rax
	jg	.LBB4_28
	je	.LBB4_28
	movb	$48, (%rsi,%rax)
	incq	2048(%rsi)
	jmp	.LBB4_27
.LBB4_9:
	movabsq	$7378697629483820647, %r8
	leaq	static_string_978d8d34847e5196(%rip), %r9
	movabsq	$-7378697629483820647, %r10
	.p2align	4
.LBB4_10:
	movq	%rdi, %rax
	imulq	%r8
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$2, %rdx
	addq	%rax, %rdx
	addq	%rdx, %rdx
	leaq	(%rdx,%rdx,4), %rax
	movq	%rdi, %rdx
	subq	%rax, %rdx
	testq	%rdi, %rdi
	setns	%r11b
	testq	%rdx, %rdx
	movq	$-10, %rax
	cmoveq	%rdx, %rax
	movq	%rdi, %r14
	sarq	$63, %r14
	andnq	%rax, %r14, %rax
	addq	%rdx, %rax
	movq	%rax, %rdx
	negq	%rdx
	cmovsq	%rax, %rdx
	movzbl	(%rdx,%r9), %eax
	movb	%al, 15(%rsp,%rcx)
	decq	%rcx
	movq	%rdi, %rax
	imulq	%r10
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$2, %rdx
	addq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	leaq	(%rax,%rax,4), %rax
	addq	%rdi, %rax
	setne	%al
	andb	%r11b, %al
	movzbl	%al, %edi
	subq	%rdx, %rdi
	jne	.LBB4_10
.LBB4_13:
	movl	$63, %r14d
	subq	%rcx, %r14
	leaq	(%r14,%rbx), %rax
	cmpq	$2049, %rax
	jge	.LBB4_28
	cmpq	$63, %rcx
	jne	.LBB4_15
.LBB4_26:
	addq	%r14, 2048(%rsi)
.LBB4_27:
	addq	$80, %rsp
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.LBB4_15:
	.cfi_def_cfa_offset 128
	leaq	(%rsp,%rcx), %r15
	addq	$15, %r15
	leaq	(%rsp,%rcx), %rax
	addq	$16, %rax
	addq	%rsi, %rbx
	cmpq	$4, %r14
	jg	.LBB4_18
	movl	$62, %edx
	subq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rbx)
	movzbl	78(%rsp), %eax
	movb	%al, (%rbx,%rdx)
	cmpq	$3, %r14
	jl	.LBB4_26
	movl	$61, %eax
	subq	%rcx, %rax
	movzbl	2(%r15), %ecx
	movb	%cl, 1(%rbx)
	movzbl	77(%rsp), %ecx
	movb	%cl, (%rbx,%rax)
	jmp	.LBB4_26
.LBB4_18:
	cmpq	$16, %r14
	ja	.LBB4_22
	cmpq	$8, %r14
	jb	.LBB4_21
	movl	$55, %edx
	subq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rbx)
	movq	71(%rsp), %rax
	movq	%rax, (%rbx,%rdx)
	jmp	.LBB4_26
.LBB4_22:
	movabsq	$9223372036854775776, %r12
	andq	%r14, %r12
	je	.LBB4_24
	movl	$31, %edx
	subq	%rcx, %rdx
	andq	$-32, %rdx
	addq	$32, %rdx
	movq	%rbx, %rdi
	movq	%rsi, %r13
	movq	%rax, %rsi
	callq	memcpy@PLT
	movq	%r13, %rsi
.LBB4_24:
	cmpq	%r14, %r12
	je	.LBB4_26
	addq	%r12, %rbx
	leaq	(%r15,%r12), %rax
	incq	%rax
	movl	%r14d, %edx
	andl	$31, %edx
	movq	%rbx, %rdi
	movq	%rsi, %rbx
	movq	%rax, %rsi
	callq	memcpy@PLT
	movq	%rbx, %rsi
	jmp	.LBB4_26
.LBB4_21:
	movl	$59, %edx
	subq	%rcx, %rdx
	movl	(%rax), %eax
	movl	%eax, (%rbx)
	movl	75(%rsp), %eax
	movl	%eax, (%rbx,%rdx)
	jmp	.LBB4_26
.LBB4_28:
	callq	"std::format::_utils::_fixed_buffer_exceeded()"@PLT
.Lfunc_end4:
	.size	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=index,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]", .Lfunc_end4-"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=index,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]"
	.cfi_endproc

	.prefalign	4, .Lfunc_end5, nop
	.type	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]",@function
"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]":
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$72, %rsp
	.cfi_def_cfa_offset 96
	.cfi_offset %rbx, -24
	.cfi_offset %rbp, -16
	movq	%rsi, %rbx
	movq	4096(%rsi), %rdx
	testl	%edi, %edi
	je	.LBB5_1
	cmpq	$4097, %rdx
	jl	.LBB5_6
	movq	4104(%rbx), %rax
	movq	(%rax), %rax
	movl	%edi, %ebp
	movq	%rax, %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movl	%ebp, %edi
	movq	$0, 4096(%rbx)
.LBB5_6:
	movb	$0, 71(%rsp)
	xorl	%edx, %edx
	movl	$3435973837, %eax
	leaq	static_string_978d8d34847e5196(%rip), %rcx
	.p2align	4
.LBB5_7:
	movl	%edi, %esi
	imulq	%rax, %rsi
	shrq	$35, %rsi
	leal	(%rsi,%rsi), %r8d
	leal	(%r8,%r8,4), %r8d
	movl	%edi, %r9d
	subl	%r8d, %r9d
	movzbl	(%r9,%rcx), %r8d
	movb	%r8b, 70(%rsp,%rdx)
	decq	%rdx
	cmpl	$9, %edi
	movl	%esi, %edi
	ja	.LBB5_7
	leaq	(%rsp,%rdx), %rsi
	addq	$71, %rsi
	negq	%rdx
	movq	%rbx, %rdi
	callq	"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096"@PLT
	addq	$72, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB5_1:
	.cfi_def_cfa_offset 96
	cmpq	$4097, %rdx
	setl	%al
	cmpq	$4096, %rdx
	setne	%cl
	testb	%cl, %al
	jne	.LBB5_3
	movq	4104(%rbx), %rax
	movq	(%rax), %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	$0, 4096(%rbx)
	xorl	%edx, %edx
.LBB5_3:
	movb	$48, (%rbx,%rdx)
	incq	4096(%rbx)
	addq	$72, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]", .Lfunc_end5-"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"
	.cfi_endproc

	.prefalign	4, .Lfunc_end6, nop
	.type	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]",@function
"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]":
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$72, %rsp
	.cfi_def_cfa_offset 96
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rsi, %rbx
	movq	4096(%rsi), %rdx
	testb	%dil, %dil
	je	.LBB6_1
	cmpq	$4097, %rdx
	jl	.LBB6_6
	movq	4104(%rbx), %rax
	movq	(%rax), %rax
	movq	%rdi, %r14
	movq	%rax, %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	%r14, %rdi
	movq	$0, 4096(%rbx)
.LBB6_6:
	movb	$0, 71(%rsp)
	xorl	%edx, %edx
	leaq	static_string_978d8d34847e5196(%rip), %rax
	.p2align	4
.LBB6_7:
	movzbl	%dil, %ecx
	imull	$205, %ecx, %edi
	shrl	$11, %edi
	leal	(%rdi,%rdi), %esi
	leal	(%rsi,%rsi,4), %esi
	movl	%ecx, %r8d
	subb	%sil, %r8b
	movzbl	%r8b, %esi
	movzbl	(%rsi,%rax), %esi
	movb	%sil, 70(%rsp,%rdx)
	decq	%rdx
	cmpb	$9, %cl
	ja	.LBB6_7
	leaq	(%rsp,%rdx), %rsi
	addq	$71, %rsi
	negq	%rdx
	movq	%rbx, %rdi
	callq	"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096"@PLT
	addq	$72, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.LBB6_1:
	.cfi_def_cfa_offset 96
	cmpq	$4097, %rdx
	setl	%al
	cmpq	$4096, %rdx
	setne	%cl
	testb	%cl, %al
	jne	.LBB6_3
	movq	4104(%rbx), %rax
	movq	(%rax), %rdi
	movq	%rbx, %rsi
	callq	write@PLT
	movq	$0, 4096(%rbx)
	xorl	%edx, %edx
.LBB6_3:
	movb	$48, (%rbx,%rdx)
	incq	4096(%rbx)
	addq	$72, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end6:
	.size	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]", .Lfunc_end6-"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=ui8,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"
	.cfi_endproc

	.section	.text.unlikely.,"ax",@progbits
	.prefalign	4, .Lfunc_end7, nop
	.type	"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]",@function
"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]":
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$2072, %rsp
	.cfi_def_cfa_offset 2128
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r9, %r13
	movq	%rcx, 8(%rsp)
	movq	%rdx, (%rsp)
	movq	%rsi, %r15
	movq	%rdi, %r12
	movq	2136(%rsp), %rbp
	movq	2128(%rsp), %rbx
	movq	$0, 2064(%rsp)
	leaq	16(%rsp), %r14
	movq	%r8, %rdi
	movq	%r14, %rsi
	callq	"std::collections::string::string::String::write_to[::Writer & ::AnyType](::String,$0),writer.T`2x1=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]"@PLT
	movq	%r13, %rdi
	movq	%r14, %rsi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=index,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]"@PLT
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	"std::collections::string::string::String::write_to[::Writer & ::AnyType](::String,$0),writer.T`2x1=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]"@PLT
	movq	%rbp, %rdi
	movq	%r14, %rsi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=index,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FixedWriteBuffer>>, struct<(struct<(array<2048, scalar<ui8>>) memoryOnly>, scalar<index>) memoryOnly>]"@PLT
	movq	2064(%rsp), %rax
	leaq	1(%rax), %rcx
	cmpq	$2049, %rcx
	jl	.LBB7_2
	callq	"std::format::_utils::_fixed_buffer_exceeded()"@PLT
.LBB7_2:
	movb	$0, 16(%rsp,%rax)
	incq	2064(%rsp)
	leaq	16(%rsp), %rdi
	movq	%r12, %rsi
	movq	%r15, %rdx
	movq	(%rsp), %rcx
	movq	8(%rsp), %r8
	callq	"std::builtin::debug_assert::_debug_assert_msg[LITImmOrigin,::Origin[False, $0]](::Pointer[False, $0, ::SIMD[DType.uint8, 1], $1, AddressSpace.GENERIC],::SIMD[DType.int, 1],::SourceLocation)"@PLT
.Lfunc_end7:
	.size	"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]", .Lfunc_end7-"std::builtin::debug_assert::_debug_assert_fail_format[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2]](::SourceLocation,*$0),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>]]"
	.cfi_endproc

	.prefalign	4, .Lfunc_end8, nop
	.type	"std::builtin::debug_assert::_debug_assert_msg[LITImmOrigin,::Origin[False, $0]](::Pointer[False, $0, ::SIMD[DType.uint8, 1], $1, AddressSpace.GENERIC],::SIMD[DType.int, 1],::SourceLocation)",@function
"std::builtin::debug_assert::_debug_assert_msg[LITImmOrigin,::Origin[False, $0]](::Pointer[False, $0, ::SIMD[DType.uint8, 1], $1, AddressSpace.GENERIC],::SIMD[DType.int, 1],::SourceLocation)":
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, %rax
	movl	$1, %r8d
	movq	%rcx, %rdi
	movq	%rax, %rcx
	callq	"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[[typevalue<#kgen.instref<std::ffi::cstring::CStringSpan,origin._mlir_origin`={  },origin={  }>>, pointer<none>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::memory::pointer::Pointer,mut=false,origin._mlir_origin`={  },T=[typevalue<#kgen.instref<std::simd::SIMD,dtype=ui8,length=1>>, scalar<ui8>],origin={  },address_space=0>>, pointer<none>]],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QAt: %s:%llu:%llu: Assert Error: %s\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 35 }"@PLT
	ud2
.Lfunc_end8:
	.size	"std::builtin::debug_assert::_debug_assert_msg[LITImmOrigin,::Origin[False, $0]](::Pointer[False, $0, ::SIMD[DType.uint8, 1], $1, AddressSpace.GENERIC],::SIMD[DType.int, 1],::SourceLocation)", .Lfunc_end8-"std::builtin::debug_assert::_debug_assert_msg[LITImmOrigin,::Origin[False, $0]](::Pointer[False, $0, ::SIMD[DType.uint8, 1], $1, AddressSpace.GENERIC],::SIMD[DType.int, 1],::SourceLocation)"
	.cfi_endproc

	.prefalign	4, .Lfunc_end9, nop
	.type	"std::format::_utils::_fixed_buffer_exceeded()",@function
"std::format::_utils::_fixed_buffer_exceeded()":
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$1, %edi
	callq	"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QFIXED_WRITE_BUFFER_BYTES exceeded, increase with: `mojo -D FIXED_WRITE_BUFFER_BYTES=4096`\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 90 }"@PLT
	ud2
.Lfunc_end9:
	.size	"std::format::_utils::_fixed_buffer_exceeded()", .Lfunc_end9-"std::format::_utils::_fixed_buffer_exceeded()"
	.cfi_endproc

	.text
	.prefalign	4, .Lfunc_end10, nop
	.type	"std::io::io::_flush(::FileDescriptor)",@function
"std::io::io::_flush(::FileDescriptor)":
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	callq	dup@PLT
	leaq	static_string_0d78baac08237ddb(%rip), %rsi
	movl	%eax, %edi
	callq	fdopen@PLT
	movq	%rax, %rbx
	movq	%rax, %rdi
	callq	fflush@PLT
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 8
	jmp	fclose@PLT
.Lfunc_end10:
	.size	"std::io::io::_flush(::FileDescriptor)", .Lfunc_end10-"std::io::io::_flush(::FileDescriptor)"
	.cfi_endproc

	.prefalign	4, .Lfunc_end11, nop
	.type	"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QFIXED_WRITE_BUFFER_BYTES exceeded, increase with: `mojo -D FIXED_WRITE_BUFFER_BYTES=4096`\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 90 }",@function
"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QFIXED_WRITE_BUFFER_BYTES exceeded, increase with: `mojo -D FIXED_WRITE_BUFFER_BYTES=4096`\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 90 }":
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	callq	dup@PLT
	leaq	static_string_0d78baac08237ddb(%rip), %rsi
	movl	%eax, %edi
	callq	fdopen@PLT
	movq	%rax, %rbx
	leaq	static_string_3dbcb4d72b465ec0(%rip), %rsi
	movq	%rax, %rdi
	xorl	%eax, %eax
	callq	KGEN_CompilerRT_fprintf@PLT
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 8
	jmp	fclose@PLT
.Lfunc_end11:
	.size	"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QFIXED_WRITE_BUFFER_BYTES exceeded, increase with: `mojo -D FIXED_WRITE_BUFFER_BYTES=4096`\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 90 }", .Lfunc_end11-"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QFIXED_WRITE_BUFFER_BYTES exceeded, increase with: `mojo -D FIXED_WRITE_BUFFER_BYTES=4096`\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 90 }"
	.cfi_endproc

	.prefalign	4, .Lfunc_end12, nop
	.type	"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[[typevalue<#kgen.instref<std::ffi::cstring::CStringSpan,origin._mlir_origin`={  },origin={  }>>, pointer<none>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::memory::pointer::Pointer,mut=false,origin._mlir_origin`={  },T=[typevalue<#kgen.instref<std::simd::SIMD,dtype=ui8,length=1>>, scalar<ui8>],origin={  },address_space=0>>, pointer<none>]],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QAt: %s:%llu:%llu: Assert Error: %s\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 35 }",@function
"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[[typevalue<#kgen.instref<std::ffi::cstring::CStringSpan,origin._mlir_origin`={  },origin={  }>>, pointer<none>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::memory::pointer::Pointer,mut=false,origin._mlir_origin`={  },T=[typevalue<#kgen.instref<std::simd::SIMD,dtype=ui8,length=1>>, scalar<ui8>],origin={  },address_space=0>>, pointer<none>]],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QAt: %s:%llu:%llu: Assert Error: %s\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 35 }":
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rcx, %rbx
	movq	%rdx, %r14
	movq	%rsi, %r15
	movq	%rdi, %r12
	movl	%r8d, %edi
	callq	dup@PLT
	leaq	static_string_0d78baac08237ddb(%rip), %rsi
	movl	%eax, %edi
	callq	fdopen@PLT
	movq	%rax, %r13
	leaq	static_string_0dcb71a55f79a509(%rip), %rsi
	movq	%rax, %rdi
	movq	%r12, %rdx
	movq	%r15, %rcx
	movq	%r14, %r8
	movq	%rbx, %r9
	xorl	%eax, %eax
	callq	KGEN_CompilerRT_fprintf@PLT
	movq	%r13, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	fclose@PLT
.Lfunc_end12:
	.size	"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[[typevalue<#kgen.instref<std::ffi::cstring::CStringSpan,origin._mlir_origin`={  },origin={  }>>, pointer<none>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::memory::pointer::Pointer,mut=false,origin._mlir_origin`={  },T=[typevalue<#kgen.instref<std::simd::SIMD,dtype=ui8,length=1>>, scalar<ui8>],origin={  },address_space=0>>, pointer<none>]],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QAt: %s:%llu:%llu: Assert Error: %s\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 35 }", .Lfunc_end12-"std::io::io::_printf[KGENParamList[::AnyType],::StringSpan[ImmStaticOrigin, ::Origin[False, ImmStaticOrigin]()],*::AnyType,LITImmOrigin,::Origin[False, $3]](*$0,file:::FileDescriptor),types.values`=[[typevalue<#kgen.instref<std::ffi::cstring::CStringSpan,origin._mlir_origin`={  },origin={  }>>, pointer<none>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=index,length=1>>, scalar<index>],[typevalue<#kgen.instref<std::memory::pointer::Pointer,mut=false,origin._mlir_origin`={  },T=[typevalue<#kgen.instref<std::simd::SIMD,dtype=ui8,length=1>>, scalar<ui8>],origin={  },address_space=0>>, pointer<none>]],fmt={ #interp.memref<{[(#interp.memory_handle<16, ~QAt: %s:%llu:%llu: Assert Error: %s\\0A\\00~Q string>, const_global, [], [])], []}, 0, 0>, 35 }"
	.cfi_endproc

	.prefalign	4, .Lfunc_end13, nop
	.type	"std::io::io::print[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2],LITImmOrigin,::Origin[False, $4],LITImmOrigin,::Origin[False, $6]](*$0,sep:::StringSpan[$4, $5],end:::StringSpan[$6, $7],flush:::Bool,file:::FileDescriptor$),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=f32,length=1>>, scalar<f32>]]",@function
"std::io::io::print[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2],LITImmOrigin,::Origin[False, $4],LITImmOrigin,::Origin[False, $6]](*$0,sep:::StringSpan[$4, $5],end:::StringSpan[$6, $7],flush:::Bool,file:::FileDescriptor$),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=f32,length=1>>, scalar<f32>]]":
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$4136, %rsp
	.cfi_def_cfa_offset 4192
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	%r9d, %ebx
	movq	%r8, %r14
	movq	%rcx, %r15
	movq	%rdx, %r12
	movq	%rsi, %r13
	vmovss	%xmm0, 12(%rsp)
	movq	%rdi, %rsi
	movq	4192(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	$0, 4120(%rsp)
	leaq	16(%rsp), %rax
	movq	%rax, 4128(%rsp)
	movq	16(%rdi), %rdx
	testq	%rdx, %rdx
	js	.LBB13_1
	movq	8(%rsi), %rdx
	movq	(%rsi), %rsi
	jmp	.LBB13_3
.LBB13_1:
	shrq	$56, %rdx
	andl	$31, %edx
.LBB13_3:
	leaq	24(%rsp), %rbp
	movq	%rbp, %rdi
	callq	"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096"@PLT
	movq	%rbp, %rdi
	movq	%r13, %rsi
	movq	%r12, %rdx
	callq	"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096"@PLT
	vmovss	12(%rsp), %xmm0
	movq	%rbp, %rdi
	callq	"std::simd::SIMD::write_to[::Writer & ::AnyType](::SIMD[$0, $1],$2),dtype=f32,length=1,writer.T`2x=[typevalue<#kgen.instref<std::format::_utils::_FlushingWriteBuffer,origin._mlir_origin`={  },origin={  },W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096>>, struct<(struct<(array<4096, scalar<ui8>>) memoryOnly>, scalar<index>, pointer<none>) memoryOnly>]"@PLT
	movq	%rbp, %rdi
	movq	%r15, %rsi
	movq	%r14, %rdx
	callq	"std::format::_utils::_FlushingWriteBuffer::write_string[LITImmOrigin,::Origin[False, $4]](::_FlushingWriteBuffer[$0, $1, $2, $3],::StringSpan[$4, $5]),W=[typevalue<#kgen.instref<std::io::file_descriptor::FileDescriptor>>, scalar<index>],capacity_bytes=4096"@PLT
	movq	4120(%rsp), %rdx
	movq	4128(%rsp), %rax
	movq	(%rax), %rdi
	movq	%rbp, %rsi
	callq	write@PLT
	testb	$1, %bl
	je	.LBB13_4
	movq	16(%rsp), %rdi
	addq	$4136, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	"std::io::io::_flush(::FileDescriptor)"@PLT
.LBB13_4:
	.cfi_def_cfa_offset 4192
	addq	$4136, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end13:
	.size	"std::io::io::print[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2],LITImmOrigin,::Origin[False, $4],LITImmOrigin,::Origin[False, $6]](*$0,sep:::StringSpan[$4, $5],end:::StringSpan[$6, $7],flush:::Bool,file:::FileDescriptor$),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=f32,length=1>>, scalar<f32>]]", .Lfunc_end13-"std::io::io::print[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2],LITImmOrigin,::Origin[False, $4],LITImmOrigin,::Origin[False, $6]](*$0,sep:::StringSpan[$4, $5],end:::StringSpan[$6, $7],flush:::Bool,file:::FileDescriptor$),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=f32,length=1>>, scalar<f32>]]"
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
	.type	.LCPI79_0,@object
.LCPI79_0:
	.long	0x3f800000
	.size	.LCPI79_0, 4
	.type	.LCPI79_1,@object
.LCPI79_1:
	.long	0x7f7fffff
	.size	.LCPI79_1, 4
	.type	.LCPI79_2,@object
.LCPI79_2:
	.long	0xbf800000
	.size	.LCPI79_2, 4
	.type	.LCPI79_3,@object
.LCPI79_3:
	.long	0x3fb8aa3b
	.size	.LCPI79_3, 4
	.type	.LCPI79_4,@object
.LCPI79_4:
	.long	0x42fc0000
	.size	.LCPI79_4, 4
	.type	.LCPI79_5,@object
.LCPI79_5:
	.long	0xc2fc0000
	.size	.LCPI79_5, 4
	.type	.LCPI79_6,@object
.LCPI79_6:
	.long	0x3c20bb9a
	.size	.LCPI79_6, 4
	.type	.LCPI79_7,@object
.LCPI79_7:
	.long	0x3aaec44e
	.size	.LCPI79_7, 4
	.type	.LCPI79_8,@object
.LCPI79_8:
	.long	0x3d636733
	.size	.LCPI79_8, 4
	.type	.LCPI79_9,@object
.LCPI79_9:
	.long	0x3e75f192
	.size	.LCPI79_9, 4
	.type	.LCPI79_10,@object
.LCPI79_10:
	.long	0x3f3171f1
	.size	.LCPI79_10, 4
	.type	.LCPI79_11,@object
.LCPI79_11:
	.long	0x7fffffff
	.size	.LCPI79_11, 4
	.type	.LCPI79_12,@object
.LCPI79_12:
	.long	0x3727c5ac
	.size	.LCPI79_12, 4
	.type	.LCPI79_13,@object
.LCPI79_13:
	.long	0x3f000000
	.size	.LCPI79_13, 4
	.text
	.globl	probe_exp2
	.prefalign	4, .Lfunc_end14, nop
	.type	probe_exp2,@function
probe_exp2:
.Lprobe_exp2$local:
	.type	.Lprobe_exp2$local,@function
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$104, %rsp
	.cfi_def_cfa_offset 128
	.cfi_offset %rbx, -24
	.cfi_offset %rbp, -16
	testq	%rsi, %rsi
	jle	.LBB79_1
	testq	%rcx, %rcx
	jle	.LBB79_3
	leaq	(,%rdx,4), %rax
	xorl	%r8d, %r8d
	vmovss	.LCPI79_0(%rip), %xmm4
	vbroadcastss	.LCPI79_11(%rip), %xmm1
	vmovaps	%xmm1, 80(%rsp)
	movq	%rdi, %r9
	vbroadcastss	.LCPI79_4(%rip), %xmm3
	vbroadcastss	.LCPI79_5(%rip), %xmm15
	vbroadcastss	.LCPI79_6(%rip), %xmm14
	vbroadcastss	.LCPI79_7(%rip), %xmm6
	vbroadcastss	.LCPI79_8(%rip), %xmm7
	vbroadcastss	.LCPI79_9(%rip), %xmm1
	vbroadcastss	.LCPI79_10(%rip), %xmm8
	vbroadcastss	.LCPI79_0(%rip), %xmm11
	vxorps	%xmm2, %xmm2, %xmm2
	vmovss	%xmm0, 12(%rsp)
	jmp	.LBB79_10
	.p2align	4
.LBB79_17:
	vmovaps	16(%rsp), %xmm12
	vbroadcastss	.LCPI79_0(%rip), %xmm11
.LBB79_24:
	vmovss	36(%rsp), %xmm2
	vaddss	%xmm2, %xmm12, %xmm2
	addq	%rax, %r9
	cmpq	%rsi, %r8
	je	.LBB79_5
.LBB79_10:
	vmovss	%xmm2, 36(%rsp)
	movq	%r8, %r10
	incq	%r8
	imulq	%rdx, %r10
	vbroadcastss	4(%rdi,%r10,4), %xmm10
	xorl	%r10d, %r10d
	vmovaps	%xmm4, 16(%rsp)
	vmovss	.LCPI79_1(%rip), %xmm5
	vmovss	%xmm5, 8(%rsp)
	vxorps	%xmm2, %xmm2, %xmm2
	jmp	.LBB79_11
	.p2align	4
.LBB79_22:
	vmovss	8(%rsp), %xmm12
	vaddss	%xmm11, %xmm12, %xmm5
	vmovaps	%xmm1, %xmm8
	vmovaps	%xmm7, %xmm1
	vmovaps	%xmm6, %xmm7
	vmovaps	%xmm14, %xmm6
	vmovaps	%xmm15, %xmm14
	vmovaps	%xmm3, %xmm15
	vaddss	%xmm11, %xmm11, %xmm3
	vmulss	.LCPI79_13(%rip), %xmm5, %xmm5
	vmovss	.LCPI79_1(%rip), %xmm0
	vcmpless	%xmm12, %xmm0, %xmm11
	vblendvps	%xmm11, %xmm3, %xmm5, %xmm12
	vmovaps	%xmm15, %xmm3
	vmovaps	%xmm14, %xmm15
	vmovaps	%xmm6, %xmm14
	vmovaps	%xmm7, %xmm6
	vmovaps	%xmm1, %xmm7
	vmovaps	%xmm8, %xmm1
	vbroadcastss	.LCPI79_10(%rip), %xmm8
	vmovaps	16(%rsp), %xmm11
	vmovss	12(%rsp), %xmm0
.LBB79_23:
	vcmpltss	%xmm13, %xmm0, %xmm5
	vblendvps	%xmm5, %xmm2, %xmm11, %xmm2
	vmovaps	%xmm12, 16(%rsp)
	vmovss	%xmm9, 8(%rsp)
	cmpq	%rcx, %r10
	vbroadcastss	.LCPI79_0(%rip), %xmm11
	je	.LBB79_24
.LBB79_11:
	cmpq	$5, %rdx
	jge	.LBB79_25
	movl	$1, %r11d
	vxorps	%xmm13, %xmm13, %xmm13
	vxorps	%xmm0, %xmm0, %xmm0
	vmovaps	16(%rsp), %xmm9
	cmpq	%rdx, %r11
	jl	.LBB79_29
	jmp	.LBB79_16
	.p2align	4
.LBB79_25:
	vmovaps	%xmm2, 64(%rsp)
	vmovss	.LCPI79_2(%rip), %xmm0
	vdivss	16(%rsp), %xmm0, %xmm5
	vmulss	.LCPI79_3(%rip), %xmm5, %xmm5
	vxorps	%xmm2, %xmm2, %xmm2
	vmovaps	%xmm11, %xmm4
	vbroadcastss	%xmm5, %xmm12
	vxorps	%xmm13, %xmm13, %xmm13
	movl	$5, %r11d
	vxorps	%xmm0, %xmm0, %xmm0
	.p2align	4
.LBB79_26:
	vmovups	-16(%r9,%r11,4), %xmm9
	vsubps	%xmm10, %xmm9, %xmm9
	vmaxps	%xmm2, %xmm9, %xmm9
	vmulps	%xmm9, %xmm12, %xmm9
	vminps	%xmm3, %xmm9, %xmm9
	vmaxps	%xmm15, %xmm9, %xmm9
	vcvttps2dq	%xmm9, %xmm11
	vcvtdq2ps	%xmm11, %xmm5
	vsubps	%xmm5, %xmm9, %xmm5
	vmovaps	%xmm6, %xmm9
	vfmadd213ps	%xmm14, %xmm5, %xmm9
	vfmadd213ps	%xmm7, %xmm5, %xmm9
	vfmadd213ps	%xmm1, %xmm5, %xmm9
	vfmadd213ps	%xmm8, %xmm5, %xmm9
	vfmadd213ps	%xmm4, %xmm5, %xmm9
	vpslld	$23, %xmm11, %xmm5
	vpaddd	%xmm5, %xmm9, %xmm5
	vpshufd	$78, %xmm5, %xmm9
	vaddps	%xmm5, %xmm9, %xmm5
	vmovshdup	%xmm5, %xmm9
	vaddss	%xmm5, %xmm9, %xmm5
	vaddss	%xmm5, %xmm13, %xmm13
	addq	$4, %r11
	cmpq	%rdx, %r11
	jle	.LBB79_26
	addq	$-4, %r11
	vmovss	.LCPI79_0(%rip), %xmm4
	vmovaps	64(%rsp), %xmm2
	vmovaps	16(%rsp), %xmm9
	cmpq	%rdx, %r11
	jge	.LBB79_16
.LBB79_29:
	vmovss	.LCPI79_2(%rip), %xmm5
	vdivss	%xmm9, %xmm5, %xmm5
	vmulss	.LCPI79_3(%rip), %xmm5, %xmm12
	jmp	.LBB79_13
	.p2align	4
.LBB79_15:
	vaddss	%xmm9, %xmm13, %xmm13
	incq	%r11
	cmpq	%r11, %rdx
	je	.LBB79_16
.LBB79_13:
	vmovss	(%r9,%r11,4), %xmm5
	vsubss	%xmm10, %xmm5, %xmm11
	vucomiss	%xmm0, %xmm11
	vmovaps	%xmm4, %xmm9
	jbe	.LBB79_15
	vmulss	%xmm11, %xmm12, %xmm5
	vminss	.LCPI79_4(%rip), %xmm5, %xmm5
	vmaxss	.LCPI79_5(%rip), %xmm5, %xmm5
	vcvttss2si	%xmm5, %ebx
	vcvttps2dq	%xmm5, %xmm9
	vcvtdq2ps	%xmm9, %xmm9
	vsubss	%xmm9, %xmm5, %xmm5
	vmovss	.LCPI79_7(%rip), %xmm9
	vfmadd213ss	.LCPI79_6(%rip), %xmm5, %xmm9
	vfmadd213ss	.LCPI79_8(%rip), %xmm5, %xmm9
	vfmadd213ss	.LCPI79_9(%rip), %xmm5, %xmm9
	vfmadd213ss	.LCPI79_10(%rip), %xmm5, %xmm9
	vfmadd213ss	%xmm4, %xmm5, %xmm9
	vmovd	%xmm9, %ebp
	shll	$23, %ebx
	addl	%ebp, %ebx
	vmovd	%ebx, %xmm9
	jmp	.LBB79_15
	.p2align	4
.LBB79_16:
	vmovss	12(%rsp), %xmm0
	vsubss	%xmm0, %xmm13, %xmm5
	vandps	80(%rsp), %xmm5, %xmm5
	vmovss	.LCPI79_12(%rip), %xmm9
	vucomiss	%xmm5, %xmm9
	ja	.LBB79_17
	incq	%r10
	vucomiss	%xmm0, %xmm13
	vmovaps	16(%rsp), %xmm11
	vmovaps	%xmm11, %xmm9
	ja	.LBB79_20
	vmovss	8(%rsp), %xmm9
.LBB79_20:
	jbe	.LBB79_22
	vaddss	%xmm2, %xmm11, %xmm5
	vmulss	.LCPI79_13(%rip), %xmm5, %xmm12
	jmp	.LBB79_23
.LBB79_1:
	vxorps	%xmm2, %xmm2, %xmm2
	jmp	.LBB79_5
.LBB79_3:
	vxorps	%xmm2, %xmm2, %xmm2
	vmovss	.LCPI79_0(%rip), %xmm0
	.p2align	4
.LBB79_4:
	vaddss	%xmm0, %xmm2, %xmm2
	decq	%rsi
	jne	.LBB79_4
.LBB79_5:
	movq	$13, 48(%rsp)
	leaq	static_string_077a2c8a9a9e518a(%rip), %rax
	movq	%rax, 40(%rsp)
	movabsq	$2305843009213693952, %rax
	movq	%rax, 56(%rsp)
	movq	$1, (%rsp)
	leaq	static_string_a8d4ace0dc8d360e(%rip), %rsi
	leaq	static_string_bbe01a6a523daf15(%rip), %rcx
	leaq	40(%rsp), %rdi
	movl	$1, %edx
	movl	$1, %r8d
	vmovaps	%xmm2, %xmm0
	xorl	%r9d, %r9d
	callq	"std::io::io::print[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2],LITImmOrigin,::Origin[False, $4],LITImmOrigin,::Origin[False, $6]](*$0,sep:::StringSpan[$4, $5],end:::StringSpan[$6, $7],flush:::Bool,file:::FileDescriptor$),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=f32,length=1>>, scalar<f32>]]"@PLT
	testb	$64, 63(%rsp)
	je	.LBB79_8
	movq	40(%rsp), %rdi
	lock		decq	-8(%rdi)
	jne	.LBB79_8
	addq	$-8, %rdi
	#MEMBARRIER
	callq	KGEN_CompilerRT_AlignedFree@PLT
.LBB79_8:
	addq	$104, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end14:
	.size	probe_exp2, .Lfunc_end14-probe_exp2
	.size	.Lprobe_exp2$local, .Lfunc_end14-probe_exp2
	.cfi_endproc

	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
	.type	.LCPI156_0,@object
.LCPI156_0:
	.long	0x7fffffff
	.size	.LCPI156_0, 4
	.type	.LCPI156_1,@object
.LCPI156_1:
	.long	0x3f800000
	.size	.LCPI156_1, 4
	.type	.LCPI156_2,@object
.LCPI156_2:
	.long	0x3727c5ac
	.size	.LCPI156_2, 4
	.type	.LCPI156_3,@object
.LCPI156_3:
	.long	0x3f000000
	.size	.LCPI156_3, 4
	.type	.LCPI156_4,@object
.LCPI156_4:
	.long	0x7f7fffff
	.size	.LCPI156_4, 4
	.type	.LCPI156_5,@object
.LCPI156_5:
	.long	0x80000000
	.size	.LCPI156_5, 4
	.type	.LCPI156_6,@object
.LCPI156_6:
	.long	0x42b0c0a6
	.size	.LCPI156_6, 4
	.type	.LCPI156_7,@object
.LCPI156_7:
	.long	0xc2b0c0a5
	.size	.LCPI156_7, 4
	.type	.LCPI156_8,@object
.LCPI156_8:
	.long	0x3fb8aa3b
	.size	.LCPI156_8, 4
	.type	.LCPI156_9,@object
.LCPI156_9:
	.long	0xbf317218
	.size	.LCPI156_9, 4
	.type	.LCPI156_10,@object
.LCPI156_10:
	.long	0x39500d01
	.size	.LCPI156_10, 4
	.type	.LCPI156_11,@object
.LCPI156_11:
	.long	0x3ab60b61
	.size	.LCPI156_11, 4
	.type	.LCPI156_12,@object
.LCPI156_12:
	.long	0x3c088889
	.size	.LCPI156_12, 4
	.type	.LCPI156_13,@object
.LCPI156_13:
	.long	0x3d2aaaab
	.size	.LCPI156_13, 4
	.type	.LCPI156_14,@object
.LCPI156_14:
	.long	0x3e2aaaab
	.size	.LCPI156_14, 4
	.text
	.globl	probe_serial
	.prefalign	4, .Lfunc_end15, nop
	.type	probe_serial,@function
probe_serial:
.Lprobe_serial$local:
	.type	.Lprobe_serial$local,@function
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$96, %rsp
	.cfi_def_cfa_offset 128
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %rbp, -16
	cmpq	$2, %rdx
	movl	$1, %eax
	cmovgeq	%rdx, %rax
	testq	%rsi, %rsi
	jle	.LBB156_1
	xorl	%r8d, %r8d
	cmpq	$2, %rdx
	setge	%r9b
	testq	%rcx, %rcx
	jle	.LBB156_3
	vbroadcastss	.LCPI156_0(%rip), %xmm1
	cmpq	$2, %rdx
	jl	.LBB156_21
	vmovaps	%xmm1, 80(%rsp)
	vmovaps	%xmm0, 64(%rsp)
	movb	%r9b, %r8b
	incq	%r8
	incq	%rax
	vxorps	%xmm3, %xmm3, %xmm3
	xorl	%r9d, %r9d
	vmovss	.LCPI156_1(%rip), %xmm1
	vbroadcastss	.LCPI156_5(%rip), %xmm6
	vmovss	.LCPI156_3(%rip), %xmm13
	vmovss	.LCPI156_10(%rip), %xmm11
	vmovss	.LCPI156_12(%rip), %xmm14
	vmovss	.LCPI156_13(%rip), %xmm15
	vmovss	.LCPI156_14(%rip), %xmm4
	vxorps	%xmm5, %xmm5, %xmm5
	jmp	.LBB156_7
	.p2align	4
.LBB156_13:
	vmovaps	%xmm5, %xmm9
.LBB156_20:
	vmovss	20(%rsp), %xmm5
	vaddss	%xmm5, %xmm9, %xmm5
	cmpq	%rsi, %r9
	je	.LBB156_33
.LBB156_7:
	vmovss	%xmm5, 20(%rsp)
	movq	%r9, %r11
	incq	%r9
	imulq	%rdx, %r11
	leaq	(%rdi,%r11,4), %r10
	vmovss	4(%rdi,%r11,4), %xmm2
	xorl	%r11d, %r11d
	vmovaps	%xmm1, %xmm5
	vmovss	.LCPI156_4(%rip), %xmm12
	vxorps	%xmm0, %xmm0, %xmm0
	jmp	.LBB156_8
	.p2align	4
.LBB156_18:
	vaddss	%xmm5, %xmm5, %xmm8
	vaddss	%xmm5, %xmm0, %xmm9
	vmulss	%xmm13, %xmm9, %xmm9
	vmovss	.LCPI156_4(%rip), %xmm10
	vcmpless	%xmm0, %xmm10, %xmm10
	vblendvps	%xmm10, %xmm8, %xmm9, %xmm9
	vmovaps	48(%rsp), %xmm0
.LBB156_19:
	vmovaps	64(%rsp), %xmm8
	vcmpltss	%xmm7, %xmm8, %xmm7
	vblendvps	%xmm7, %xmm0, %xmm5, %xmm0
	vmovaps	%xmm9, %xmm5
	cmpq	%rcx, %r11
	je	.LBB156_20
.LBB156_8:
	vmovaps	%xmm0, 48(%rsp)
	vmovaps	%xmm12, %xmm0
	vxorps	%xmm7, %xmm7, %xmm7
	movl	$1, %ebx
	movq	%r8, %r14
	jmp	.LBB156_9
	.p2align	4
.LBB156_11:
	leaq	1(%rbx), %r14
	cmpq	%r14, %rax
	je	.LBB156_12
.LBB156_9:
	vmovss	(%r10,%rbx,4), %xmm8
	movq	%r14, %rbx
	vsubss	%xmm2, %xmm8, %xmm8
	vucomiss	%xmm3, %xmm8
	jbe	.LBB156_11
	vxorps	%xmm6, %xmm8, %xmm8
	vdivss	%xmm5, %xmm8, %xmm8
	vminss	.LCPI156_6(%rip), %xmm8, %xmm8
	vmaxss	.LCPI156_7(%rip), %xmm8, %xmm10
	vmovaps	%xmm13, %xmm9
	vfmadd231ss	.LCPI156_8(%rip), %xmm10, %xmm9
	vroundss	$9, %xmm9, %xmm9, %xmm9
	vmovaps	%xmm10, %xmm8
	vfmadd231ss	.LCPI156_9(%rip), %xmm9, %xmm8
	vmovaps	%xmm11, %xmm12
	vfmadd213ss	.LCPI156_11(%rip), %xmm8, %xmm12
	vfmadd213ss	%xmm14, %xmm8, %xmm12
	vfmadd213ss	%xmm15, %xmm8, %xmm12
	vfmadd213ss	%xmm4, %xmm8, %xmm12
	vfmadd213ss	%xmm13, %xmm8, %xmm12
	vfmadd213ss	%xmm1, %xmm8, %xmm12
	vfmadd213ss	%xmm1, %xmm8, %xmm12
	vcvttss2si	%xmm9, %ebp
	shll	$23, %ebp
	addl	$1065353216, %ebp
	vmovd	%ebp, %xmm8
	vmulss	%xmm8, %xmm12, %xmm8
	vmaxss	%xmm10, %xmm8, %xmm8
	vaddss	%xmm7, %xmm8, %xmm7
	jmp	.LBB156_11
	.p2align	4
.LBB156_12:
	vmovaps	64(%rsp), %xmm9
	vsubss	%xmm9, %xmm7, %xmm8
	vandps	80(%rsp), %xmm8, %xmm8
	vmovss	.LCPI156_2(%rip), %xmm10
	vucomiss	%xmm8, %xmm10
	ja	.LBB156_13
	incq	%r11
	vucomiss	%xmm9, %xmm7
	vmovaps	%xmm5, %xmm12
	ja	.LBB156_16
	vmovaps	%xmm0, %xmm12
.LBB156_16:
	jbe	.LBB156_18
	vmovaps	48(%rsp), %xmm0
	vaddss	%xmm5, %xmm0, %xmm8
	vmulss	%xmm13, %xmm8, %xmm9
	jmp	.LBB156_19
.LBB156_1:
	vxorps	%xmm5, %xmm5, %xmm5
	jmp	.LBB156_33
.LBB156_3:
	vxorps	%xmm5, %xmm5, %xmm5
	vmovss	.LCPI156_1(%rip), %xmm1
	.p2align	4
.LBB156_4:
	vaddss	%xmm1, %xmm5, %xmm5
	decq	%rsi
	jne	.LBB156_4
	jmp	.LBB156_33
.LBB156_21:
	vmovaps	%xmm0, %xmm2
	vandps	%xmm1, %xmm0, %xmm0
	vmovss	.LCPI156_2(%rip), %xmm1
	vxorps	%xmm5, %xmm5, %xmm5
	vucomiss	%xmm0, %xmm1
	jbe	.LBB156_24
	vmovss	.LCPI156_1(%rip), %xmm1
	.p2align	4
.LBB156_23:
	vaddss	%xmm1, %xmm5, %xmm5
	decq	%rsi
	jne	.LBB156_23
	jmp	.LBB156_33
.LBB156_24:
	vucomiss	%xmm2, %xmm5
	jbe	.LBB156_25
	vxorps	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
	vmovss	.LCPI156_1(%rip), %xmm1
	vmovss	.LCPI156_3(%rip), %xmm2
	.p2align	4
.LBB156_30:
	movq	%rcx, %rdx
	vmovaps	%xmm1, %xmm3
	.p2align	4
.LBB156_31:
	vaddss	%xmm4, %xmm3, %xmm3
	vmulss	%xmm2, %xmm3, %xmm3
	decq	%rdx
	jne	.LBB156_31
	incq	%rax
	vaddss	%xmm3, %xmm5, %xmm5
	cmpq	%rsi, %rax
	jne	.LBB156_30
	jmp	.LBB156_33
.LBB156_25:
	xorl	%eax, %eax
	vmovss	.LCPI156_1(%rip), %xmm2
	.p2align	4
.LBB156_26:
	movq	%rcx, %rdx
	vmovaps	%xmm2, %xmm1
	.p2align	4
.LBB156_27:
	vaddss	%xmm1, %xmm1, %xmm1
	decq	%rdx
	jne	.LBB156_27
	incq	%rax
	vaddss	%xmm1, %xmm5, %xmm5
	cmpq	%rsi, %rax
	jne	.LBB156_26
.LBB156_33:
	movq	$15, 32(%rsp)
	leaq	static_string_c46af8037468dd88(%rip), %rax
	movq	%rax, 24(%rsp)
	movabsq	$2305843009213693952, %rax
	movq	%rax, 40(%rsp)
	movq	$1, (%rsp)
	leaq	static_string_a8d4ace0dc8d360e(%rip), %rsi
	leaq	static_string_bbe01a6a523daf15(%rip), %rcx
	leaq	24(%rsp), %rdi
	movl	$1, %edx
	movl	$1, %r8d
	vmovaps	%xmm5, %xmm0
	xorl	%r9d, %r9d
	callq	"std::io::io::print[KGENParamList[::Writable & ::AnyType],*::Writable & ::AnyType,LITImmOrigin,::Origin[False, $2],LITImmOrigin,::Origin[False, $4],LITImmOrigin,::Origin[False, $6]](*$0,sep:::StringSpan[$4, $5],end:::StringSpan[$6, $7],flush:::Bool,file:::FileDescriptor$),Ts.values`=[[typevalue<#kgen.instref<std::collections::string::string::String>>, struct<(pointer<none>, scalar<index>, scalar<index>) memoryOnly>],[typevalue<#kgen.instref<std::simd::SIMD,dtype=f32,length=1>>, scalar<f32>]]"@PLT
	testb	$64, 47(%rsp)
	je	.LBB156_36
	movq	24(%rsp), %rdi
	lock		decq	-8(%rdi)
	jne	.LBB156_36
	addq	$-8, %rdi
	#MEMBARRIER
	callq	KGEN_CompilerRT_AlignedFree@PLT
.LBB156_36:
	addq	$96, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end15:
	.size	probe_serial, .Lfunc_end15-probe_serial
	.size	.Lprobe_serial$local, .Lfunc_end15-probe_serial
	.cfi_endproc

	.type	static_string_b59cc01792da92e9,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
static_string_b59cc01792da92e9:
	.asciz	"checksum exp"
	.size	static_string_b59cc01792da92e9, 13

	.type	static_string_077a2c8a9a9e518a,@object
	.p2align	4, 0x0
static_string_077a2c8a9a9e518a:
	.asciz	"checksum exp2"
	.size	static_string_077a2c8a9a9e518a, 14

	.type	static_string_a8d4ace0dc8d360e,@object
	.p2align	4, 0x0
static_string_a8d4ace0dc8d360e:
	.asciz	" "
	.size	static_string_a8d4ace0dc8d360e, 2

	.type	static_string_bbe01a6a523daf15,@object
	.p2align	4, 0x0
static_string_bbe01a6a523daf15:
	.asciz	"\n"
	.size	static_string_bbe01a6a523daf15, 2

	.type	static_string_c46af8037468dd88,@object
	.p2align	4, 0x0
static_string_c46af8037468dd88:
	.asciz	"checksum serial"
	.size	static_string_c46af8037468dd88, 16

	.type	static_string_422d2414495ed121,@object
	.p2align	4, 0x0
static_string_422d2414495ed121:
	.asciz	"Mojo/stdlib/std/builtin/_format_float.mojo"
	.size	static_string_422d2414495ed121, 43

	.type	static_string_a0fcf35b7349c924,@object
	.p2align	4, 0x0
static_string_a0fcf35b7349c924:
	.asciz	" is out of bounds, valid range is 0 to "
	.size	static_string_a0fcf35b7349c924, 40

	.type	static_string_ffe5c571af8dd3fc,@object
	.p2align	4, 0x0
static_string_ffe5c571af8dd3fc:
	.asciz	"index "
	.size	static_string_ffe5c571af8dd3fc, 7

	.type	static_string_e5411518d45eb182,@object
	.p2align	4, 0x0
static_string_e5411518d45eb182:
	.asciz	"nan"
	.size	static_string_e5411518d45eb182, 4

	.type	global_constant,@object
	.p2align	3, 0x0
global_constant:
	.quad	-9093133594791772939
	.quad	-6754730975062328270
	.quad	-3831727700400522433
	.quad	-177973607073265138
	.quad	-7028762532061872567
	.quad	-4174267146649952805
	.quad	-606147914885053102
	.quad	-7296371474444240045
	.quad	-4508778324627912152
	.quad	-1024286887357502286
	.quad	-7557708332239520785
	.quad	-4835449396872013077
	.quad	-1432625727662628442
	.quad	-7812920107430224632
	.quad	-5154464115860392886
	.quad	-1831394126398103204
	.quad	-8062150356639896358
	.quad	-5466001927372482544
	.quad	-2220816390788215276
	.quad	-8305539271883716404
	.quad	-5770238071427257601
	.quad	-2601111570856684097
	.quad	-8543223759426509416
	.quad	-6067343680855748867
	.quad	-2972493582642298179
	.quad	-8775337516792518218
	.quad	-6357485877563259868
	.quad	-3335171328526686932
	.quad	-9002011107970261188
	.quad	-6640827866535438581
	.quad	-3689348814741910323
	.quad	-9223372036854775808
	.quad	-6917529027641081856
	.quad	-4035225266123964416
	.quad	-432345564227567616
	.quad	-7187745005283311616
	.quad	-4372995238176751616
	.quad	-854558029293551616
	.quad	-7451627795949551616
	.quad	-4702848726509551616
	.quad	-1266874889709551616
	.quad	-7709325833709551616
	.quad	-5024971273709551616
	.quad	-1669528073709551616
	.quad	-7960984073709551616
	.quad	-5339544073709551616
	.quad	-2062744073709551616
	.quad	-8206744073709551616
	.quad	-5646744073709551616
	.quad	-2446744073709551616
	.quad	-8446744073709551616
	.quad	-5946744073709551616
	.quad	-2821744073709551616
	.quad	-8681119073709551616
	.quad	-6239712823709551616
	.quad	-3187955011209551616
	.quad	-8910000909647051616
	.quad	-6525815118631426616
	.quad	-3545582879861895366
	.quad	-9133518327554766459
	.quad	-6805211891016070170
	.quad	-3894828845342699809
	.quad	-256850038250986857
	.quad	-7078060301547948642
	.quad	-4235889358507547898
	.quad	-683175679707046969
	.quad	-7344513827457986211
	.quad	-4568956265895094860
	.quad	-1099509313941480671
	.quad	-7604722348854507275
	.quad	-4894216917640746190
	.quad	-1506085128623544834
	.quad	-7858832233030797377
	.quad	-5211854272861108818
	.quad	-1903131822648998118
	.quad	-8106986416796705680
	.quad	-5522047002568494196
	.quad	-2290872734783229841
	.size	global_constant, 624

	.type	global_constant_0,@object
	.p2align	4, 0x0
global_constant_0:
	.quad	2731688931043774331
	.quad	-38366372719436721
	.quad	8624834609543440813
	.quad	-6941508010590729807
	.quad	-3054014793352862696
	.quad	-4065198994811024355
	.quad	5405853545163697438
	.quad	-469812725086392539
	.quad	5684501474941004851
	.quad	-7211161980820077193
	.quad	2493940825248868160
	.quad	-4402266457597708587
	.quad	7729112049988473104
	.quad	-891147053569747830
	.quad	-9004363024039368022
	.quad	-7474495936122174250
	.quad	2579604275232953684
	.quad	-4731433901725329908
	.quad	3224505344041192105
	.quad	-1302606358729274481
	.quad	8932844867666826922
	.quad	-7731658001846878407
	.quad	-2669001970698630060
	.quad	-5052886483881210105
	.quad	-3336252463373287575
	.quad	-1704422086424124727
	.quad	2526528228819083170
	.quad	-7982792831656159810
	.quad	-6065211750830921845
	.quad	-5366805021142811859
	.quad	1641857348316123501
	.quad	-2096820258001126919
	.quad	-5891368184943504668
	.quad	-8228041688891786181
	.quad	-7364210231179380835
	.quad	-5673366092687344822
	.quad	4629795266307937668
	.quad	-2480021597431793123
	.quad	5199465050656154995
	.quad	-8467542526035952558
	.quad	-2724040723534582064
	.quad	-5972742139117552794
	.quad	-8016736922845615485
	.quad	-2854241655469553088
	.quad	6518754469289960082
	.quad	-8701430062309552536
	.quad	8148443086612450103
	.quad	-6265101559459552766
	.quad	962181821410786820
	.quad	-3219690930897053053
	.quad	-1704479370831952189
	.quad	-8929835859451740015
	.quad	7092772823314835571
	.quad	-6550608805887287114
	.quad	-357406007711231344
	.quad	-3576574988931720989
	.quad	8999993282035256218
	.quad	-9152888395723407474
	.quad	2026619565689294465
	.quad	-6829424476226871438
	.quad	-6690097579743157727
	.quad	-3925094576856201394
	.quad	5472436080603216553
	.quad	-294682202642863838
	.quad	8031958568804398250
	.quad	-7101705404292871755
	.quad	-3795109844276665900
	.quad	-4265445736938701790
	.quad	9091170749936331337
	.quad	-720121152745989333
	.quad	3376138709496513134
	.quad	-7367604748107325189
	.quad	-391512631556746487
	.quad	-4597819916706768583
	.quad	8733981247408842699
	.quad	-1135588877456072824
	.quad	5458738279630526687
	.quad	-7627272076051127371
	.quad	-7011635205744005353
	.quad	-4922404076636521310
	.quad	5070514048102157021
	.quad	-1541319077368263733
	.quad	863228270850154186
	.quad	-7880853450996246689
	.quad	-3532650679864695172
	.quad	-5239380795317920458
	.quad	-9027499368258256869
	.quad	-1937539975720012668
	.quad	-3336344095947716591
	.quad	-8128491512466089774
	.quad	-8782116138362033642
	.quad	-5548928372155224313
	.quad	7469098900757009563
	.quad	-2324474446766642487
	.quad	-2249342214667950879
	.quad	-8370325556870233411
	.quad	6411694268519837209
	.quad	-5851220927660403859
	.quad	-5820440219632367201
	.quad	-2702340141148116920
	.quad	7891439908798240260
	.quad	-8606491615858654931
	.quad	-3970758169284363388
	.quad	-6146428501395930760
	.quad	-351761693178066331
	.quad	-3071349608317525546
	.quad	6697677969404790400
	.quad	-8837122532839535322
	.quad	-851274575098787809
	.quad	-6434717147622031249
	.quad	-1064093218873484761
	.quad	-3431710416100151157
	.quad	8558313775058847833
	.quad	-9062348037703676329
	.quad	6086206200396171887
	.quad	-6716249028702207507
	.quad	-6227300304786948854
	.quad	-3783625267450371480
	.quad	-3172439362556298163
	.quad	-117845565885576446
	.quad	-4288617610811380304
	.quad	-6991182506319567135
	.quad	3862600023340550428
	.quad	-4127292114472071014
	.quad	-4395122007679087773
	.quad	-547429124662700864
	.quad	8782263791269039902
	.quad	-7259672230555269896
	.quad	-7468914334623251739
	.quad	-4462904269766699466
	.quad	4498915137003099038
	.quad	-966944318780986428
	.quad	-6411550076227838909
	.quad	-7521869226879198374
	.quad	5820620459997365076
	.quad	-4790650515171610063
	.quad	-6559282480285457367
	.quad	-1376627125537124675
	.quad	-8711237568605798758
	.quad	-7777920981101784778
	.quad	2946011094524915264
	.quad	-5110715207949843068
	.quad	3682513868156144080
	.quad	-1776707991509915931
	.quad	4607414176811284002
	.quad	-8027971522334779313
	.quad	1147581702586717098
	.quad	-5423278384491086237
	.quad	-3177208890193991531
	.quad	-2167411962186469893
	.quad	7237616480483531101
	.quad	-8272161504007625539
	.quad	-4788037454677749836
	.quad	-5728515861582144020
	.quad	-1373360799919799391
	.quad	-2548958808550292121
	.quad	-858350499949874619
	.quad	-8510628282985014432
	.quad	3538747893490044630
	.quad	-6026599335303880135
	.quad	9035120885289943692
	.quad	-2921563150702462265
	.quad	-5882264492762254952
	.quad	-8743505996830120772
	.quad	-2741144597525430787
	.quad	-6317696477610263061
	.quad	-3426430746906788484
	.quad	-3285434578585440922
	.quad	4776009810824339054
	.quad	-8970925639256982432
	.quad	5970012263530423817
	.quad	-6601971030643840136
	.quad	7462515329413029772
	.quad	-3640777769877412266
	.quad	52386062455755703
	.quad	-9193015133814464522
	.quad	-9157889458785081179
	.quad	-6879582898840692749
	.quad	6999382250228200142
	.quad	-3987792605123478032
	.quad	8749227812785250178
	.quad	-373054737976959636
	.quad	-3755104653863994447
	.quad	-7150688238876681629
	.quad	-4693880817329993059
	.quad	-4326674280168464132
	.quad	-1255665003235103419
	.quad	-796656831783192261
	.quad	8438581409832836171
	.quad	-7415439547505577019
	.quad	-3286831292991118498
	.quad	-4657613415954583370
	.quad	-8720225134666286027
	.quad	-1210330751515841308
	.quad	-3144297699952734815
	.quad	-7673985747338482674
	.quad	-8542058143368306422
	.quad	-4980796165745715438
	.quad	3157485376071780684
	.quad	-1614309188754756393
	.quad	8890957387685944784
	.quad	-7926472270612804602
	.quad	1890324697752655171
	.quad	-5296404319838617848
	.quad	2362905872190818964
	.quad	-2008819381370884406
	.quad	6088502188546649757
	.quad	-8173041140997884610
	.quad	-1612744301171463612
	.quad	-5604615407819967859
	.quad	7207441660390446293
	.quad	-2394083241347571919
	.quad	-2412877989897052923
	.quad	-8413831053483314306
	.quad	-7627783505798704058
	.quad	-5905602798426754978
	.quad	4300328673033783640
	.quad	-2770317479606055818
	.quad	-1923980597781273129
	.quad	-8648977452394866743
	.quad	6818396289628184397
	.quad	-6199535797066195524
	.quad	8522995362035230496
	.quad	-3137733727905356501
	.quad	3021029092058325108
	.quad	-8878612607581929669
	.quad	-835399653354481519
	.quad	-6486579741050024183
	.quad	8179122470161673909
	.quad	-3496538657885142324
	.quad	-4111420493003729615
	.quad	-9102865688819295809
	.quad	-5139275616254662019
	.quad	-6766896092596731857
	.quad	-6424094520318327523
	.quad	-3846934097318526917
	.quad	-8030118150397909404
	.quad	-196981603220770742
	.quad	-7324666853212387329
	.quad	-7040642529654063570
	.quad	4679224488766679550
	.quad	-4189117143640191558
	.quad	-3374341425896426371
	.quad	-624710411122851544
	.quad	-9026492418826348337
	.quad	-7307973034592864071
	.quad	-2059743486678159614
	.quad	-4523280274813692185
	.quad	-2574679358347699518
	.quad	-1042414325089727327
	.quad	3002511419460075706
	.quad	-7569037980822161435
	.quad	8364825292752482536
	.quad	-4849611457600313890
	.quad	1232659579085827362
	.quad	-1450328303573004458
	.quad	-3841273781498745803
	.quad	-7823984217374209643
	.quad	4421779809981343555
	.quad	-5168294253290374149
	.quad	915538744049291539
	.quad	-1848681798185579782
	.quad	5183897733458195116
	.quad	-8072955151507069220
	.quad	6479872166822743895
	.quad	-5479507920956448621
	.quad	3488154190101041965
	.quad	-2237698882768172872
	.quad	2180096368813151228
	.quad	-8316090829371189901
	.quad	-1886565557410948869
	.quad	-5783427518286599473
	.quad	-2358206946763686086
	.quad	-2617598379430861437
	.quad	7749492695127472004
	.quad	-8553528014785370254
	.quad	463493832054564197
	.quad	-6080224000054324913
	.quad	-4032318728359182658
	.quad	-2988593981640518238
	.quad	-4826042214438183113
	.quad	-8785400266166405755
	.quad	3190819268807046917
	.quad	-6370064314280619289
	.quad	-623161932418579258
	.quad	-3350894374423386208
	.quad	-7307005235402693892
	.quad	-9011838011655698236
	.quad	-4522070525825979461
	.quad	-6653111496142234891
	.quad	3570783879572301481
	.quad	-3704703351750405709
	.quad	-148206168962011053
	.quad	-19193171260619233
	.quad	-92628855601256908
	.quad	-6929524759678968877
	.quad	-115786069501571135
	.quad	-4050219931171323192
	.quad	4466953431550423985
	.quad	-451088895536766085
	.quad	486002885505321039
	.quad	-7199459587351560659
	.quad	5219189625309039203
	.quad	-4387638465762062920
	.quad	6523987031636299003
	.quad	-872862063775190746
	.quad	-534194123654701027
	.quad	-7463067817500576073
	.quad	-667742654568376284
	.quad	-4717148753448332187
	.quad	8388693718644305453
	.quad	-1284749923383027329
	.quad	-6286281471915778851
	.quad	-7720497729755473937
	.quad	-7857851839894723564
	.quad	-5038936143766954517
	.quad	8624429273841147160
	.quad	-1686984161281305242
	.quad	778582277723329071
	.quad	-7971894128441897632
	.quad	973227847154161339
	.quad	-5353181642124984136
	.quad	1216534808942701674
	.quad	-2079791034228842266
	.quad	-3851351762838199358
	.quad	-8217398424034108273
	.quad	-4814189703547749197
	.quad	-5660062011615247437
	.quad	-6017737129434686497
	.quad	-2463391496091671392
	.quad	7768129340171790700
	.quad	-8457148712698376476
	.quad	-8736582398494813241
	.quad	-5959749872445582691
	.quad	-1697355961263740744
	.quad	-2838001322129590460
	.quad	1244995533423855987
	.quad	-8691279853972075893
	.quad	-3055441601647567920
	.quad	-6252413799037706963
	.quad	5404070034795315908
	.quad	-3203831230369745799
	.quad	-3539985255894009413
	.quad	-8919923546622172981
	.quad	-4424981569867511767
	.quad	-6538218414850328322
	.quad	8303831092947774003
	.quad	-3561087000135522498
	.quad	578208414664970848
	.quad	-9143208402725783417
	.quad	-3888925500096174344
	.quad	-6817324484979841368
	.quad	-249470856692830026
	.quad	-3909969587797413806
	.quad	-4923524589293425437
	.quad	-275775966319379353
	.quad	-3077202868308390898
	.quad	-7089889006590693952
	.quad	765182433041899282
	.quad	-4250675239810979535
	.quad	5568164059729762006
	.quad	-701658031336336515
	.quad	5785945546544795206
	.quad	-7356065297226292178
	.quad	-1990940103673781801
	.quad	-4583395603105477319
	.quad	6734696907262548557
	.quad	-1117558485454458744
	.quad	4209185567039092848
	.quad	-7616003081050118571
	.quad	-8573576096483297652
	.quad	-4908317832885260310
	.quad	3118087934678041647
	.quad	-1523711272679187483
	.quad	4254647968387469982
	.quad	-7869848573065574033
	.quad	706623942056949573
	.quad	-5225624697904579637
	.quad	-3728406090856200938
	.quad	-1920344853953336643
	.quad	-6941939825212513490
	.quad	-8117744561361917258
	.quad	5157633273766521850
	.quad	-5535494683275008668
	.quad	6447041592208152312
	.quad	-2307682335666372931
	.quad	6335244004343789147
	.quad	-8359830487432564938
	.quad	-1304317031425039374
	.quad	-5838102090863318269
	.quad	-1630396289281299218
	.quad	-2685941595151759932
	.quad	1286845328412881941
	.quad	-8596242524610931813
	.quad	-3003129357911285478
	.quad	-6133617137336276863
	.quad	5469460339465668960
	.quad	-3055335403242958174
	.quad	8030098730593431004
	.quad	-8827113654667930715
	.quad	-3797434642040374957
	.quad	-6422206049907525490
	.quad	9088264752731695016
	.quad	-3416071543957018958
	.quad	-8154892584824854327
	.quad	-9052573742614218705
	.quad	8253128342678483707
	.quad	-6704031159840385477
	.quad	5704724409920716730
	.quad	-3768352931373093942
	.quad	-2092466524453879895
	.quad	-98755145788979524
	.quad	998051431430019018
	.quad	-6979250993759194058
	.quad	-7975807747567252036
	.quad	-4112377723771604669
	.quad	8476984389250486571
	.quad	-528786136287117932
	.quad	-3925256793573221701
	.quad	-7248020362820530564
	.quad	-294884973539139223
	.quad	-4448339435098275301
	.quad	-368606216923924028
	.quad	-948738275445456222
	.quad	-2536221894791146469
	.quad	-7510490449794491995
	.quad	6053094668365842721
	.quad	-4776427043815727089
	.quad	2954682317029915497
	.quad	-1358847786342270957
	.quad	-459166561069996766
	.quad	-7766808894105001205
	.quad	-573958201337495958
	.quad	-5096825099203863602
	.quad	-5329133770099257851
	.quad	-1759345355577441598
	.quad	-5636551615525730109
	.quad	-8017119874876982855
	.quad	2177682517447613172
	.quad	-5409713825168840664
	.quad	2722103146809516465
	.quad	-2150456263033662926
	.quad	6313000485183335695
	.quad	-8261564192037121185
	.quad	3279564588051781714
	.quad	-5715269221619013577
	.quad	-512230283362660762
	.quad	-2532400508596379068
	.quad	1985699082112030976
	.quad	-8500279345513818773
	.quad	-2129562165787349184
	.quad	-6013663163464885563
	.quad	6561419329620589328
	.quad	-2905392935903719049
	.quad	-7428327965055601430
	.quad	-8733399612580906262
	.quad	4549648098962661925
	.quad	-6305063497298744923
	.quad	-8147997931578836306
	.quad	-3269643353196043250
	.quad	1825030320404309165
	.quad	-8961056123388608887
	.quad	6892973918932774360
	.quad	-6589634135808373205
	.quad	4004531380238580046
	.quad	-3625356651333078602
	.quad	-2108853905778275375
	.quad	-9183376934724255983
	.quad	6587304654631931589
	.quad	-6867535149977932074
	.quad	-989241218564861322
	.quad	-3972732919045027189
	.quad	-1236551523206076653
	.quad	-354230130378896082
	.quad	6144684325637283948
	.quad	-7138922859127891907
	.quad	-6154202648235558777
	.quad	-4311967555482476980
	.quad	-3081067291867060567
	.quad	-778273425925708321
	.quad	-1925667057416912854
	.quad	-7403949918844649557
	.quad	-2407083821771141068
	.quad	-4643251380128424042
	.quad	-7620540795641314239
	.quad	-1192378206733142148
	.quad	-2456994988062127447
	.quad	-7662765406849295699
	.quad	6152128301777116499
	.quad	-4966770740134231719
	.quad	-6144897678060768089
	.quad	-1596777406740401745
	.quad	-3840561048787980055
	.quad	-7915514906853832947
	.quad	4422670725869800739
	.quad	-5282707615139903279
	.quad	-8306719647944912789
	.quad	-1991698500497491195
	.quad	8643358275316593219
	.quad	-8162340590452013853
	.quad	6192511825718353620
	.quad	-5591239719637629412
	.quad	7740639782147942025
	.quad	-2377363631119648861
	.quad	2532056854628769814
	.quad	-8403381297090862394
	.quad	-6058300968568813541
	.quad	-5892540602936190089
	.quad	-7572876210711016926
	.quad	-2753989735242849707
	.quad	9102010423587778133
	.quad	-8638772612167862923
	.quad	-2457545025797441046
	.quad	-6186779746782440750
	.quad	-7683617300674189211
	.quad	-3121788665050663033
	.quad	-4802260812921368257
	.quad	-8868646943297746252
	.quad	-1391139997724322417
	.quad	-6474122660694794911
	.quad	7484447039699372787
	.quad	-3480967307441105734
	.quad	-9157278655470055720
	.quad	-9093133594791772940
	.quad	-6834912300910181746
	.quad	-6754730975062328271
	.quad	679731660717048625
	.quad	-3831727700400522434
	.quad	-8373707460958465027
	.quad	-177973607073265139
	.quad	8601490892183123070
	.quad	-7028762532061872568
	.quad	-7694880458480647778
	.quad	-4174267146649952806
	.quad	4216457482181353989
	.quad	-606147914885053103
	.quad	-4282243101277735613
	.quad	-7296371474444240046
	.quad	8482254178684994196
	.quad	-4508778324627912153
	.quad	5991131704928854841
	.quad	-1024286887357502287
	.quad	-3173071712060547580
	.quad	-7557708332239520786
	.quad	-8578025658503072379
	.quad	-4835449396872013078
	.quad	3112525982153323238
	.quad	-1432625727662628443
	.quad	4251171748059520976
	.quad	-7812920107430224633
	.quad	702278666647013315
	.quad	-5154464115860392887
	.quad	5489534351736154548
	.quad	-1831394126398103205
	.quad	1125115960621402641
	.quad	-8062150356639896359
	.quad	6018080969204141205
	.quad	-5466001927372482545
	.quad	2910915193077788602
	.quad	-2220816390788215277
	.quad	-486521013540076076
	.quad	-8305539271883716405
	.quad	-608151266925095095
	.quad	-5770238071427257602
	.quad	-5371875102083756772
	.quad	-2601111570856684098
	.quad	3560107088838733873
	.quad	-8543223759426509417
	.quad	-161552157378970562
	.quad	-6067343680855748868
	.quad	4409745821703674701
	.quad	-2972493582642298180
	.quad	-6467280898289979120
	.quad	-8775337516792518219
	.quad	1139270913992301908
	.quad	-6357485877563259869
	.quad	-3187597375937010519
	.quad	-3335171328526686933
	.quad	7231123676894144234
	.quad	-9002011107970261189
	.quad	4427218577690292388
	.quad	-6640827866535438582
	.quad	-3689348814741910323
	.quad	-3689348814741910324
	.quad	0
	.quad	-9223372036854775808
	.quad	0
	.quad	-6917529027641081856
	.quad	0
	.quad	-4035225266123964416
	.quad	0
	.quad	-432345564227567616
	.quad	0
	.quad	-7187745005283311616
	.quad	0
	.quad	-4372995238176751616
	.quad	0
	.quad	-854558029293551616
	.quad	0
	.quad	-7451627795949551616
	.quad	0
	.quad	-4702848726509551616
	.quad	0
	.quad	-1266874889709551616
	.quad	0
	.quad	-7709325833709551616
	.quad	0
	.quad	-5024971273709551616
	.quad	0
	.quad	-1669528073709551616
	.quad	0
	.quad	-7960984073709551616
	.quad	0
	.quad	-5339544073709551616
	.quad	0
	.quad	-2062744073709551616
	.quad	0
	.quad	-8206744073709551616
	.quad	0
	.quad	-5646744073709551616
	.quad	0
	.quad	-2446744073709551616
	.quad	0
	.quad	-8446744073709551616
	.quad	0
	.quad	-5946744073709551616
	.quad	0
	.quad	-2821744073709551616
	.quad	0
	.quad	-8681119073709551616
	.quad	0
	.quad	-6239712823709551616
	.quad	0
	.quad	-3187955011209551616
	.quad	0
	.quad	-8910000909647051616
	.quad	0
	.quad	-6525815118631426616
	.quad	0
	.quad	-3545582879861895366
	.quad	4611686018427387904
	.quad	-9133518327554766460
	.quad	5764607523034234880
	.quad	-6805211891016070171
	.quad	-6629298651489370112
	.quad	-3894828845342699810
	.quad	5548434740920451072
	.quad	-256850038250986858
	.quad	-1143914305352105984
	.quad	-7078060301547948643
	.quad	7793479155164643328
	.quad	-4235889358507547899
	.quad	-4093209111326359552
	.quad	-683175679707046970
	.quad	4359273333062107136
	.quad	-7344513827457986212
	.quad	5449091666327633920
	.quad	-4568956265895094861
	.quad	2199678564482154496
	.quad	-1099509313941480672
	.quad	1374799102801346560
	.quad	-7604722348854507276
	.quad	1718498878501683200
	.quad	-4894216917640746191
	.quad	6759809616554491904
	.quad	-1506085128623544835
	.quad	6530724019560251392
	.quad	-7858832233030797378
	.quad	-1059967012404461568
	.quad	-5211854272861108819
	.quad	7898413271349198848
	.quad	-1903131822648998119
	.quad	-1981020733047832576
	.quad	-8106986416796705681
	.quad	-2476275916309790720
	.quad	-5522047002568494197
	.quad	-3095344895387238400
	.quad	-2290872734783229842
	.quad	4982938468024057856
	.quad	-8349324486880600507
	.quad	-7606384970252091392
	.quad	-5824969590173362730
	.quad	4327076842467049472
	.quad	-2669525969289315508
	.quad	-6518949010312869888
	.quad	-8585982758446904049
	.quad	-8148686262891087360
	.quad	-6120792429631242157
	.quad	8260886245095692416
	.quad	-3039304518611664792
	.quad	5163053903184807760
	.quad	-8817094351773372351
	.quad	-7381240676301154012
	.quad	-6409681921289327535
	.quad	-3178808521666707
	.quad	-3400416383184271515
	.quad	-4613672773753429595
	.quad	-9042789267131251553
	.quad	-5767090967191786994
	.quad	-6691800565486676537
	.quad	-7208863708989733743
	.quad	-3753064688430957767
	.quad	212292400617608629
	.quad	-79644842111309304
	.quad	132682750386005393
	.quad	-6967307053960650171
	.quad	4777539456409894646
	.quad	-4097447799023424810
	.quad	-3251447716342407501
	.quad	-510123730351893109
	.quad	7191217214140771120
	.quad	-7236356359111015049
	.quad	4377335499248575996
	.quad	-4433759430461380907
	.quad	-8363388681221443717
	.quad	-930513269649338230
	.quad	-7532960934977096275
	.quad	-7499099821171918250
	.quad	4418856886560793368
	.quad	-4762188758037509908
	.quad	5523571108200991710
	.quad	-1341049929119499481
	.quad	-8076983103442849941
	.quad	-7755685233340769032
	.quad	-5484542860876174523
	.quad	-5082920523248573386
	.quad	6979379479186945559
	.quad	-1741964635633328828
	.quad	-4861259862362934834
	.quad	-8006256924911912374
	.quad	7758483227328495170
	.quad	-5396135137712502563
	.quad	-4136954021121544750
	.quad	-2133482903713240300
	.quad	-279753253987271517
	.quad	-8250955842461857044
	.quad	4261994450943298508
	.quad	-5702008784649933400
	.quad	5327493063679123135
	.quad	-2515824962385028846
	.quad	7941369183226839864
	.quad	-8489919629131724885
	.quad	5315025460606161925
	.quad	-6000713517987268202
	.quad	-2579590211097073401
	.quad	-2889205879056697349
	.quad	7611128154919104932
	.quad	-8723282702051517699
	.quad	-4321147861633282547
	.quad	-6292417359137009220
	.quad	-789748808614215279
	.quad	-3253835680493873621
	.quad	8729779031470891259
	.quad	-8951176327949752869
	.quad	6300537770911226169
	.quad	-6577284391509803182
	.quad	-1347699823215743097
	.quad	-3609919470959866074
	.quad	6075216638131242421
	.quad	-9173728696990998152
	.quad	7594020797664053026
	.quad	-6855474852811359786
	.quad	269153960225290474
	.quad	-3957657547586811828
	.quad	336442450281613092
	.quad	-335385916056126881
	.quad	7127805559067090039
	.quad	-7127145225176161157
	.quad	4298070930406474645
	.quad	-4297245513042813542
	.quad	-3850783373846682502
	.quad	-759870872876129024
	.quad	9122475437414293196
	.quad	-7392448323188662496
	.quad	-7043649776941685121
	.quad	-4628874385558440216
	.quad	-4192876202749718497
	.quad	-1174406963520662366
	.quad	-4926390635932268013
	.quad	-7651533379841495835
	.quad	3065383741939440792
	.quad	-4952730706374481889
	.quad	-779956341003086914
	.quad	-1579227364540714458
	.quad	6430056314514152535
	.quad	-7904546130479028392
	.quad	8037570393142690669
	.quad	-5268996644671397586
	.quad	823590954573587528
	.quad	-1974559787411859078
	.quad	5126430365035880109
	.quad	-8151628894773493780
	.quad	6408037956294850136
	.quad	-5577850100039479321
	.quad	3398361426941174766
	.quad	-2360626606621961247
	.quad	-4793553135802847627
	.quad	-8392920656779807636
	.quad	-1380255401326171630
	.quad	-5879464802547371641
	.quad	-1725319251657714538
	.quad	-2737644984756826647
	.quad	3533361486141316318
	.quad	-8628557143114098510
	.quad	-4806670179178130410
	.quad	-6174010410465235234
	.quad	7826720331309500699
	.quad	-3105826994654156138
	.quad	280014188641050033
	.quad	-8858670899299929442
	.quad	-8873354301053463267
	.quad	-6461652605697523899
	.quad	-1868320839462053276
	.quad	-3465379738694516970
	.quad	5749828502977298559
	.quad	-9083391364325154962
	.quad	-2036086408133152610
	.quad	-6742553186979055799
	.quad	6678264026688335046
	.quad	-3816505465296431844
	.quad	8347830033360418807
	.quad	-158945813193151901
	.quad	2911550761636567803
	.quad	-7016870160886801794
	.quad	-5583933584809066055
	.quad	-4159401682681114339
	.quad	2243455055843443239
	.quad	-587566084924005019
	.quad	3708002419115845977
	.quad	-7284757830718584993
	.quad	23317005467419567
	.quad	-4494261269970843337
	.quad	-4582539761593113445
	.quad	-1006140569036166268
	.quad	-558244341782001951
	.quad	-7546366883288685774
	.quad	-5309491445654890343
	.quad	-4821272585683469313
	.quad	-6636864307068612929
	.quad	-1414904713676948737
	.quad	-4148040191917883080
	.quad	-7801844473689174817
	.quad	-5185050239897353851
	.quad	-5140619573684080617
	.quad	-6481312799871692314
	.quad	-1814088448677712867
	.quad	-8662506518347195600
	.quad	-8051334308064652398
	.quad	3006924907348169212
	.quad	-5452481866653427593
	.quad	-853029884242176389
	.quad	-2203916314889396588
	.quad	1772699331562333709
	.quad	-8294976724446954723
	.quad	6827560182880305040
	.quad	-5757034887131305500
	.quad	8534450228600381300
	.quad	-2584607590486743971
	.quad	7639874402088932265
	.quad	-8532908771695296838
	.quad	326470965756389523
	.quad	-6054449946191733143
	.quad	5019774725622874807
	.quad	-2956376414312278525
	.quad	831516194300602803
	.quad	-8765264286586255934
	.quad	-8183976793979022305
	.quad	-6344894339805432014
	.quad	3605087062808385831
	.quad	-3319431906329402113
	.quad	9170708441896323001
	.quad	-8992173969096958177
	.quad	6851699533943015847
	.quad	-6628531442943809817
	.quad	3952938399001381904
	.quad	-3673978285252374367
	.quad	-4446942528265218166
	.quad	-9213765455923815836
	.quad	-946992141904134803
	.quad	-6905520801477381891
	.quad	8039631859474607304
	.quad	-4020214983419339459
	.quad	-3785518230938904582
	.quad	-413582710846786420
	.quad	-60105885123121412
	.quad	-7176018221920323369
	.quad	-75132356403901765
	.quad	-4358336758973016307
	.quad	9129456591349898602
	.quad	-836234930288882479
	.quad	-1211618658047395230
	.quad	-7440175859071633406
	.quad	-6126209340986631941
	.quad	-4688533805412153853
	.quad	-7657761676233289927
	.quad	-1248981238337804412
	.quad	-2480258038432112252
	.quad	-7698142301602209614
	.quad	-7712008566467528219
	.quad	-5010991858575374113
	.quad	8806733365625141342
	.quad	-1652053804791829737
	.quad	-6025006692552756421
	.quad	-7950062655635975442
	.quad	6303799689591218186
	.quad	-5325892301117581398
	.quad	-1343622424865753076
	.quad	-2045679357969588844
	.quad	1466078993672598280
	.quad	-8196078626372074883
	.quad	6444284760518135753
	.quad	-5633412264537705700
	.quad	8055355950647669692
	.quad	-2430079312244744221
	.quad	2728754459941099605
	.quad	-8436328597794046994
	.quad	-5812428961928401301
	.quad	-5933724728815170839
	.quad	1957835834444274181
	.quad	-2805469892591575644
	.quad	-7999724640327104445
	.quad	-8670947710510816634
	.quad	3835402254873283156
	.quad	-6226998619711132888
	.quad	4794252818591603945
	.quad	-3172062256211528206
	.quad	7608094030047140370
	.quad	-8900067937773286985
	.quad	4898431519131537558
	.quad	-6513398903789220827
	.quad	-7712018656367741764
	.quad	-3530062611309138130
	.quad	2097517367411243254
	.quad	-9123818159709293187
	.quad	7233582727691441971
	.quad	-6793086681209228580
	.quad	9041978409614302463
	.quad	-3879672333084147821
	.quad	6690786993590490175
	.quad	-237904397927796872
	.quad	4181741870994056360
	.quad	-7066219276345954901
	.quad	615491320315182545
	.quad	-4221088077005055722
	.quad	-8454007886460797626
	.quad	-664674077828931749
	.quad	3939617107816777292
	.quad	-7332950326284164199
	.quad	-8910536670511192098
	.quad	-4554501889427817345
	.quad	7308573235570561494
	.quad	-1081441343357383777
	.quad	-6961356773836868826
	.quad	-7593429867239446717
	.quad	-8701695967296086033
	.quad	-4880101315621920492
	.quad	-6265433940692719637
	.quad	-1488440626100012711
	.quad	695789805494438131
	.quad	-7847804418953589800
	.quad	869737256868047664
	.quad	-5198069505264599346
	.quad	-8136200465769716229
	.quad	-1885900863153361279
	.quad	-473439272678684739
	.quad	-8096217067111932656
	.quad	4019886927579031981
	.quad	-5508585315462527915
	.quad	-8810199395808373736
	.quad	-2274045625900771990
	.quad	-7812217631593927537
	.quad	-8338807543829064350
	.quad	4069786015789754291
	.quad	-5811823411358942533
	.quad	475546501309804959
	.quad	-2653093245771290262
	.quad	4908902581746016004
	.quad	-8575712306248138270
	.quad	-3087243809672255804
	.quad	-6107954364382784934
	.quad	-8470740780517707659
	.quad	-3023256937051093263
	.quad	-682526969396179382
	.quad	-8807064613298015146
	.quad	-5464844730172612132
	.quad	-6397144748195131028
	.quad	-2219369894288377261
	.quad	-3384744916816525881
	.quad	-1387106183930235788
	.quad	-9032994600651410532
	.quad	2877803288514593169
	.quad	-6679557232386875260
	.quad	3597254110643241461
	.quad	-3737760522056206171
	.quad	9108253656731439730
	.quad	-60514634142869810
	.quad	1080972517029761927
	.quad	-6955350673980375487
	.quad	5962901664714590313
	.quad	-4082502324048081455
	.quad	-6381430974388925821
	.quad	-491441886632713915
	.quad	-8600080377420466542
	.quad	-7224680206786528053
	.quad	7696643601933968438
	.quad	-4419164240055772162
	.quad	397432465562684740
	.quad	-912269281642327298
	.quad	-4363290727450709941
	.quad	-7487697328667536418
	.quad	8380944645968776285
	.quad	-4747935642407032618
	.quad	1252808770606194548
	.quad	-1323233534581402868
	.quad	-8440366555225904215
	.quad	-7744549986754458649
	.quad	7896285879677171347
	.quad	-5069001465015685407
	.quad	-3964700705685699528
	.quad	-1724565812842218855
	.quad	2133748077373825699
	.quad	-7995382660667468640
	.quad	2667185096717282124
	.quad	-5382542307406947896
	.quad	3333981370896602654
	.quad	-2116491865831296966
	.quad	6695424375237764563
	.quad	-8240336443785642460
	.quad	8369280469047205704
	.quad	-5688734536304665171
	.quad	-3373457468973156582
	.quad	-2499232151953443560
	.quad	-9025939945749304720
	.quad	-8479549122611984081
	.quad	7164319141522920716
	.quad	-5987750384837592197
	.quad	4343712908476262991
	.quad	-2873001962619602342
	.quad	7326506586225052274
	.quad	-8713155254278333320
	.quad	9158133232781315342
	.quad	-6279758049420528746
	.quad	2224294504121868369
	.quad	-3238011543348273028
	.quad	-7833187971778608077
	.quad	-8941286242233752499
	.quad	-568112927868484288
	.quad	-6564921784364802720
	.quad	3901544858591782543
	.quad	-3594466212028615495
	.quad	-4479063491021217766
	.quad	-9164070410158966541
	.quad	-5598829363776522208
	.quad	-6843401994271320272
	.quad	-2386850686293264856
	.quad	-3942566474411762436
	.quad	1628122660560806834
	.quad	-316522074587315140
	.quad	-8205795374004271537
	.quad	-7115355324258153819
	.quad	-1033872180650563613
	.quad	-4282508136895304370
	.quad	-5904026244240592420
	.quad	-741449152691742558
	.quad	-5995859411864064214
	.quad	-7380934748073420955
	.quad	1728547772024695540
	.quad	-4614482416664388289
	.quad	-2451001303396518479
	.quad	-1156417002403097458
	.quad	5385653213018257807
	.quad	-7640289654143017767
	.quad	-7102991539009341454
	.quad	-4938676049251384305
	.quad	-8878739423761676818
	.quad	-1561659043136842477
	.quad	3674159897003727797
	.quad	-7893565929601608404
	.quad	4592699871254659746
	.quad	-5255271393574622601
	.quad	1129188820640936779
	.quad	-1957403223540890347
	.quad	3011586022114279439
	.quad	-8140906042354138323
	.quad	8376168546070237203
	.quad	-5564446534515285000
	.quad	-7976533391121755113
	.quad	-2343872149716718346
	.quad	1932195658189984911
	.quad	-8382449121214030822
	.quad	-6808127464117294670
	.quad	-5866375383090150624
	.quad	-3898473311719230433
	.quad	-2721283210435300376
	.quad	9092669226243950739
	.quad	-8618331034163144591
	.quad	-2469221522477225288
	.quad	-6161227774276542835
	.quad	6136845133758244198
	.quad	-3089848699418290639
	.quad	-3082000819042179232
	.quad	-8848684464777513506
	.quad	-8464187042230111944
	.quad	-6449169562544503978
	.quad	3254824252494523782
	.quad	-3449775934753242068
	.quad	-7189106879045698444
	.quad	-9073638986861858149
	.quad	-8986383598807123056
	.quad	-6730362715149934782
	.quad	2602078556773259892
	.quad	-3801267375510030573
	.quad	-1359087822460813039
	.quad	-139898200960150313
	.quad	-849429889038008149
	.quad	-7004965403241175802
	.quad	-5673473379724898090
	.quad	-4144520735624081848
	.quad	-2480155706228734709
	.quad	-568964901102714406
	.quad	-3855940325606653145
	.quad	-7273132090830278360
	.quad	-208239388580928527
	.quad	-4479729095110460046
	.quad	-4871985254153548563
	.quad	-987975350460687153
	.quad	-3044990783845967852
	.quad	-7535013621679011327
	.quad	5417133557047315993
	.quad	-4807081008671376254
	.quad	-2451955090545630817
	.quad	-1397165242411832414
	.quad	-3838314940804713212
	.quad	-7790757304148477115
	.quad	4425478360848884292
	.quad	-5126760611758208489
	.quad	920161932633717461
	.quad	-1796764746270372707
	.quad	2880944217109767366
	.quad	-8040506994060064798
	.quad	-5622191765467566601
	.quad	-5438947724147693094
	.quad	6807318348447705460
	.quad	-2186998636757228463
	.quad	-2662955059861265943
	.quad	-8284403175614349646
	.quad	-7940379843253970333
	.quad	-5743817951090549153
	.quad	8521269269642088700
	.quad	-2568086420435798537
	.quad	-6203421752542164322
	.quad	-8522583040413455942
	.quad	6080780864604458309
	.quad	-6041542782089432023
	.quad	-6234081974526590826
	.quad	-2940242459184402125
	.quad	5327070802775656542
	.quad	-8755180564631333184
	.quad	6658838503469570677
	.quad	-6332289687361778576
	.quad	8323548129336963346
	.quad	-3303676090774835316
	.quad	-4021154456019173716
	.quad	-8982326584375353929
	.quad	-5026443070023967146
	.quad	-6616222212041804507
	.quad	2940318199324816876
	.quad	-3658591746624867729
	.quad	8755227902219092404
	.quad	-9204148869281624187
	.quad	-2891023177508298208
	.quad	-6893500068174642330
	.quad	-8225464990312760664
	.quad	-4005189066790915008
	.quad	-5670145219463562926
	.quad	-394800315061255856
	.quad	7985374283903742932
	.quad	-7164279224554366766
	.quad	758345818024902857
	.quad	-4343663012265570553
	.quad	-3663753745896259333
	.quad	-817892746904575288
	.quad	-9207375118826243939
	.quad	-7428711994456441411
	.quad	-2285846861678029116
	.quad	-4674203974643163860
	.quad	1754377441329851509
	.quad	-1231068949876566920
	.quad	1096485900831157193
	.quad	-7686947121313936181
	.quad	-3241078642388441413
	.quad	-4996997883215032323
	.quad	5172023733869224042
	.quad	-1634561335591402499
	.quad	5538357842881958978
	.quad	-7939129862385708418
	.quad	-2300424733252327085
	.quad	-5312226309554747619
	.quad	6347841120289366951
	.quad	-2028596868516046619
	.quad	6273243709394548297
	.quad	-8185402070463610993
	.quad	3229868618315797467
	.quad	-5620066569652125837
	.quad	-574350245532641070
	.quad	-2413397193637769393
	.quad	-358968903457900669
	.quad	-8425902273664687727
	.quad	8774660907532399972
	.quad	-5920691823653471754
	.quad	1744954097560724157
	.quad	-2789178761139451788
	.quad	-8132775725879323210
	.quad	-8660765753353239224
	.quad	-5554283638921766109
	.quad	-6214271173264161126
	.quad	6892203506629956076
	.quad	-3156152948152813503
	.quad	-2609901835997359308
	.quad	-8890124620236590296
	.quad	1349308723430688769
	.quad	-6500969756868349965
	.quad	-2925050114139026943
	.quad	-3514526177658049553
	.quad	-1828156321336891839
	.quad	-9114107888677362827
	.quad	6938176635183661009
	.quad	-6780948842419315629
	.quad	4061034775552188357
	.quad	-3864500034596756632
	.quad	5076293469440235446
	.quad	-218939024818557886
	.quad	7784369436827535058
	.quad	-7054365918152680535
	.quad	-4104596259247744890
	.quad	-4206271379263462765
	.quad	-5130745324059681112
	.quad	-646153205651940552
	.size	global_constant_0, 9904

	.type	static_string_978d8d34847e5196,@object
	.p2align	4, 0x0
static_string_978d8d34847e5196:
	.asciz	"0123456789abcdefghijklmnopqrstuvwxyz"
	.size	static_string_978d8d34847e5196, 37

	.type	static_string_3dbcb4d72b465ec0,@object
	.p2align	4, 0x0
static_string_3dbcb4d72b465ec0:
	.asciz	"FIXED_WRITE_BUFFER_BYTES exceeded, increase with: `mojo -D FIXED_WRITE_BUFFER_BYTES=4096`\n"
	.size	static_string_3dbcb4d72b465ec0, 91

	.type	static_string_0d78baac08237ddb,@object
	.p2align	4, 0x0
static_string_0d78baac08237ddb:
	.asciz	"a"
	.size	static_string_0d78baac08237ddb, 2

	.type	static_string_0dcb71a55f79a509,@object
	.p2align	4, 0x0
static_string_0dcb71a55f79a509:
	.asciz	"At: %s:%llu:%llu: Assert Error: %s\n"
	.size	static_string_0dcb71a55f79a509, 36

	.section	".note.GNU-stack","",@progbits
