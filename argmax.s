# You can change these values to test your solution.
.data
ARRAY: .word -6 -1 6 1
SIZE:  .word 4

.text
main:
  la a1, ARRAY             # a1 = pointer to array
  lw a2, SIZE              # a2 = number of elements in the array
  jal ra, argmax           # call argmax function
exit:
  li a7, 10                # exit syscall code
  ecall                    # terminate the program

# ==========================================================================
# FUNCTION: argmax
#   Takes an array of integers and returns the index of the largest element.
#   If there are multiple elements with the same maximum value, 
#   it should return the smallest index among them.
# Arguments:
#   a1 = pointer to int array
#   a2 = array length
# Returns:
#   a0 = status code
#   a1 = index of the largest element
# ===========================================================================
argmax:
  # Check exception
  li t0, 1                 # t0 = 1 (minimum valid array length)
  blt a2, t0, code_50      # If length < 1, jump to code_50
  
  # Initialization
  mv a0, x0                # Restore status code 0(success)
  mv t0, x0                # t0 = index of current maximum
  lw t1, 0(a1)             # t1 = value of the current maximum
  mv t2, x0                # t2 = current index
  
loop:
  lw t3, 0(a1)             # t3 = value of current element pointed to by a1
  bge t1, t3, step         # If current max >= current element, skip update
  
  # Update
  mv t0, t2                # Update max index to current index
  mv t1, t3                # Update max value to current value
  j step                   # Jump to increment section
  
step:
  addi t2, t2, 1           # Increment the index counter
  beq t2, a2, loop_end     # If we've reached the end of the array, exit loop
  addi a1, a1, 4           # Increment pointer by 4 bytes (next int)
  j loop                   # Repeat the loop
 
loop_end:
  mv a1, t0                # Move max index into a1 (return value)
  j argmax_end
 
code_50:
  li a0, 50                # Load error code 50 into a0

argmax_end:
  jr ra                    # return to the caller
