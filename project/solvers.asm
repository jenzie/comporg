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
	
	move	$a0, $zero				# index of tile to try to modify
	
try_tile_value:
	
	# Valid tile? (larger than board)
	
	# Tile taken?
	
	# try 1
	# ...
	# try n
	
	# fail, return to parent for backtracking
	
solve_puzzle_done:
									# restore for print_board to go skyscrapers
	lw	$ra, 0($sp)					# restore return address of the caller
	addi	$sp, $sp, 4
	
	jr	$ra