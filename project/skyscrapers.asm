# File: skyscrapers.asm
# Author: Jenny Zhen
# Description: Solves a Skyscrapers puzzle.
# Arguments:
# 	
#
# Returns:
#

# CONSTANTS
MIN_SIZE = 3
MAX_SIZE = 8

# syscall codes
PRINT_INT = 1
PRINT_STRING = 4
READ_INT = 5
EXIT = 10

#
# Name:		Data areas
#
# Description:	Data for the program, including: board data, puzzle messages, 
#		and error messages.
#

	.data
	.align 2
	
board_size:
	.space	4		# room for board size, size for 1 word

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
	.asciiz "Impossible Puzzle\n\n"
	
	.text			# this is program code
	.align	2		# instructions must be on word boundaries
	.globl	main	# main is a global label
	
#
# Name:		MAIN PROGRAM
#
# Description:	Main logic for the program.
#
#	This program reads in numbers and places them in arrays representing the 
#	skyscrapers game board. Once the reading is done, a brute-force method is 
#	applied to attempt to solve the puzzle.
#
	
main:
	
	li	$v0, READ_INT		# read in the value of the first integer param
	syscall
	
	sw	board_size, $v0		# store the value of the first param, board size
	blt	board_size, MIN_SIZE, error_board_size		# validate input
	bgt	board_size, MIN_SIZE, error_board_size		# validate input
	
	la	$a0, north_array	# store the address of the pointer to north_array
	jal	parse_board_perim	# parse the input for north
	la	$a0, east_array		# store the address of the pointer to east_array
	jal	parse_board_perim	# parse the input for east
	la	$a0, south_array	# store the address of the pointer to south_array
	jal	parse_board_perim	# parse the input for south
	la	$a0, west_array		# store the address of the pointer to west_array
	jal	parse_board_perim	# parse the input for west
	
error_board_size:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, invalid_board_size		# load the address to the string
	syscall							# tell the OS to print
	sysexit							# terminate program
	
error_input_value:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, illegal_input			# load the address to the string
	syscall							# tell the OS to print
	sysexit							# terminate program
	
error_num_fv:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, invalid_num_fv			# load the address to the string
	syscall							# tell the OS to print
	sysexit							# terminate program
	
error_fv_input:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, illegal_fv_input		# load the address to the string
	syscall							# tell the OS to print
	sysexit							# terminate program
	
error_impossible puzzle:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, impossible_puzzle		# load the address to the string
	syscall							# tell the OS to print
	sysexit							# terminate program

parse_board_perim:
	li	$t0, 0						# counter for the number of values read in
	
pbp_loop:
	li	$v0, READ_INT				# read in a single perimeter value
	syscall
	
	blt	$v0, $zero, error_input_value				# validate input
	bgt	$v0, board_size, error_input_value			# validate input
	
	sw	$v0, 0($a0)					# store the perimeter value
	addi	$a0, $a0, 4				# move address to base pointer over
	addi	$t0, $t0, 1				# increment counter
	beq	$t0, board_size, pbp_done
	j	pbp_loop

pbp_done:
	jr	$ra