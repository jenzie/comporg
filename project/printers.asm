# File: printers.asm
# Author: Jenny Zhen
# Description: Prints a Skyscrapers puzzle.
# Arguments:
# 	
#
# Returns:
#

#
# Name: print_puzzle
#
# Description:	Print a single Skyscrapers puzzle.
# Arguments:
#

print_banner:
	li 	$v0, PRINT_STRING			# load the syscall code
	la 	$a0, banner_msg				# load the address to the string
	syscall							# tell the OS to print

print_initial_puzzle:
	li 	$v0, PRINT_STRING			# load the syscall code
	la 	$a0, initial_msg			# load the address to the string
	syscall							# tell the OS to print
	
	j	print_board
	
print_final_puzzle:
	li 	$v0, PRINT_STRING			# load the syscall code
	la 	$a0, final_msg				# load the address to the string
	syscall							# tell the OS to print
	
	j	print_board
	
print_board:
	# print north
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$t7, north_array
	
	la	$a0, four_spaces			# load the address to the string
	syscall							# tell the OS to print
	
	la 	$a0, $t7		# check for null values
	syscall
	addi	$t7, $t7, 4
	
	la 	$a0, $t7
	syscall
	addi	$t7, $t7, 4
	
	la 	$a0, $t7
	syscall
	addi	$t7, $t7, 4
	
	la 	$a0, $t7
	syscall
	addi	$t7, $t7, 4