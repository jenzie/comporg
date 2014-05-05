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
	li	$s2, 1						# Our guess for the tile
	
try_tile_loop:
	li	$t9, 4
	mul	$s1, $s0, $t9
	add $s1, $s1, $s4				# offset into original board
	sw	$s2, 0($s1)					# Store our guess into the board

	# Recurse to next tile
	move	$a0, $s0
	addi	$a0, $a0, 1
	jal	try_tile_value
	bne	$v0, $zero, try_tile_done
	
	addi	$s2, $s2, 1
	bgt	$s2, $s7, try_tile_backtrack	# Ran out of guesses, backtrack to parent
	j	try_tile_loop
	
	# fail, return to parent for backtracking
	
try_tile_done:
	lw	$s2, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12			# restore return address of the caller
	
	move	$v0, $zero				# tell the parent to backtrack
	
	jr	$ra
	
check_if_solved:
	addi	$sp, $sp, -4			# save return address of the caller
	sw	$ra, 0($sp)
	
	li	$t0, $zero					# bitfield for used values
	

	
check_if_solved_done:				# check for the given row and column
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4			# restore return address of the caller
	jr	$ra
	
	
check_if_already_solved:			# check for the entire board
	