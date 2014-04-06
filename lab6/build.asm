# File:		build.asm
# Author:	K. Reek
# Contributors:	P. White,
#		W. Carithers,
#		Jenny Zhen
#
# Description:	Binary tree building functions.
#
# Revisions:	$Log$


	.text			# this is program code
	.align 2		# instructions must be on word boundaries

# 
# Name:		add_elements
#
# Description:	loops through array of numbers, adding each (in order)
#		to the tree
#
# Arguments:	a0 the address of the array
#   		a1 the number of elements in the array
#		a2 the address of the root pointer
# Returns:	none
#

	.globl	add_elements
	
add_elements:
	addi 	$sp, $sp, -16
	sw 	$ra, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)

#***** BEGIN STUDENT CODE BLOCK 1 ***************************
#
# Insert your code to iterate through the array, calling build_tree
# for each value in the array.  Remember that build_tree requires
# two parameters:  the address of the variable which contains the
# root pointer for the tree, and the number to be inserted.

	STOP_VAL = 9999		# stop reading node values when 9999 is read in
	STOP_NUM = 20		# stop reading node values when 20 values were read
	
	li	$t0, 0			# counter for number of nodes added to the tree
	move	$s0, $a0	# save the pointer to the array of node values to add
	move	$s1, $a1	# save the number of elements left to be read
	
read_array_of_values:
	lw	$t1, 0($s0)		# store the next value of a node to be added to the tree
	beq	$t1, STOP_VAL, add_done		# stop if the value read in was 9999
	addi	$s1, -1		# decrement the number of elements left to be read
	addi	$t0, 1		# increment the number of nodes added to the tree
	move	$a0, $a2	# set the pointer to the root node of the tree
	move	$a1, $t1	# set the value of the node to be added to the tree
	jal	build_tree
	beq	$t0, STOP_NUM, add_done		# stop if 20 values were read
	beq	$s1, $zero, add_done		# stop if 0 values left to be read
	addi	$s0, 4		# move the pointer to the array of node values to add
	j	read_array_of_values

#***** END STUDENT CODE BLOCK 1 *****************************

add_done:

	lw 	$ra, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, 16
	jr 	$ra

#***** BEGIN STUDENT CODE BLOCK 2 ***************************
#
# Put your build_tree subroutine here.
#
#***** END STUDENT CODE BLOCK 2 *****************************
