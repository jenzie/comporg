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
MIN_HEIGHT = 1

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
	.asciiz "|"
	
row_terminator:
	.asciiz "+\n"

space:
	.asciiz " "
	
two_spaces:
	.asciiz "  "
	
three_spaces:
	.asciiz "   "
	
four_spaces:
	.asciiz	"    "
	
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
	
	.text							# this is program code
	.align	2						# instructions must be on word boundaries
	
									# global labels
	.globl	main					# from skyscrapers.asm
	.globl	print_banner			# from printers.asm
	.globl	print_initial_puzzle	# from printers.asm
	.globl	print_final_puzzle		# from printers.asm
	
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
	
	li	$v0, READ_INT		# read in the value of the first integer parameter
	syscall
	
	la	$t0, board_size
	sw	$v0, 0($t0)			# store the value of the first param, board size
	
	move	$s7, $v0		# store the board size into $s7 for easier access
	blt	$s7, MIN_SIZE, error_board_size				# validate input
	bgt	$s7, MAX_SIZE, error_board_size				# validate input
	
	la	$a0, north_array	# store the address of the pointer to north_array
	jal	parse_board_perim	# parse the input for north
	la	$a0, east_array		# store the address of the pointer to east_array
	jal	parse_board_perim	# parse the input for east
	la	$a0, south_array	# store the address of the pointer to south_array
	jal	parse_board_perim	# parse the input for south
	la	$a0, west_array		# store the address of the pointer to west_array
	jal	parse_board_perim	# parse the input for west
	
	li	$v0, READ_INT		# read in the value of the next integer parameter
	syscall
	
	move	$a1, $v0		# store the number of fixed values
	blt	$a1, $zero, error_num_fv					# validate input
	
	la	$a0, board_array	# store the address of the pointer to board_array
	jal	parse_board			# parse the input for board
	
	jal	print_banner
	jal	print_initial_puzzle
	jal	print_final_puzzle
	
	li	$v0, EXIT
	syscall							# terminate program
	
error_board_size:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, invalid_board_size		# load the address to the string
	syscall							# tell the OS to print
	li	$v0, EXIT
	syscall							# terminate program
	
error_input_value:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, illegal_input			# load the address to the string
	syscall							# tell the OS to print
	li	$v0, EXIT
	syscall							# terminate program
	
error_num_fv:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, invalid_num_fv			# load the address to the string
	syscall							# tell the OS to print
	li	$v0, EXIT
	syscall							# terminate program
	
error_fv_input:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, illegal_fv_input		# load the address to the string
	syscall							# tell the OS to print
	li	$v0, EXIT
	syscall							# terminate program
	
error_impossible_puzzle:
	li	$v0, PRINT_STRING			# load the syscall code
	la	$a0, impossible_puzzle		# load the address to the string
	syscall							# tell the OS to print
	li	$v0, EXIT
	syscall							# terminate program

parse_board_perim:
	li	$t0, 0						# counter for the number of values read in
	
pbp_loop:
	beq	$t0, $s7, pbp_done
	li	$v0, READ_INT				# read in a single perimeter value
	syscall
	
	li	$v0, PRINT_INT
	move $a0, $v0
	syscall
	
	blt	$v0, $zero, error_input_value				# validate input
	bgt	$v0, $s7, error_input_value					# validate input
	
	move	$v0, $a0				# store the perimeter value
	addi	$a0, $a0, 4				# move address to base pointer over
	addi	$t0, $t0, 1				# increment counter
	j	pbp_loop

pbp_done:
	jr	$ra
	
parse_board:
	li	$t0, 0						# counter for the number of values read in
	
pb_loop:
	beq	$t0, $a1, pb_done			# no fixed values to be read

	li	$v0, READ_INT				# read in the row
	syscall
	blt	$v0, $zero, error_fv_input					# validate input
	bgt	$v0, $s7, error_fv_input					# validate input
	move	$s0, $v0				# store the row value
	
	li	$v0, READ_INT				# read in the col value
	syscall
	blt	$v0, $zero, error_fv_input					# validate input
	bgt	$v0, $s7, error_fv_input					# validate input
	move	$s1, $v0				# store the col value
	
	li	$v0, READ_INT				# read in the fixed value
	syscall
	blt	$v0, MIN_HEIGHT, error_fv_input				# validate input
	bgt	$v0, $s7, error_fv_input					# validate input
	move	$s2, $v0				# store the fixed value
	
	mul	$s3, $s0, $s7
	add	$s3, $s3, $s1				# get the index of the piece
	
	li	$t9, 4
	mul	$s3, $s3, $t9				# get the displacement/offset
	add	$s3, $s3, $a0				# move the pointer over
	
	sw	$s2, 0($s3)					# store the fixed value
	
	addi	$a0, $a0, 4				# move address to base pointer over
	addi	$t0, $t0, 1				# increment counter
	j	pb_loop
	
pb_done:
	jr	$ra
