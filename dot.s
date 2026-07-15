# You can change these values to test your solution.
.data
A:    .word 6, 1, 3, 9, 12, 4, 13, 153
B:    .word 6, 1, 3, 9, 12, 4, 13, 153
SIZE: .word 8

.text
main:
  la a1, A            # a1 = pointer to array A
  la a2, B            # a2 = pointer to array B
  lw a3, SIZE         # a3 = number of elements in each array
  jal ra, dot         # call dot function
exit:
  li a7, 10           # exit syscall code
  ecall               # terminate the program


# ==========================================================================
# FUNCTION: dot
#   This function computes the dot product of two integer arrays.
# Arguments:
#   a1 = pointer to first array
#   a2 = pointer to second array
#   a3 = array length
# Returns:
#   a0 = status code
#   a1 = dot product result
# ===========================================================================

dot:
  # Check the exception if (a3 < 1) <=> if (a3 <= 0) (integers)
  ble a3, x0, code_50  # SIZE <= 0
  # Initialize variables
  li t0, 0             # t0 = counter for each iteration (i = 0)
  li t1, 0             # t1 = accumulator of the dot product

loop:
  # Check if the array has reached the end
  bge t0, a3, code_0   # if (i >=  array_size) break; stop the loop
    
  lw t2, 0(a1)         # Get A[i] to t2
  lw t3, 0(a2)         # Get B[i] to t3
    
  # Process the word in the first position of the array
  
  mul t4, t2, t3       # t4 = t2 * t3 <=> t4 = A[i] * B[i] # x

product_overflow_check:
  # Get operand signs
  xor t5, t2, t3       # 1st bit = 0 (same signs) [t5>0] or 1 (otherwise) [t5<0]

  # If the operands have opposite signs (t5 < 0)
  blt t5, x0, opposite_signs  # check the product sign

  # If the operands have the same sign and product < 0 -> overflow
  blt t4, x0, code_200 # Same-sign operands -> product > 0

  j handle_sum         # Product check passed -> accumulate dot product

opposite_signs:
  # If the operands have different signs and product > 0 -> overflow
  bgt t4, x0, code_200 # Diff-sign operands -> product < 0

  # Product check passed -> accumulate dot product

handle_sum:
  mv t6, t1            # Save previous accumulator value
  add t1, t6, t4       # t1 = prev_accum + current_product
  
  # Move the pointers for each array to the next word
  addi a1, a1, 4       # Each word is 4 bytes
  addi a2, a2, 4
  # Add one iteration to the counter (i++)
  addi t0, t0, 1       

  # Get operand signs
  xor t5, t6, t4       # 1st bit = 0 (same signs) [t5>0] or 1 (otherwise) [t5<0]

  # If the operands have the same sign could be overflow
  bge t5, x0, sum_overflow_check 

  j loop               # Jump to the next iteration

sum_overflow_check:
  # Check previous_accumulator (t6) and current_accumulator (t1) signs
  xor t5, t1, t6      # 1st bit = 0 (same signs) [t6>0] or 1 (otherwise) [t6<0]

  # If they have different signs, the accumulator changed sign
  blt t5, x0, code_200

  j loop               # If passed, jump to the next iteration

code_0:                # Success case
  mv a0, x0            # Load success code
  mv a1, t1            # Copy the dot product to a1
  j dot_end

code_50:
  li a0, 50            # Load error code 50 into a0
  j dot_end

code_200:
  li a0, 200           # Load error code 200 into a0

dot_end:               
  jr ra                # Normal return