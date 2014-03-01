# File:		add_ascii_numbers.asm
# Author:	K. Reek
# Contributors:	P. White, W. Carithers
#				Jenny Zhen
#
# Updates:
#		3/2004	M. Reek, named constants
#		10/2007 W. Carithers, alignment
#		09/2009 W. Carithers, separate assembly
#
# Description:	Add two ASCII numbers and store the result in ASCII.
#
# Arguments:	a0: address of parameter block.  The block consists of
#		four words that contain (in this order):
#
#			address of first input string
#			address of second input string
#			address where result should be stored
#			length of the strings and result buffer
#
#		(There is actually other data after this in the
#		parameter block, but it is not relevant to this routine.)
#
# Returns:	The result of the addition, in the buffer specified by
#		the parameter block.
#

	.globl	add_ascii_numbers

add_ascii_numbers:
A_FRAMESIZE = 40

#
# Save registers ra and s0 - s7 on the stack.
#
	addi 	$sp, $sp, -A_FRAMESIZE
	sw 	$ra, -4+A_FRAMESIZE($sp)
	sw 	$s7, 28($sp)
	sw 	$s6, 24($sp)
	sw 	$s5, 20($sp)
	sw 	$s4, 16($sp)
	sw 	$s3, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)
	
# ##### BEGIN STUDENT CODE BLOCK 1 #####

	lw	$s0, 0($a0)		# 1st input; s0 = address at 0 bits of offset from a0
	lw	$s1, 4($a0)		# 2nd input; s0 = address at 4 bits of offset from a0
	lw	$s2, 8($a0)		# storage of result; s0 = address at 8 bits of offset from a0
	lw	$s3, 12($a0)	# length; s0 = address at 12 bits of offset from a0
	li	$t9, 0			# set the carry value to 0
	li	$t8, -48		# set the ascii offset to -48 (48 represents 0 in ascii)
	li	$t7, 58			# set the overflow ascii value (58 represents 10 in ascii)
	
add_loop:
	beq	$s3, $zero, done	# go to done, if length of input is zero
	addi $s3, $s3, -1		# decrement the counter for the number of digits left
	add	$t0, $s0, $s3		# get the address of the next 'digit' of 1st input
	add $t1, $s1, $s3		# get the address of the next 'digit' of 2nd input
	lb	$t2, 0($t0)			# t2 = next digit of 1st input
	lb	$t3, 0($t1)			# t3 = next digit of 2nd input
	add $t4, $t2, $t3		# t4 = digit of 1st input + digit of 2nd input
	add	$t4, $t4, $t9		# t4 = sum of digits + carry
	add $t4, $t4, $t8		# t4 = sum of digits + carry + offset
	li	$t9, 0				# reset value of carry to 0
	slt	$t5, $t4, $t7		# t4 < 58 => 1; if 0, check for overflow
	beq	$t5, $zero, carry	# if t5 == 0; if overflow, go to carry
	j	store_sum			# store the result, with no overflow

carry:
	addi	$t4, $t4, -10	# remove the carry from the sum
	li		$t9, 1			# set the carry
	j		store_sum		# store the result, after modifying for carry
	
store_sum:
	add	$t6, $s2, $s3		# get the address of the next 'digit' of the result
	sb	$t4, 0($t6)			# store the result of the sum of the input for the 'digit'
	j	add_loop			# loop to get sum of next pair of 'digits'

done:

# ###### END STUDENT CODE BLOCK 1 ######

#
# Restore registers ra and s0 - s7 from the stack.
#
	lw 	$ra, -4+A_FRAMESIZE($sp)
	lw 	$s7, 28($sp)
	lw 	$s6, 24($sp)
	lw 	$s5, 20($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, A_FRAMESIZE

	jr	$ra			# Return to the caller.
