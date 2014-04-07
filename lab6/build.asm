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
	li	$t5, STOP_VAL	# cannot use the value of STOP_VAL on beq w/o loading
	beq	$t1, $t5, add_done			# stop if the value read in was 9999
	addi	$s1, -1		# decrement the number of elements left to be read
	addi	$t0, 1		# increment the number of nodes added to the tree
	move	$a0, $a2	# set the pointer to the root node of the tree
	move	$a1, $t1	# set the value of the node to be added to the tree
	jal	build_tree
	li	$t5, STOP_NUM	# cannot use the value of STOP_NUM on beq w/o loading
	beq	$t0, $t5, add_done			# stop if 20 values were read
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

# a0	double pointer to the pointer of the root of the tree
build_tree:
	.globl allocate_mem	# create space for the node, possible left/right nodes
	
	# Saving the previous function caller's s-registers (the stack).
	# So that the upcoming function's modifications does not lose old data.

	addi	$sp, $sp, -16
	sw	$s0, 0($sp)			# saving the top of stack
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)			# saving the bottom of stack
	sw	$ra, 12($sp)		# saving the return address of previous function
	
	move	$s0, $a0		# save the p2p to the root node of the tree
	move	$s1, $a1		# save the value of the node to add to the tree
	li	$a0, 3				# create 3 spaces: new node, new nodes's left/right
	jal	allocate_mem
	lw	$t0, 0($s0)			# check if p2p of the root node given is empty
	beq	$t0, $zero, create_node
	lw	$s0, 0($s0)			# get the pointer to the current node
	
check_if_node_exists:
	lw	$t0, 0($s0)			# get the value of the current node
	beq	$t0, $s1, build_tree_done	# value of node exists in tree already
	slt	$t1, $t0, $s1		# if current < new node, add to the right of current
	bne	$t1, $zero, add_left		# otherwise, add to the left
	addi	$s0, 4			# proceed to insert to the right
	j	add_node
	
create_node:
	sw	$v0, 0($s0)			# save the pointer of the node (v0) into the 
							# p2p of the node of the tree (s0)
	sw	$s1, 0($v0)			# save the value of the node (s1) into the 
							# pointer of the node (v0)
	j	build_tree_done
							
add_left:
	addi	$s0, 8			# move the p2p of the current node of the tree (s0) 
							# over by 8 to get to the left node
							
add_node:
	lw	$t0, 0($s0)			# check if p2p of the node given is empty
	bne	$t0, $zero, retry_add		# try to add as a child of the node
	j create_node
	
retry_add:
	move	$s0, $t0		# move the p2p of the current node of the tree
	j	check_if_node_exists
	
build_tree_done:
	
	# Restore the previous function caller's s-registers.
	# So that the modifications made from the traversals do not lose old data.
	
	lw	$s0, 0($sp)			# restoring the top of stack
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)			# restoring the bottom of stack
	lw	$ra, 12($sp)		# restoring the return address of previous function
	addi	$sp, $sp, 16	# undo the addi -16 from the beginning
	jr	$ra					# return to the function caller

#***** END STUDENT CODE BLOCK 2 *****************************
