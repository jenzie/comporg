# File:		$Id$
# Author:	K. Reek
# Contributors:	P. White, W. Carithers
#
# Description:	This program reads a list of numbers from the
#               standard input, and inserts them into a binary
#               search tree.  It then traverses the 
#               tree using preorder, inorder and postorder
#               traversals.
#
# Revisions:	$Log$


# CONSTANTS
#
# syscall codes
PRINT_INT = 	1
PRINT_STRING = 	4
READ_INT = 	5
EXIT = 		10

# traversal codes
PRE_ORDER  = 0
IN_ORDER   = 1
POST_ORDER = 2

	.data
	.align 2

input_array:		# room for input values, size for 20 words
	.space	20*4

running_total:		# running total for fourth traversal
	.word	0
	

	#
	# the print constants for the code
	#
	.align 0

data_msg:	
	.asciiz	"Original values\n"

build:	
	.asciiz	"Building tree\n"

traverse:	
	.asciiz	"Traversing tree\n"

msg1:	
	.asciiz	"  preorder :"

msg2:	
	.asciiz	"\n  inorder  :"

msg3:
	.asciiz	"\n  postorder:"

msg4:
	.asciiz	"\n  tree sum : "

new_line:
	.asciiz	"\n"

space:
	.asciiz	" "

quote:
	.asciiz	"'"

	#
	# a sample tree:
	#         6
	#    3         9
	#      4     7   12
	#                   16
	#
	.align 2
ptr_tree1:
	.word	tree1
tree1:	.word	6, n3, n9
n3:	.word	3, 0, n4
n4:	.word	4, 0, 0
n9:	.word	9, n7, n12
n7:	.word	7, 0, 0
n12:	.word	12, 0, n16
n16:	.word	16, 0, 0

ptr_root:
	.word 	0

	.text			# this is program code
	.align	2		# instructions must be on word boundaries
	.globl	main		# main is a global label
	.globl	add_elements
	.globl	traverse_tree

#
# Name:		MAIN PROGRAM
#
# Description:	Main logic for the program.
#
#	This program reads in numbers and places them in an array stopping
#	when the number 9999 is read in.  Once the reading is done, the array
#	of numbers are entered into a binary-search tree in the order that
#	they were read in.  Finally the tree is traversed in pre-order
#	in-order and post-order
#

main:
	addi 	$sp, $sp, -12  	# allocate space for the return address
	sw 	$ra, 8($sp)	# store the ra on the stack
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)

	#
	# read in the numbers till a 9999 is read in or we have filled
	# the array (20 elements)
	#

	li 	$t0, 0			# i=0;
	li	$t2, 20			# the max size of the array
	la	$t1, input_array	# t1 is pointer to array
	li	$t3, 9999		# the terminating value
ra_loop:	
	beq 	$t0, $t2, ra_done	# done if i==20

	li 	$v0, READ_INT 		# read one int
	syscall

	beq	$v0, $t3, ra_done	# stop if the value 9999 is read in

	sw 	$v0, 0($t1)		# if not 9999, save value in the array

	addi 	$t1, $t1, 4		# update pointer
	addi 	$t0, $t0, 1		# and count
	j ra_loop
ra_done:

	#
	# Echo the values to be insert into the tree
	#

	li 	$v0, PRINT_STRING	# print original value msg
	la 	$a0, data_msg
	syscall	
	
	la 	$a0, input_array	# print out the original array
	move 	$a1, $t0
	jal 	print_array

	li 	$v0, PRINT_STRING
	la 	$a0, new_line
	syscall	
	
	#
	# build the tree
	#

	la	$a0, input_array
	move	$a1, $t0
	la	$a2, ptr_root
	jal	add_elements

	#
	# traverse the tree
	#

	la	$a0, ptr_root	# change to ptr_tree1 for testing
	jal	perform_traversals

#
# All done -- exit the program!
#
main_done:
	lw 	$ra, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, 12   	# deallocate space for the return address
	jr 	$ra		# return from main and exit

#
# Name:		perform_traversals
#
# Description:	performs a series of traversals on a tree
#
# Arguments:	a0 the address of the location which contains the
#		   root pointer
#
# Returns:	none
#

