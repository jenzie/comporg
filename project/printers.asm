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
									# save for print_north_row
	addi	$sp, $sp, -4			# save return address of the caller
	sw	$ra, 0($sp)
	
	jal	print_north_row
	jal	print_west_east_rows
	jal	print_south_row
	
									# restore for print_north_row
	lw	$ra, 0($sp)					# restore return address of the caller
	addi	$sp, $sp, 4
	
	jr	$ra
	
print_north_row:
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, three_spaces			# load the address to the string
	syscall							# tell the OS to print
	
	la	$t5, north_array			# load the address of an element in north
	lw	$t6, 0($t5)					# load the value of the element in north
	
	move	$t7, $zero				# count the number of tiles printed
	
									# save for print_tile
	addi	$sp, $sp, -4			# save return address of the caller
	sw	$ra, 0($sp)
	
	j	print_loop
	
print_south_row:
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, three_spaces			# load the address to the string
	syscall							# tell the OS to print
	
	la	$t5, south_array			# load the address of an element in south
	lw	$t6, 0($t5)					# load the value of the element in south
	
	move	$t7, $zero				# count the number of tiles printed
	
									# save for print_tile
	addi	$sp, $sp, -4			# save return address of the caller
	sw	$ra, 0($sp)
	
	j	print_loop
	
print_west_east_rows:
	la	$t1, west_array				# load the address of an element in west
	lw	$t2, 0($t1)					# load the value of the element in west
	
	la	$t3, east_array				# load the address of an element in east
	lw	$t4, 0($t3)					# load the value of the element in east
	
	la	$t5, board_array			# load the address of an element in board
	lw	$t6, 0($t5)					# load the value of the element in board
	
	move	$t8, $zero				# count the number of rows printed
	
									# save for print_loop_s
	addi	$sp, $sp, -4			# save return address of the caller
	sw	$ra, 0($sp)
	
	j	print_we_loop
	
print_we_loop:
	beq	$t8, $s7, print_we_done		# check counter for num rows
	
									# print west value
	li 	$v0, PRINT_STRING			# load the syscall code
	la 	$a0, $t2					# load the address to the string
	syscall							# tell the OS to print
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, space					# load the address to the string
	syscall							# tell the OS to print
	
	move	$t7, $zero				# count the number of tiles printed
	
									# save for print_tile
	addi	$sp, $sp, -4			# save return address of the caller
	sw	$ra, 0($sp)
	
	jal	print_loop_s
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, space					# load the address to the string
	syscall							# tell the OS to print
	
									# print east value
	li 	$v0, PRINT_STRING			# load the syscall code
	la 	$a0, $t4					# load the address to the string
	syscall							# tell the OS to print
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, new_line				# load the address to the string
	syscall							# tell the OS to print
	
print_we_done:
									# restore for print_loop_s
	lw	$ra, 0($sp)					# restore return address of the caller
	addi	$sp, $sp, 4
	
	jr	$ra
	
print_loop_s:
	beq	$t7, $s7, print_done_s		# check counter for num tiles
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, single_col_separator	# load the address to the string
	syscall							# tell the OS to print
	
	jal	print_tile
	
	addi	$t7, $t7, 1				# increment the counter
	addi	$t5, $t5, 4				# move the base pointer over
	lw	$t6, 0($t5)					# load the value of the tile
	j	print_loop
	
print_done_s:
									# restore for print_tile
	lw	$ra, 0($sp)					# restore return address of the caller
	addi	$sp, $sp, 4
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, single_col_separator	# load the address to the string
	syscall							# tell the OS to print
	
	jr	$ra
	
print_loop:
	beq	$t7, $s7, print_done		# check counter for num tiles
	
	jal	print_tile
	
	addi	$t7, $t7, 1				# increment the counter
	addi	$t5, $t5, 4				# move the base pointer over
	lw	$t6, 0($t5)					# load the value of the tile
	j	print_loop
	
print_done:
									# restore for print_tile
	lw	$ra, 0($sp)					# restore return address of the caller
	addi	$sp, $sp, 4
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, new_line				# load the address to the string
	syscall							# tell the OS to print
	
	jr	$ra
	
print_tile:
	beq	$t6, $zero, print_empty_tile	# check for null value
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, space					# load the address to the string
	syscall							# tell the OS to print
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la 	$a0, $t5					# load the address to the string
	syscall							# tell the OS to print
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, space					# load the address to the string
	syscall							# tell the OS to print
	
	jr	$ra
	
print_empty_tile:
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, three_spaces			# load the address to the string
	syscall							# tell the OS to print
	
	jr	$ra
	
print_row_divider:
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, two_spaces				# load the address to the string
	syscall							# tell the OS to print
	
	move	$t7, $zero				# count the number of tiles printed
	j	print_one_divider
	
print_one_divider:
	beq	$t7, $zero, print_div_done
	
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, single_row_separator	# load the address to the string
	syscall							# tell the OS to print
	
	addi	$t7, $t7, 1				# increment the counter
	j	print_one_divider
	
print_div_done:
	li 	$v0, PRINT_STRING			# load the syscall code
	la	$a0, row_terminator			# load the address to the string
	syscall							# tell the OS to print
	
	jr	$ra
