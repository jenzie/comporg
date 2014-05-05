# File: solvers.asm
# Author: Jenny Zhen
# Description: Solves a Skyscrapers puzzle.
# Arguments:
# 	
#
# Returns:
#

#
# Name: solve_puzzle
#
# Description:	Solve a single Skyscrapers puzzle.
# Arguments:
#

solve_puzzle:
									# save for print_board to go to skyscrapers
	addi	$sp, $sp, -4			# save return address of the caller
	sw	$ra, 0($sp)
	
	mul	$s8, $s7, $s7
	addi	$s8, $s8, -1			# $s8 = maximum index of board
	
	move	$a0, $zero				# index of tile to try to modify
	
	jal	try_tile_value				# Start backtracking algorithm
	
solve_puzzle_done:
									# restore for print_board to go skyscrapers
	lw	$ra, 0($sp)					# restore return address of the caller
	addi	$sp, $sp, 4
	
	jr	$ra
	
try_tile_value:	
	addi	$sp, $sp, -12			# save return address of the caller
	sw	$s2, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	
	move	$s0, $a0				# save the index for the tile to modify
	
	jal check_if_solved
	
	bgt	$s0, $s8, try_tile_invalid	# check index of tile
	
	li	$t9, 4
	mul	$s1, $s0, $t9
	add	$s1, $s1, $s5				# get the index of the tile on board_copy
	lw	$t9, 0($s1)					# load the value of the tile on board_copy
	bne	$t9, $zero, try_tile_taken	# tile has a value on the board already
	
	# try 1
	# ...
	# try n
	
try_tile_loop_start:
	li	$s2, 1						# initial guess for the tile
	
try_tile_loop:
	li	$t9, 4						# 4 bytes in a word
	mul	$s1, $s0, $t9				
	add $s1, $s1, $s4				# offset into original board
	sw	$s2, 0($s1)					# store the guess into the board

	move	$a0, $s0
	addi	$a0, $a0, 1
	jal	try_tile_value				# recurse to next tile
	bne	$v0, $zero, try_tile_done	# check if puzzle solved (solved = 1)
	
	addi	$s2, $s2, 1
	bgt	$s2, $s7, try_tile_backtrack	# out of guesses, backtrack to parent
	j	try_tile_loop
	
try_tile_done:
	lw	$s2, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12			# restore return address of the caller
	
	move	$v0, $zero				# tell the parent to backtrack
	
	jr	$ra

#
# Checks the last modified tile for correctness along the column and row.
#
# Arguments:	$a0, the index (+1) of the last modified cell.
#
check_if_solved:
	addi	$sp, $sp, -20			# save return address of the caller
	sw	$s3, 16($sp)
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	
	li	$t0, $zero					# initial bitfield for used values
	
	beq	$a0, $zero, check_if_solved_done	# don't want to check empty puzzle
	addi	$s0, $a0, -1			# offset for index to last modified tile
	div	$s0, $s7					
	mflo	$s1						# row, quotient
	mfhi	$s2						# col, remainder (modulo)
	
	la	$t0, north_array			# array to check
	move	$t1, $s7				# direction (positive row length)
	move	$t2, $s1				# index (offset into north array)
	move	$t3, $s2				# start index (col)
	jal	check_if_solved_loop_start
	beq	$v0, $zero, check_if_solved_invalid
	
	la	$t0, south_array			# array to check
	li	$t1, -1
	mul	$t1, $t1, $s7				# direction (negative row length)
	move	$t2, $s1				# index (offset into south array)
	mul	$t4, $s7, $s7
	sub	$t3, $s7, $s1
	add	$t3, $t3, $t4				# start index
	jal check_if_solved_loop_start
	beq	$v0, $zero, check_if_solved_invalid
	
	la	$t0, east_array				# array to check
	li	$t1, -1						# direction (move across row, backwards)
	move	$t2, $s2				# index (offset into east array)
	mul	$t3, $S7, $s1
	add	$t3, $t3, $s7
	sub	$t3, $t3, 1					# start index
	jal check_if_solved_loop_start
	beq	$v0, $zero, check_if_solved_invalid
	
	la	$t0, west_array				# array to check
	li	$t1, 1						# direction (move across row, forwards)
	move	$t2, $s2				# offset into array
	mul	$t3, $s7, $s1				# index to start
	jal check_if_solved_loop_start
	beq	$v0, $zero, check_if_solved_invalid
	
	
	li	$v0, 1						# current board is valid
	j	check_if_solved_done
	
check_if_solved_invalid:
	li	$v0, 0
	j	check_if_solved_done
	
check_if_solved_done:				# check for the given row and column
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 20				# restore return address of the caller
	jr	$ra
	
#	Arguments: 	$t0: perimeter array to check
#				$t1: offset amount (direction to check in)
#				$t2: offset into perimeter array
#				$t3: start index
check_if_solved_loop_start:
	li	$t5, 4
	mul $t5, $t5, $t4
	add	$t5, $t2, $t5
	lw	$t5, 0($t5)
	
check_if_solved_loop:
	


	j	check_if_solved_loop
	
	jr $ra
	
	
check_if_already_solved:			# check for the entire board
	