perform_traversals:

	addi 	$sp, $sp, -8  	# allocate space for the return address
	sw 	$ra, 4($sp)	# store the ra on the stack
	sw 	$s0, 0($sp)
	
	addi	$s0, $a0, 0	# save the root pointer's address

# Perform a pre-order traversal

	li 	$v0, PRINT_STRING
	la 	$a0, msg1
	syscall				# print a pre-order msg

	lw	$a0, 0($s0)
	la	$a1, print_func1
	li	$a2, PRE_ORDER	# doing pre-order traversal
	jal	traverse_tree


# Perform an in-order traversal

	li 	$v0, PRINT_STRING
	la 	$a0, new_line
	syscall			# print a new_line

	li 	$v0, PRINT_STRING
	la 	$a0, msg2
	syscall			# print a in-order msg

	lw	$a0, 0($s0)
	la	$a1, print_func2
	li	$a2, IN_ORDER	# doing in-order traversal
	jal	traverse_tree

	li 	$v0, PRINT_STRING
	la 	$a0, new_line
	syscall			# print a new_line

# Perform a post-order traversal

	li 	$v0, PRINT_STRING
	la 	$a0, msg3
	syscall			# print a post-order msg

	lw	$a0, 0($s0)
	la	$a1, print_func1
	li	$a2, POST_ORDER	# doing post-order traversal
	jal	traverse_tree

	li 	$v0, PRINT_STRING
	la 	$a0, new_line
	syscall			# print a new_line

# Finally, do a traversal to sum up the contents of the tree

	li 	$v0, PRINT_STRING
	la 	$a0, msg4
	syscall

	lw	$a0, 0($s0)
	la	$a1, print_func3
	li	$a2, IN_ORDER
	jal	traverse_tree

	li	$v0, PRINT_INT
	lw	$a0, running_total
	syscall

	li 	$v0, PRINT_STRING
	la 	$a0, new_line
	syscall			# print a new_line

#
# All done
#

	lw 	$ra, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, 8   	# deallocate space for the return address
	jr 	$ra		# return to the caller

# 
# Name:		print_array
#
# Description:	prints an array of integers
#
# Arguments:	a0 the address of the array
#   		a1 the number of elements in the array
# Returns:	none
#
	
print_array:

	li 	$t0, 0			# i=0;
	move 	$t1, $a0		# t1 is pointer to array

pa_loop:	

	beq 	$t0, $a1, pa_done	# done if i==n

	lw 	$a0, 0($t1)		# get a[i]
	li 	$v0, PRINT_INT
	syscall				# print one int

	li 	$v0, PRINT_STRING
	la 	$a0, space
	syscall				# print a space

	addi 	$t1, $t1, 4		# update pointer
	addi 	$t0, $t0, 1		# and count
	j pa_loop
pa_done:
	li 	$v0, PRINT_STRING
	la 	$a0, new_line
	syscall				# print a new_line

	jr 	$ra

# 
# Name:		print_func1
#
# Description:	just prints an integers out of a tree node
#
# Arguments:	a0 the address of the number to print
# Returns:	none
#
	
print_func1:

	move	$t0, $a0

	li 	$v0, PRINT_STRING
	la 	$a0, space
	syscall			# print a space

	lw 	$a0, 0($t0)	# get 0(t0)
	li 	$v0, PRINT_INT
	syscall			# print one int

	jr 	$ra

# 
# Name:		print_func2
#
# Description:	prints an integers out of a tree node in single
#		quotes, like '#'
#
# Arguments:	a0 the address of the number to print
# Returns:	none
#
	
print_func2:

	move	$t0, $a0

	li 	$v0, PRINT_STRING
	la 	$a0, space
	syscall			# print a space

	li 	$v0, PRINT_STRING
	la 	$a0, quote
	syscall			# print a quote

	lw 	$a0, 0($t0)	# get 0(t0)
	li 	$v0, PRINT_INT
	syscall			# print one int

	li 	$v0, PRINT_STRING
	la 	$a0, quote
	syscall			# print a quote

	jr 	$ra

# 
# Name:		print_func3
#
# Description:	adds the value from the current node to a running
#		total
#
# Arguments:	a0 the address of the number to print
# Returns:	none
#
print_func3:

	lw	$t0, running_total
	lw 	$t1, 0($a0)		# get the current number
	add	$t0, $t0, $t1
	sw	$t0, running_total	# update the total

	jr 	$ra
