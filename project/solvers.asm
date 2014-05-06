# File: solvers.asm
# Author: Jenny Zhen
# Description: Solves a Skyscrapers puzzle.
# Arguments:
# 	
#
# Returns:
#

PRINT_STRING = 4

	.text							# this is program code
	
									# global data
	.globl	board_size
	.globl	board_array
	.globl	board_copy
	.globl	north_array
	.globl	east_array
	.globl	south_array
	.globl	west_array
	.globl	single_col_separator
	.globl	print_final_puzzle
	.globl	taken_array
	.globl	taken_array_orig

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
	
	mul	$s6, $s7, $s7
	addi	$s6, $s6, -1			# $s6 = maximum index of board
	
	move	$a0, $zero				# index of tile to try to modify
	jal setup_taken_array
	
	jal	try_tile_value				# Start backtracking algorithm
	
solve_puzzle_done:
									# restore for print_board to go skyscrapers
	lw	$ra, 0($sp)					# restore return address of the caller
	addi	$sp, $sp, 4
	
	jr	$ra
	
try_tile_value:	
	addi	$sp, $sp, -20			# save return address of the caller
	sw	$s4, 16($sp)
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	
	move	$s0, $a0				# save the index for the tile to modify

	jal check_if_valid
	
	bgt	$s0, $s6, try_tile_full		# check index of tile
	beq	$v0, $zero, try_tile_done
	
	li	$t9, 4
	mul	$s1, $s0, $t9
	add	$s1, $s1, $s5				# get the index of the tile on board_copy
	lw	$t9, 0($s1)					# load the value of the tile on board_copy
	bne	$t9, $zero, try_tile_taken	# tile has a value on the board already
	
try_tile_loop_start:
	li	$s2, 1						# initial guess for the tile
	
try_tile_loop:
	li	$t9, 4						# 4 bytes in a word
	la	$s4, board_array
	mul	$s1, $s0, $t9				
	add $s1, $s1, $s4				# offset into original board
	li	$v1, 77
	sw	$s2, 0($s1)					# store the guess into the board

	move	$a0, $s0
	addi	$a0, $a0, 1
	jal	try_tile_value				# recurse to next tile
	bne	$v0, $zero, try_tile_success	# check if puzzle solved (solved = 1)
	
	addi	$s2, $s2, 1
	bgt	$s2, $s7, try_tile_backtrack	# out of guesses, backtrack to parent
	j	try_tile_loop
	
try_tile_backtrack:
	addi	$s2, $s2, -1
	li	$t9, 4
	mul	$s1, $s0, $t9				
	add $s1, $s1, $s4				# offset into original board
	sw	$zero, 0($s1)				# remove the guess from the board
	
	
try_tile_full:
	beq	$v0, $zero, try_tile_done	# tile is invalid
	li	$v0, 1						# puzzle has been solved!
	
try_tile_taken:
	move	$a0, $s0
	addi	$a0, $a0, 1
	jal	try_tile_value				# recurse to next tile
	j	try_tile_success
	
try_tile_done:	
	move	$v0, $zero				# tell the parent to backtrack	
	
try_tile_success:	
	lw	$s4, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 20			# restore return address of the caller	
	jr	$ra

#
# Checks the last modified tile for correctness along the column and row.
#
# Arguments:	$a0, the index (+1) of the last modified cell.
#
check_if_valid:
	addi	$sp, $sp, -20			# save return address of the caller
	sw	$s3, 16($sp)
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	
	move	$t0, $zero				# initial bitfield for used values
	
	beq	$a0, $zero, check_if_valid_done	# don't want to check empty puzzle
	addi	$s0, $a0, -1			# offset for index to last modified tile
	div	$s0, $s7					
	mflo	$s1						# row, quotient
	mfhi	$s2						# col, remainder (modulo)
	
	la	$t0, north_array			# array to check
	move	$t1, $s7				# direction (positive row length)
	move	$t2, $s2				# index (offset into north array)
	move	$t3, $s2				# start index (col)
	li	$t4, 1						# positive direction
	jal	check_if_valid_loop_start
	beq	$v0, $zero, check_if_valid_invalid
	
	la	$t0, south_array			# array to check
	move	$t1, $s7				# direction (negative row length)
	move	$t2, $s2				# index (offset into south array)
	mul	$t4, $s7, $s7
	sub	$t3, $s7, $s2
	sub	$t3, $t4, $t3				# start index (size^2 - (size - col))
	move	$t4, $zero				# negative direction
	jal check_if_valid_loop_start
	beq	$v0, $zero, check_if_valid_invalid

	la	$t0, east_array				# array to check
	li	$t1, 1						# direction (move across row, backwards)
	move	$t2, $s2				# index (offset into east array)
	mul	$t3, $s7, $s1
	add	$t3, $t3, $s7
	addi	$t3, $t3, -1			# start index ((row*size)+(size - 1))
	move	$t4, $zero				# negative direction
	jal check_if_valid_loop_start
	beq	$v0, $zero, check_if_valid_invalid

	la	$t0, west_array				# array to check
	li	$t1, 1						# direction (move across row, forwards)
	move	$t2, $s2				# offset into array
	mul	$t3, $s7, $s1				# index to start (row*size)
	li	$t4, 1						# positive direction
	jal check_if_valid_loop_start
	beq	$v0, $zero, check_if_valid_invalid
	
	li	$v0, 1						# current board is valid
	j	check_if_valid_done
	
