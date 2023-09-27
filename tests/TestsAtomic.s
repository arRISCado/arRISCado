	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
  addi t0, zero, 1
  addi t1, zero, 2
  addi t2, zero, 3
  addi t3, zero, 4

  amoadd.w s2, t0, (t1)
  amoswap.w s3, t2, (t3)
  amoand.w s4, s2, (s3)
  amoxor.w s5, s2, (s3)
  amoor.w s6, s2, (s3)
  amomin.w s7, s2, (s3)
  amomax.w s8, s2, (s3)
  amominu.w s9, s2, (s3)
  amomaxu.w s10, s2, (s3)
  addi a0, zero, 10

# Expected final state:
# s2: 0
# s3: 0
# s4: 65536
# s5: 0
# s6: 0
# s7: 0
# s8: 0
# s9: 0
# s10: 0
# a0: 10
