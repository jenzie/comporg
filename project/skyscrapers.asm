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

north_array:		# room for input values, size for 8 words
	.space	8*4	

east_array:		# room for input values, size for 8 words
	.space	8*4	

south_array:		# room for input values, size for 8 words
	.space	8*4	

west_array:		# room for input values, size for 8 words
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
	
single_row_separator:
	.asciiz "+--"

single_col_separator:
	.asciiz " | "
	
row_terminator:
	.asciiz "+"

open_space:
	.asciiz " "
	
main:
	