check_if_valid_invalid:
	li	$v0, 0
	
check_if_valid_done:				# check for the given row and column
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 20			# restore return address of the caller
	jr	$ra
	
#	Arguments: 	$t0: perimeter array to check
#				$t1: offset amount (direction to check in)
#				$t2: offset into perimeter array
#				$t3: start index
#				$t4: add or subtract direction (positive or negative)
check_if_valid_loop_start:
	addi	$sp, $sp, -4			# save return address of the caller
	sw	$ra, 0($sp)
	
	jal setup_taken_array
	
	li	$t5, 4
	mul	$t1, $t1, $t5				# offset into integer array
	mul	$t2, $t2, $t5				# offset into integer array
	mul	$t3, $t3, $t5				# offset into integer array
	la	$t5, board_array
	add	$t3, $t3, $t5				# offset into board
	add	$t0, $t0, $t2
	lw	$t0, 0($t0)					# number of towers need to see
	beq	$t0, $zero, check_if_valid_loop_success
	
	move	$v0, $zero				# number of towers seen
	move	$t2, $zero				# initial previous value
	li	$t6, 1				# counter, done when $t6 > $s7
	
check_if_valid_loop:
	lw	$t5, 0($t3)					# get tile value
	li	$t9, 4
	mul	$t9, $t5, $t9
	la	$t8, taken_array
	add $t9, $t8, $t9
	addi	$t9, $t9, -4						# towers are one-indexed
	lw	$t8, 0($t9)
	beq	$t8, $zero, duplicate_towers 		# duplicate tower
	sw	$zero, 0($t9)							# mark tower used
	beq	$t5, $zero, check_if_valid_loop_success	# tile has no guess, so is good
	bgt	$t5, $t2, can_see_tower
	j	check_if_valid_loop_incr
	
can_see_tower:
	addi	$v0, 1					# can see another tower
check_if_valid_loop_incr:
	move	$t2, $t5				# update previous value
	beq	$t4, $zero, check_if_valid_loop_decr
	add	$t3, $t3, $t1
	j	check_if_valid_loop_is_done

check_if_valid_loop_decr:			# for convenience of negatives, just sub
	sub	$t3, $t3, $t1
	
check_if_valid_loop_is_done:
	addi	$t6, $t6, 1
	bgt	$t6, $s7, check_if_valid_loop_done
	j	check_if_valid_loop
	
check_if_valid_loop_done:			# Counted all the towers
	bgt	$t0, $v0, cant_see_all_towers
	
check_if_valid_loop_success:		# can see the correct number of towers
	li	$v0, 1						# True case
	j	check_if_valid_loop_return
	
cant_see_all_towers:				# can't see all the correct number of towers
	li	$v0, 0						# False case
	j check_if_valid_loop_return

duplicate_towers:
	
check_if_valid_loop_return:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4			# restore return address of the caller
	jr	$ra
	
	
check_if_already_solved:			# check for the entire board


setup_taken_array:
	la $t9, 1
	la $t7, 1
	la $t8, taken_array

taken_loop:
	sb	$t9, 0($t8)
	addi	$t7, $t7, 1
	addi	$t8, $t8, 1
	bgt	$t7, $s7, setup_taken_done
	j taken_loop
	
setup_taken_done:
	jr $ra
	