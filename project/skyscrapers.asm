# File: skyscrapers.asm
# Author: Jenny Zhen
# Description: Solves a Skyscrapers puzzle.
# Arguments:
# 	
#
# Returns:
#

# CONSTANTS
#
# syscall codes
PRINT_INT = 1
PRINT_STRING = 4
READ_INT = 5
EXIT = 10

	.data
	.align 2

board_array:
	.space	8*8*4	# room for input values, size for 8 by 8 words
	
north_array:		# room for input values, size for 8 words
	.space	8*4	

east_array:			# room for input values, size for 8 words
	.space	8*4	

south_array:		# room for input values, size for 8 words
	.space	8*4	

west_array:			# room for input values, size for 8 words
	.space	8*4	
	
	#
	# the print constants for the code
	#
	.align 0

banner_msg:	
	.ascii	"*******************\n"
	.ascii "** SKYSCRAPERS **\n"
	.asciiz	"*******************\n\n"

initial_msg:	
	.asciiz	"Initial Puzzle\n\n"
	
final_msg:
	.asciiz "Final Puzzle\n\n"
	
single_row_separator:
	.asciiz "+--"

single_col_separator:
	.asciiz " | "
	
row_terminator:
	.asciiz "+"

space:
	.asciiz " "
	
new_line:
	.asciiz "\n"
	
invalid_board_size:
	.asciiz "Invalid board size, Skyscrapers terminating\n"
	
illegal_input:
	.asciiz "Illegal input value, Skyscrapers terminating\n"
	
invalid_num_fv:
	.asciiz "Invalid number of fixed values, Skyscrapers terminating\n"
	
illegal_fv_input:
	.asciiz "Illegal fixed input values, Skyscrapers terminating\n"
	
impossible_puzzle:
	.asciiz "Impossible Puzzle\n"
	
	.text			# this is program code
	.align	2		# instructions must be on word boundaries
	.globl	main	# main is a global label
	
#
# Name:		MAIN PROGRAM
#
# Description:	Main logic for the program.
#
#	This program reads in numbers and places them in arrays representing the 
#	skyscrapers game board. Once the reading is done, a brute force method is 
#	applied to attempt to solve the puzzle.
#
	
main:
	