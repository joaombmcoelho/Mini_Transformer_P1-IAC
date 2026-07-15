# You can change these values to test your solution.
.data
ARRAY: .word -6 -1 6 1
SIZE:  .word 4
INDEX: .word 2

.text
main:
  la a1, ARRAY      # a1 = pointer to array
  lw a2, SIZE       # a2 = array length
  lw a3, INDEX      # a3 = element index
  jal ra, select    # call select function
exit:
  li a7, 10         # exit syscall code
  ecall             # terminate the program

# ==========================================================================
# FUNCTION: select
#   This function selects an element from an integer array.
# Arguments:
#   a1 = pointer to int array
#   a2 = array length
#   a3 = element index
# Returns:
#   a0 = status code
#   a1 = value of the selected element
# ===========================================================================
select:
  # Check exception code 50
  li t0, 1                   # t0 is the minimum array size (1)
  blt a2, t0, code_50        # Jump to code 50 if SIZE (a2) < t0

  # Check exception code 100 (index out of range)
  bltz a3, code_100          # Jump to code 100 if INDEX (a3) < 0
  bge a3, a2, code_100       # Jump to code 100 if INDEX (a3) >= SIZE

  # Code 0 (success)
  slli t1, a3, 2             # Converts the index to bytes
  add a1, a1, t1             # Memory adress of the element with that index
  lw a1, 0(a1)               # Load element into a1
  
  mv a0, x0                  # Move x0 to a0
  j select_end

code_50:
  li a0, 50                  # Load error code 50 into a0
  j select_end

code_100:
  li a0, 100                 # Load error code 100 into a0

select_end:
  jr ra                      # return to the caller

