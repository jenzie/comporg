# File:		traverse_tree.asm
# Author:	K. Reek
# Contributors:	P. White,
#		W. Carithers,
#		Jenny Zhen
#
# Description:	Binary tree traversal functions.
#
# Revisions:	$Log$


# CONSTANTS
#

# traversal codes
PRE_ORDER  = 0
IN_ORDER   = 1
POST_ORDER = 2

	.text			# this is program code
	.align 2		# instructions must be on word boundaries

#***** BEGIN STUDENT CODE BLOCK 3 *****************************
#
# Name:		traverse_tree
#
# Description: Traverse the nodes of the tree using pre-order, in-order, and 
# 				post-order traversals.
# Arguments:	a0: node to traverse
#				a1: pointer to the print function
#				a2: code indicating the type of traversal to perform
# Returns:	none

traverse_tree:

	# Saving the previous function caller's s-registers (the stack).
	# So that the upcoming function's modifications does not lose old data.

	addi	$sp, $sp, -20
	sw	$s0, 0($sp)			# saving the top of stack
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)		# saving the bottom of stack
	sw	$ra, 16($sp)		# saving the return address of previous function
	
	beq	$a0, $zero, traverse_done	# a0 node is null
	lw	$s0, 4($a0)					# a0's left node
	lw	$s1, 8($a0)					# a0's right node
	
	move $s2, $a0					# save the a0 node
	move $s3, $a1					# save the print function
	
	li	$t0, PRE_ORDER				# save the flag for pre_order
	li	$t1, IN_ORDER				# save the flag for in_order
	li	$t2, POST_ORDER				# save the flag for post_order
	
	beq	$t0, $a2, pre_order			# go to pre_order traversal
	beq $t1, $a2, in_order			# go to in_order traversal
	beq $t2, $a2, post_order		# go to post_order traversal
	
pre_order:
	# root, left, right
	
	move	$a0, $s2				# process root
	jalr	$s3						# go to function to print the node
	move	$a0, $s0				# traverse left
	jal	traverse_tree
	move	$a0, $s1				# traverse right
	jal	traverse_tree
	j	traverse_done				# processed all nodes

in_order:
	# left, root, right
	
	move	$a0, $s0				# traverse left
	jal	traverse_tree
	move	$a0, $s2				# process root
	jalr	$s3						# go to function to print the node
	move	$a0, $s1				# traverse right
	jal	traverse_tree
	j	traverse_done				# processed all nodes

post_order:
	# left, right, root
	
	move	$a0, $s0				# traverse left
	jal traverse_tree
	move	$a0, $s1				# traverse right
	jal	traverse_tree
	move	$a0, $s2				# process root
	jalr	$s3						# go to function to print the node
	j	traverse_done				# processed all nodes
	
traverse_done:
	
	# Restore the previous function caller's s-registers.
	# So that the modifications made from the traversals do not lose old data.
	
	lw	$s0, 0($sp)			# restoring the top of stack
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)		# restoring the bottom of stack
	lw	$ra, 16($sp)		# restoring the return address of previous function
	addi	$sp, $sp, 20	# undo the addi -20 from the beginning
	jr	$ra					# return to the function caller
 
#***** END STUDENT CODE BLOCK 3 *****************************
