# Intro to Mini-transformer - Introduction to Computer Architecture
Assembly RISC-V implementation of fundamental mathematical operations for a simplified machine learning attention mechanism (Mini-Transformer)

### Team
* [João Coelho](https://github.com/joaombmcoelho) (me) — Implemented the `dot` function.
* [Sara Cruz] — Implemented the `argmax` function.
* [Rita Vieira] - Implemented the `select` function.
  
### Final Grade
* 20/20

### Project Features
* Vector Element Selection: Implementation of the `select` function to retrieve vector values with boundary and index checks
* Index of Maximum Element: `argmax` algorithm to find the smallest index of the largest value in signed integer arrays
* Dot Product Engine: Custom `dot` product calculation supporting signed integers multiplication, designed to handle argument validation and overflow detection

### Compilation
Assemble and simulate the project using the Ripes simulator configured for a 32-bit RISC-V single-cycle processor

### Run
To test individual modules, load the corresponding assembly files in Ripes:
* `select.s`
* `argmax.s`
* `dot.s`
